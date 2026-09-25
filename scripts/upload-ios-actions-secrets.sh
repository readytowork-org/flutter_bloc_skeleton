#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/upload-ios-actions-secrets.sh --type development|production --env RELATIVE_PATH [--dry-run]
       scripts/upload-ios-actions-secrets.sh --slack-webhook

Examples:
  scripts/upload-ios-actions-secrets.sh --type development --env env/dev
  scripts/upload-ios-actions-secrets.sh --type production --env env/prod
  scripts/upload-ios-actions-secrets.sh --slack-webhook

RELATIVE_PATH is relative to the repository root. It must contain:
  config.dart, firebase_options.dart, GoogleService-Info.plist,
  fastlane/.env, fastlane/store.json, and the
  .p8 file named by store.json's key_filepath (for example ./AuthKey_ABC123.p8).
Development uses DEV_ repository secrets. Production uses PROD_ secrets in
the production GitHub environment.
--slack-webhook prompts for a Slack incoming webhook URL without echoing it,
then uploads it as the repository secret SLACK_WEBHOOK_URL.
USAGE
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

target_type=''
env_path=''
dry_run=false
upload_slack_webhook=false
while (($#)); do
  case "$1" in
    --type)
      (($# >= 2)) || fail '--type needs development or production'
      target_type="$2"
      shift 2
      ;;
    --env)
      (($# >= 2)) || fail '--env needs a path relative to the repository root'
      env_path="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --slack-webhook)
      upload_slack_webhook=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      fail "Unknown argument: $1"
      ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
remote_url="$(git -C "$repo_root" remote get-url origin)" ||
  fail 'Cannot read the origin Git remote'
case "$remote_url" in
  git@github.com:*) repo_slug="${remote_url#git@github.com:}" ;;
  https://github.com/*) repo_slug="${remote_url#https://github.com/}" ;;
  ssh://git@github.com/*) repo_slug="${remote_url#ssh://git@github.com/}" ;;
  *) fail 'The origin remote must be a GitHub repository' ;;
esac
repo_slug="${repo_slug%.git}"
[[ "$repo_slug" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] ||
  fail 'Invalid GitHub repository in origin remote'

if [[ "$upload_slack_webhook" == true ]]; then
  [[ -z "$target_type" && -z "$env_path" && "$dry_run" == false ]] ||
    fail '--slack-webhook must be used on its own'
  command -v gh >/dev/null || fail 'Install GitHub CLI (gh) first'
  gh auth status -h github.com >/dev/null 2>&1 ||
    fail 'Run gh auth login before uploading secrets'
  gh secret list --app actions --repo "$repo_slug" >/dev/null 2>&1 ||
    fail "Cannot access repository Actions secrets in $repo_slug"
  [[ -t 0 ]] || fail 'Run --slack-webhook from an interactive terminal'
  IFS= read -r -s -p 'Paste Slack incoming webhook URL: ' slack_webhook_url < /dev/tty ||
    fail 'Could not read the Slack webhook URL'
  printf '\n' >&2
  [[ "$slack_webhook_url" =~ ^https://hooks\.(slack\.com|slack-gov\.com)/services/[^[:space:]]+$ ]] ||
    fail 'Expected a Slack incoming webhook URL under hooks.slack.com/services/'
  printf '%s' "$slack_webhook_url" |
    gh secret set SLACK_WEBHOOK_URL --app actions --repo "$repo_slug"
  unset slack_webhook_url
  printf 'Uploaded SLACK_WEBHOOK_URL to repository Actions secrets in %s\n' "$repo_slug"
  exit 0
fi

[[ "$target_type" == development || "$target_type" == production ]] ||
  fail '--type must be development or production'
[[ -n "$env_path" && "$env_path" != /* ]] ||
  fail '--env must be a relative path'

source_dir="$(cd "$repo_root/$env_path" 2>/dev/null && pwd -P)" ||
  fail "Environment directory does not exist: $env_path"
[[ "$source_dir" == "$repo_root/"* ]] ||
  fail '--env must stay inside this repository'
if [[ "$target_type" == development && "$source_dir" == "$repo_root/env/prod" ]] ||
   [[ "$target_type" == production && "$source_dir" == "$repo_root/env/dev" ]]; then
  fail 'The selected environment directory does not match --type'
fi

fastlane_dir="$source_dir/fastlane"
for file in config.dart firebase_options.dart GoogleService-Info.plist; do
  [[ -s "$source_dir/$file" ]] ||
    fail "Missing or empty file: $source_dir/$file"
done
for file in .env store.json; do
  [[ -s "$fastlane_dir/$file" ]] ||
    fail "Missing or empty file: $fastlane_dir/$file"
done
command -v ruby >/dev/null || fail 'Ruby is needed to validate store.json'
p8_name="$(ruby -rjson -e '
  data = JSON.parse(File.read(ARGV.fetch(0)))
  abort unless %w[key_id issuer_id].all? { |name| data[name].is_a?(String) && !data[name].empty? }
  path = data.fetch("key_filepath")
  abort unless path.is_a?(String) && path.match?(/\A\.\/[A-Za-z0-9._-]+\.p8\z/)
  print File.basename(path)
' "$fastlane_dir/store.json" 2>/dev/null)" ||
  fail 'Invalid store.json: expected key_id, issuer_id, and ./<filename>.p8 in key_filepath'
[[ -s "$fastlane_dir/$p8_name" ]] ||
  fail "Missing or empty .p8 file named by store.json: $fastlane_dir/$p8_name"

if [[ "$target_type" == development ]]; then
  secret_scope='repository'
  secret_prefix='DEV_'
  secret_args=(--app actions --repo "$repo_slug")
else
  secret_scope='production environment'
  secret_prefix='PROD_'
  secret_args=(--app actions --repo "$repo_slug" --env production)
fi
printf 'Repository: %s\nSecret scope: %s\nLocal config: %s\n' \
  "$repo_slug" "$secret_scope" "$source_dir"

if [[ "$dry_run" == true ]]; then
  printf '%s\n' 'Dry run: files are present; no secrets were uploaded.'
  exit 0
fi

# A GitHub-hosted runner cannot use the signing identity installed on this Mac.
# Fail before uploading secrets when the Match settings needed by the lane are absent.
ruby - "$fastlane_dir/.env" <<'RUBY' || fail 'Complete the Match settings in fastlane/.env before uploading Actions secrets'
values = {}
File.foreach(ARGV.fetch(0)) do |line|
  match = line.match(/\A\s*(MATCH_GIT_URL|MATCH_STORAGE_MODE|MATCH_TYPE|MATCH_PASSWORD|MATCH_GIT_BASIC_AUTHORIZATION)\s*=\s*(.*?)\s*\z/)
  next unless match
  values[match[1]] = match[2].sub(/\A["']/, '').sub(/["']\z/, '')
end
required = %w[MATCH_GIT_URL MATCH_STORAGE_MODE MATCH_TYPE MATCH_PASSWORD MATCH_GIT_BASIC_AUTHORIZATION]
missing = required.select { |key| values[key].nil? || values[key].empty? }
unless missing.empty?
  warn "Missing Fastlane Match values: #{missing.join(', ')}"
  exit 1
end
RUBY

command -v gh >/dev/null || fail 'Install GitHub CLI (gh) first'
gh auth status -h github.com >/dev/null 2>&1 ||
  fail 'Run gh auth login before uploading secrets'
gh secret list "${secret_args[@]}" \
  >/dev/null 2>&1 ||
  fail "Cannot access $secret_scope Actions secrets in $repo_slug"

upload_base64() {
  local secret_name="$1"
  local source_file="$2"
  base64 < "$source_file" | tr -d '\r\n' |
    gh secret set "${secret_prefix}${secret_name}" "${secret_args[@]}"
  printf 'Uploaded %s%s (%s)\n' "$secret_prefix" "$secret_name" "$secret_scope"
}

upload_base64 CONFIG_DART_BASE64 "$source_dir/config.dart"
upload_base64 FIREBASE_OPTIONS_BASE64 "$source_dir/firebase_options.dart"
upload_base64 GOOGLE_SERVICE_PLIST_BASE64 "$source_dir/GoogleService-Info.plist"
upload_base64 ASC_P8_BASE64 "$fastlane_dir/$p8_name"
upload_base64 FASTLANE_ENV_BASE64 "$fastlane_dir/.env"
gh secret set "${secret_prefix}ASC_JSON_KEY" "${secret_args[@]}" \
  < "$fastlane_dir/store.json"
printf 'Uploaded %sASC_JSON_KEY (%s)\n' "$secret_prefix" "$secret_scope"
printf '%s\n' 'File-backed secrets uploaded. Fastlane variables come from the selected .env.'
