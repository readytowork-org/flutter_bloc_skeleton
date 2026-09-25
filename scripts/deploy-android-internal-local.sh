#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source_dir="$repo_root/env/dev"

for file in config.dart firebase_options.dart google-services.json release-key.jks fastlane/play-service-account.json fastlane/android.env; do
  [[ -s "$source_dir/$file" ]] || fail "Missing or empty development file: env/dev/$file"
done
[[ -s "$repo_root/android/key.properties" ]] || fail 'Missing android/key.properties'
grep -Eq '^storeFile[[:space:]]*=[[:space:]]*release-key\.jks[[:space:]]*$' "$repo_root/android/key.properties" ||
  fail 'Expected storeFile=release-key.jks in android/key.properties'

command -v flutter >/dev/null || fail 'Flutter is required'
command -v bundle >/dev/null || fail 'Bundler is required'
(cd "$repo_root/android" && bundle check >/dev/null) ||
  fail 'Fastlane gems are missing; run bundle install in android first'

targets=(
  lib/config.dart
  lib/firebase_options.dart
  android/app/google-services.json
  android/app/release-key.jks
  android/fastlane/play-service-account.json
  android/fastlane/report.xml
  android/fastlane/.env
)

backup_dir="$(mktemp -d "${TMPDIR:-/tmp}/skeleton-android-internal.XXXXXX")"
chmod 700 "$backup_dir"
restore_files() {
  local target
  for target in "${targets[@]}"; do
    if [[ -f "$backup_dir/$target" ]]; then
      cp -p "$backup_dir/$target" "$repo_root/$target"
    else
      rm -f "$repo_root/$target"
    fi
  done
  rm -rf "$backup_dir"
}

for target in "${targets[@]}"; do
  if [[ -f "$repo_root/$target" ]]; then
    mkdir -p "$backup_dir/$(dirname "$target")"
    cp -p "$repo_root/$target" "$backup_dir/$target"
  fi
done
trap restore_files EXIT

cp "$source_dir/config.dart" "$repo_root/lib/config.dart"
cp "$source_dir/firebase_options.dart" "$repo_root/lib/firebase_options.dart"
cp "$source_dir/google-services.json" "$repo_root/android/app/google-services.json"
cp "$source_dir/release-key.jks" "$repo_root/android/app/release-key.jks"
cp "$source_dir/fastlane/play-service-account.json" "$repo_root/android/fastlane/play-service-account.json"
cp "$source_dir/fastlane/android.env" "$repo_root/android/fastlane/.env"
chmod 600 "$repo_root/android/app/release-key.jks" "$repo_root/android/fastlane/play-service-account.json" "$repo_root/android/fastlane/.env"

(cd "$repo_root" && flutter pub get)
(cd "$repo_root/android" && bundle exec fastlane android internal)
