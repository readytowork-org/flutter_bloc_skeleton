#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source_dir="$repo_root/env/dev"
fastlane_dir="$source_dir/fastlane"

for file in config.dart firebase_options.dart GoogleService-Info.plist; do
  [[ -s "$source_dir/$file" ]] || fail "Missing or empty development file: env/dev/$file"
done
for file in .env store.json; do
  [[ -s "$fastlane_dir/$file" ]] || fail "Missing or empty Fastlane file: env/dev/fastlane/$file"
done

command -v ruby >/dev/null || fail 'Ruby is required'
command -v flutter >/dev/null || fail 'Flutter is required'
command -v bundle >/dev/null || fail 'Bundler is required'

p8_name="$(ruby -rjson -e '
  data = JSON.parse(File.read(ARGV.fetch(0)))
  abort unless %w[key_id issuer_id].all? { |name| data[name].is_a?(String) && !data[name].empty? }
  path = data.fetch("key_filepath")
  abort unless path.is_a?(String) && path.match?(/\A\.\/[A-Za-z0-9._-]+\.p8\z/)
  print File.basename(path)
' "$fastlane_dir/store.json" 2>/dev/null)" || fail 'Invalid env/dev/fastlane/store.json'
[[ -s "$fastlane_dir/$p8_name" ]] || fail "Missing App Store Connect key: env/dev/fastlane/$p8_name"

(cd "$repo_root/ios" && bundle check >/dev/null) ||
  fail 'Fastlane gems are missing; run bundle install in ios first'

targets=(
  lib/config.dart
  lib/firebase_options.dart
  ios/Runner/GoogleService-Info.plist
  ios/Runner.xcodeproj/project.pbxproj
  ios/Flutter/AppFrameworkInfo.plist
  ios/fastlane/README.md
  ios/fastlane/report.xml
  ios/fastlane/.env
  ios/fastlane/store.json
  "ios/fastlane/$p8_name"
)

backup_dir="$(mktemp -d "${TMPDIR:-/tmp}/skeleton-testflight.XXXXXX")"
chmod 700 "$backup_dir"
trap 'rm -rf "$backup_dir"' EXIT

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
cp "$source_dir/GoogleService-Info.plist" "$repo_root/ios/Runner/GoogleService-Info.plist"
cp "$fastlane_dir/store.json" "$repo_root/ios/fastlane/store.json"
cp "$fastlane_dir/$p8_name" "$repo_root/ios/fastlane/$p8_name"
cp "$fastlane_dir/.env" "$repo_root/ios/fastlane/.env"
chmod 600 "$repo_root/ios/fastlane/store.json" "$repo_root/ios/fastlane/$p8_name" "$repo_root/ios/fastlane/.env"

(cd "$repo_root" && flutter pub get)
(cd "$repo_root/ios" && bundle exec fastlane ios beta)
