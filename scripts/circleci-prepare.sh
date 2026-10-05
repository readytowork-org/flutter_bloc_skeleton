#!/usr/bin/env bash
set -euo pipefail

platform="${1:-}"
mode="${2:-}"
[[ "$platform" == ios || "$platform" == android ]] || {
  echo 'Usage: circleci-prepare.sh ios|android build|deploy' >&2
  exit 2
}
[[ "$mode" == build || "$mode" == deploy ]] || {
  echo 'Usage: circleci-prepare.sh ios|android build|deploy' >&2
  exit 2
}

cd "$(dirname "$0")/.."
umask 077

require_var() {
  [[ -n "${!1:-}" ]] || { echo "Missing CircleCI context variable: $1" >&2; exit 1; }
}

write_base64() {
  local name="$1" destination="$2"
  require_var "$name"
  mkdir -p "$(dirname "$destination")"
  if [[ "$(uname)" == Darwin ]]; then
    printf '%s' "${!name}" | base64 -D > "$destination"
  else
    printf '%s' "${!name}" | base64 --decode > "$destination"
  fi
}

write_base64 CONFIG_DART_BASE64 lib/config.dart
write_base64 FIREBASE_OPTIONS_BASE64 lib/firebase_options.dart
if [[ "$platform" == ios ]]; then
  write_base64 GOOGLE_SERVICE_PLIST_BASE64 ios/Runner/GoogleService-Info.plist
else
  write_base64 ANDROID_GOOGLE_SERVICES_BASE64 android/app/google-services.json
fi

if [[ "$mode" == build ]]; then
  exit 0
fi

require_var SLACK_WEBHOOK_URL
if [[ "$platform" == ios ]]; then
  require_var ASC_JSON_KEY
  printf '%s' "$ASC_JSON_KEY" > ios/fastlane/store.json
  p8_name="$(ruby -rjson -e 'path = JSON.parse(File.read(ARGV.fetch(0))).fetch("key_filepath"); abort "Invalid key_filepath" unless path.is_a?(String) && path.match?(/\A\.\/[A-Za-z0-9._-]+\.p8\z/); print File.basename(path)' ios/fastlane/store.json)"
  write_base64 ASC_P8_BASE64 "ios/fastlane/$p8_name"
  write_base64 FASTLANE_ENV_BASE64 ios/fastlane/.env
else
  write_base64 ANDROID_KEY_PROPERTIES_BASE64 android/key.properties
  grep -Eq '^storeFile[[:space:]]*=[[:space:]]*release-key\.jks[[:space:]]*$' android/key.properties || {
    echo 'Expected storeFile=release-key.jks in key.properties' >&2
    exit 1
  }
  write_base64 ANDROID_KEYSTORE_BASE64 android/app/release-key.jks
  require_var PLAY_SERVICE_ACCOUNT_JSON
  printf '%s' "$PLAY_SERVICE_ACCOUNT_JSON" > android/fastlane/play-service-account.json
  write_base64 ANDROID_FASTLANE_ENV_BASE64 android/fastlane/.env
fi
