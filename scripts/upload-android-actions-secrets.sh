#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/upload-android-actions-secrets.sh --type development|production --env env/dev|env/prod [--dry-run]

Required local files: env/<type>/{config.dart,firebase_options.dart,google-services.json,release-key.jks},
  env/<type>/fastlane/play-service-account.json, android/key.properties,
  plus env/<type>/fastlane/android.env containing ANDROID_PACKAGE_NAME.
The service-account JSON is from Google Cloud and must have Google Play Console access.
Development secrets use the DEV_ repository prefix; production uses PROD_ in the production environment.
USAGE
}

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

target_type=''
env_path=''
dry_run=false
while (($#)); do
  case "$1" in
    --type) (($# >= 2)) || fail '--type needs a value'; target_type="$2"; shift 2 ;;
    --env) (($# >= 2)) || fail '--env needs a value'; env_path="$2"; shift 2 ;;
    --dry-run) dry_run=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; fail "Unknown argument: $1" ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
case "$target_type:$env_path" in
  development:env/dev) secret_prefix='DEV_'; secret_scope='repository' ;;
  production:env/prod) secret_prefix='PROD_'; secret_scope='production environment' ;;
  *) fail 'Use --type development --env env/dev or --type production --env env/prod' ;;
esac
source_dir="$repo_root/$env_path"
for file in config.dart firebase_options.dart google-services.json release-key.jks; do
  [[ -s "$source_dir/$file" ]] || fail "Missing or empty file: $source_dir/$file"
done
[[ -s "$source_dir/fastlane/android.env" ]] || fail "Missing Android Fastlane .env"
[[ -s "$source_dir/fastlane/play-service-account.json" ]] ||
  fail "Missing or empty file: $source_dir/fastlane/play-service-account.json"
for file in android/key.properties; do
  [[ -s "$repo_root/$file" ]] || fail "Missing or empty file: $repo_root/$file"
done
grep -Eq '^storeFile[[:space:]]*=[[:space:]]*release-key\.jks[[:space:]]*$' "$repo_root/android/key.properties" ||
  fail 'Expected storeFile=release-key.jks in android/key.properties'


command -v python3 >/dev/null || fail 'Python 3 is needed to validate the service account JSON'
python3 - "$source_dir/fastlane/play-service-account.json" <<'PY' || fail 'Expected a Google service account JSON with client_email and private_key'
import json, sys
with open(sys.argv[1], encoding='utf-8') as handle:
    data = json.load(handle)
assert data.get('type') == 'service_account'
assert data.get('client_email') and data.get('private_key')
PY

remote_url="$(git -C "$repo_root" remote get-url origin)" || fail 'Cannot read the origin Git remote'
case "$remote_url" in
  git@github.com:*) repo_slug="${remote_url#git@github.com:}" ;;
  https://github.com/*) repo_slug="${remote_url#https://github.com/}" ;;
  ssh://git@github.com/*) repo_slug="${remote_url#ssh://git@github.com/}" ;;
  *) fail 'The origin remote must be a GitHub repository' ;;
esac
repo_slug="${repo_slug%.git}"
[[ "$repo_slug" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || fail 'Invalid GitHub repository in origin remote'

printf 'Repository: %s\nSecret scope: %s\nLocal config: %s\n' "$repo_slug" "$secret_scope" "$source_dir"
if [[ "$dry_run" == true ]]; then
  printf '%s\n' 'Dry run: local files are present; no secrets were uploaded.'
  exit 0
fi

command -v gh >/dev/null || fail 'Install GitHub CLI (gh) first'
gh auth status -h github.com >/dev/null 2>&1 || fail 'Run gh auth login before uploading secrets'
secret_args=(--app actions --repo "$repo_slug")
[[ "$target_type" == production ]] && secret_args+=(--env production)
gh secret list "${secret_args[@]}" >/dev/null 2>&1 || fail "Cannot access $secret_scope Actions secrets"

upload_base64() {
  local name="$1" source_file="$2"
  base64 < "$source_file" | tr -d '\r\n' |
    gh secret set "${secret_prefix}${name}" "${secret_args[@]}"
  printf 'Uploaded %s%s (%s)\n' "$secret_prefix" "$name" "$secret_scope"
}

upload_base64 CONFIG_DART_BASE64 "$source_dir/config.dart"
upload_base64 FIREBASE_OPTIONS_BASE64 "$source_dir/firebase_options.dart"
upload_base64 ANDROID_GOOGLE_SERVICES_BASE64 "$source_dir/google-services.json"
upload_base64 ANDROID_FASTLANE_ENV_BASE64 "$source_dir/fastlane/android.env"
upload_base64 ANDROID_KEY_PROPERTIES_BASE64 "$repo_root/android/key.properties"
upload_base64 ANDROID_KEYSTORE_BASE64 "$source_dir/release-key.jks"
gh secret set "${secret_prefix}PLAY_SERVICE_ACCOUNT_JSON" "${secret_args[@]}" < "$source_dir/fastlane/play-service-account.json"
printf 'Uploaded %sPLAY_SERVICE_ACCOUNT_JSON (%s)\n' "$secret_prefix" "$secret_scope"
