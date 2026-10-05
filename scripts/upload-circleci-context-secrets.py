#!/usr/bin/env python3
"""Upsert private Flutter/Fastlane files into the CircleCI contexts used by CI."""

import argparse
import base64
import getpass
import json
import os
from pathlib import Path
import re
import sys
import urllib.error
import urllib.request
import uuid


ROOT = Path(__file__).resolve().parent.parent
P8_NAME = re.compile(r"^\./[A-Za-z0-9._-]+\.p8$")
MATCH_KEYS = (
    "MATCH_GIT_URL",
    "MATCH_STORAGE_MODE",
    "MATCH_TYPE",
    "MATCH_PASSWORD",
    "MATCH_GIT_BASIC_AUTHORIZATION",
)


def fail(message: str) -> None:
    raise ValueError(message)


def required_file(path: Path) -> Path:
    if not path.is_file() or path.stat().st_size == 0:
        fail(f"Missing or empty file: {path}")
    return path


def encoded(path: Path) -> str:
    return base64.b64encode(required_file(path).read_bytes()).decode("ascii")


def raw(path: Path) -> str:
    return required_file(path).read_text(encoding="utf-8")


def context_id(name: str) -> str:
    value = os.environ.get(name, "")
    try:
        return str(uuid.UUID(value))
    except ValueError:
        fail(f"Set {name} to the CircleCI context UUID")


def match_env_is_complete(contents: str) -> None:
    values = {}
    for line in contents.splitlines():
        match = re.match(r"^\s*(MATCH_[A-Z_]+)\s*=\s*(.*?)\s*$", line)
        if match:
            values[match.group(1)] = match.group(2).strip("\"'")
    missing = [key for key in MATCH_KEYS if not values.get(key)]
    if missing:
        fail(f"Missing Fastlane Match values in fastlane/.env: {', '.join(missing)}")


def files_for_environment(source: Path) -> tuple[dict[str, str], dict[str, str]]:
    common = {
        "CONFIG_DART_BASE64": encoded(source / "config.dart"),
        "FIREBASE_OPTIONS_BASE64": encoded(source / "firebase_options.dart"),
        "GOOGLE_SERVICE_PLIST_BASE64": encoded(source / "GoogleService-Info.plist"),
        "ANDROID_GOOGLE_SERVICES_BASE64": encoded(source / "google-services.json"),
    }

    fastlane = source / "fastlane"
    store_json = raw(fastlane / "store.json")
    try:
        store = json.loads(store_json)
        key_path = store["key_filepath"]
        if not all(isinstance(store.get(key), str) and store[key] for key in ("key_id", "issuer_id")):
            fail("store.json needs nonempty key_id and issuer_id")
        if not isinstance(key_path, str) or not P8_NAME.fullmatch(key_path):
            fail("store.json key_filepath must be ./<filename>.p8")
    except (json.JSONDecodeError, KeyError, TypeError) as error:
        fail(f"Invalid fastlane/store.json: {error}")

    ios_env = raw(fastlane / ".env")
    match_env_is_complete(ios_env)
    android_env = raw(fastlane / "android.env")
    if not re.search(r"^\s*ANDROID_PACKAGE_NAME\s*=\s*\S+", android_env, re.MULTILINE):
        fail("fastlane/android.env needs ANDROID_PACKAGE_NAME")

    key_properties = ROOT / "android" / "key.properties"
    if not re.search(
        r"^\s*storeFile\s*=\s*release-key\.jks\s*$",
        raw(key_properties),
        re.MULTILINE,
    ):
        fail("android/key.properties must contain storeFile=release-key.jks")
    play_json = raw(fastlane / "play-service-account.json")
    try:
        play = json.loads(play_json)
        if play.get("type") != "service_account" or not play.get("client_email") or not play.get("private_key"):
            fail("Play JSON needs service_account type, client_email, and private_key")
    except (json.JSONDecodeError, AttributeError) as error:
        fail(f"Invalid Play service-account JSON: {error}")

    deployment = {
        "ASC_JSON_KEY": store_json,
        "ASC_P8_BASE64": encoded(fastlane / key_path),
        "FASTLANE_ENV_BASE64": base64.b64encode(ios_env.encode()).decode("ascii"),
        "ANDROID_KEY_PROPERTIES_BASE64": encoded(key_properties),
        "ANDROID_KEYSTORE_BASE64": encoded(source / "release-key.jks"),
        "PLAY_SERVICE_ACCOUNT_JSON": play_json,
        "ANDROID_FASTLANE_ENV_BASE64": base64.b64encode(android_env.encode()).decode("ascii"),
    }
    return common, deployment


def upload(token: str, target: str, name: str, value: str) -> None:
    url = f"https://circleci.com/api/v2/context/{target}/environment-variable/{name}"
    request = urllib.request.Request(
        url,
        data=json.dumps({"value": value}).encode("utf-8"),
        headers={"Circle-Token": token, "Content-Type": "application/json"},
        method="PUT",
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            if response.status != 200:
                fail(f"CircleCI rejected {name}: HTTP {response.status}")
    except urllib.error.HTTPError as error:
        fail(f"CircleCI rejected {name}: HTTP {error.code}")
    except urllib.error.URLError as error:
        fail(f"Could not reach CircleCI while uploading {name}: {error.reason}")
    print(f"Uploaded {name}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--type", choices=("development", "production"), required=True)
    parser.add_argument("--env", help="environment directory relative to repository root")
    parser.add_argument("--dry-run", action="store_true", help="validate files without uploading")
    parser.add_argument("--slack-webhook", action="store_true", help="prompt for and upload Slack webhook only")
    args = parser.parse_args()

    if args.slack_webhook:
        if args.env or args.dry_run:
            fail("--slack-webhook cannot be combined with --env or --dry-run")
        target_name = (
            "CIRCLECI_BUILD_CONTEXT_ID" if args.type == "development"
            else "CIRCLECI_PRODUCTION_CONTEXT_ID"
        )
        target = context_id(target_name)
        token = os.environ.get("CIRCLECI_TOKEN", "")
        if not token:
            fail("Set CIRCLECI_TOKEN to a CircleCI personal API token")
        webhook = getpass.getpass("Paste Slack incoming webhook URL: ")
        if not re.fullmatch(r"https://hooks\.(?:slack\.com|slack-gov\.com)/services/\S+", webhook):
            fail("Expected a Slack incoming webhook URL")
        upload(token, target, "SLACK_WEBHOOK_URL", webhook)
        return

    if not args.env or Path(args.env).is_absolute():
        fail("Use --env with a path relative to the repository root")
    source = (ROOT / args.env).resolve()
    if not source.is_relative_to(ROOT) or not source.is_dir():
        fail("--env must name an existing directory inside this repository")
    if args.type == "development" and source == ROOT / "env" / "prod":
        fail("Production files cannot be uploaded to development contexts")
    if args.type == "production" and source == ROOT / "env" / "dev":
        fail("Development files cannot be uploaded to the production context")

    common, deployment = files_for_environment(source)
    oversized = [
        name for name, value in {**common, **deployment}.items()
        if len(value) > 32_000
    ]
    if oversized:
        fail(f"CircleCI context value exceeds 32k characters: {', '.join(oversized)}")
    print(f"Local files validated for {args.type}; {len(common) + len(deployment)} variables prepared")
    if args.dry_run:
        print("Dry run: no CircleCI variables uploaded")
        return

    token = os.environ.get("CIRCLECI_TOKEN", "")
    if not token:
        fail("Set CIRCLECI_TOKEN to a CircleCI personal API token")
    if args.type == "development":
        build_id = context_id("CIRCLECI_BUILD_CONTEXT_ID")
        development_id = context_id("CIRCLECI_DEVELOPMENT_CONTEXT_ID")
        for name, value in common.items():
            upload(token, build_id, name, value)
        for name, value in deployment.items():
            upload(token, development_id, name, value)
    else:
        production_id = context_id("CIRCLECI_PRODUCTION_CONTEXT_ID")
        for name, value in {**common, **deployment}.items():
            upload(token, production_id, name, value)


if __name__ == "__main__":
    try:
        main()
    except ValueError as error:
        print(f"Error: {error}", file=sys.stderr)
        sys.exit(1)
