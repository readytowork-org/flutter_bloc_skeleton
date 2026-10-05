# CircleCI for the Flutter skeleton

CircleCI uses the Fastlane lanes already used locally. `pubspec.yaml` supplies the
version. PR and non-`develop` branch pipelines only check unsigned iOS and
Android builds; they do not run unit or integration tests.

| Event | CircleCI result |
| --- | --- |
| PR opened, or any commit pushed to a branch other than `develop` | Unsigned iOS and Android build checks; no upload |
| Any commit pushed to `develop`, including a merge | iOS and Android build checks, then development iOS build to internal-only TestFlight and Android build to Play internal testing |
| `v<major>.<minor>.<patch>` tag on a commit in `main` | Production iOS build to App Store Connect/TestFlight; Android production **draft** in Play Console |
| Manual pipeline with `action=ios_testflight` or `android_internal` | The selected development upload only |
| Manual pipeline on `main` with `action=ios_production` or `android_production` | The selected production upload only |

The Android production lane creates a draft; it does not send changes for review
or start a rollout. The iOS production lane uploads the build to App Store
Connect/TestFlight without submitting an App Store version for review.
Direct pushes to `develop` also deploy; CircleCI treats them like merge commits.
Other branch pushes and PR events do not deploy. The tag must match the version
in `pubspec.yaml`, and its commit must be reachable from `main`.

## Configure CircleCI triggers

1. Connect `readytowork-org/flutter_bloc_skeleton` as a CircleCI project using
   the GitHub App integration and `.circleci/config.yml` as the config file.
   [GitHub App event triggers](https://circleci.com/docs/guides/orchestrate/github-trigger-event-options/)
   provide the PR event used in this config.
2. In **Project Settings → Project Setup**, keep or add **All pushes** and add
   **PR opened** as a separate trigger. Use the default pipeline parameter
   `action=ci` for both. All pushes covers ordinary branch commits, merges to
   `develop`, and version tags. Do not also add **Tag pushes** or **Pushes to
   open non-draft PRs**: those would duplicate pipelines for the same push.
   Add **PR marked ready for review** if draft PRs are used.
3. Protect `main`, `develop`, and `v*` release tags in GitHub. Only trusted
   release maintainers should be able to create release tags.
4. Create the three contexts in **Organization Settings → Contexts**. Restrict
   deployment contexts to this project and trusted maintainers. For the
   development context, use an expression restriction such as:

   ```text
   ((pipeline.event.name == "push" and pipeline.git.branch == "develop") or
    pipeline.event.name == "api") and not job.ssh.enabled
   ```

   For the production context, replace an existing `main`-only expression restriction
   with this single expression so tagged pipelines can use it:

   ```text
   ((pipeline.event.name == "api" and pipeline.git.branch == "main") or
    (pipeline.event.name == "push" and pipeline.git.tag matches /^v[0-9]+\.[0-9]+\.[0-9]+$/))
   and not job.ssh.enabled
   ```

   `pipeline.git.branch` is empty for a tag checkout. An old `main`-only
   restriction would reject the release jobs. Keep “Pass secrets to builds from
   forked pull requests” disabled.

## Context variables

| Context | Variables |
| --- | --- |
| `flutter-skeleton-build` | `CONFIG_DART_BASE64`, `FIREBASE_OPTIONS_BASE64`, `GOOGLE_SERVICE_PLIST_BASE64`, `ANDROID_GOOGLE_SERVICES_BASE64`, `SLACK_WEBHOOK_URL` |
| `flutter-skeleton-development` | `ASC_JSON_KEY`, `ASC_P8_BASE64`, `FASTLANE_ENV_BASE64`, `ANDROID_KEY_PROPERTIES_BASE64`, `ANDROID_KEYSTORE_BASE64`, `PLAY_SERVICE_ACCOUNT_JSON`, `ANDROID_FASTLANE_ENV_BASE64` |
| `flutter-skeleton-production` | All variables in the two rows above, with production values |

Use the application IDs, Apple API key, Match repository, Android upload key,
and Play service account that work with the local lanes. The `*_BASE64` values
are single-line encodings of file content, for example
`base64 < env/dev/config.dart | tr -d '\r\n'`. `ASC_JSON_KEY` and
`PLAY_SERVICE_ACCOUNT_JSON` contain raw JSON text. `SLACK_WEBHOOK_URL` is the
incoming webhook URL.

| Variable | Local source file |
| --- | --- |
| `CONFIG_DART_BASE64` | `env/<dev-or-prod>/config.dart` |
| `FIREBASE_OPTIONS_BASE64` | `env/<dev-or-prod>/firebase_options.dart` |
| `GOOGLE_SERVICE_PLIST_BASE64` | `env/<dev-or-prod>/GoogleService-Info.plist` |
| `ANDROID_GOOGLE_SERVICES_BASE64` | `env/<dev-or-prod>/google-services.json` |
| `ASC_JSON_KEY` | `env/<dev-or-prod>/fastlane/store.json` |
| `ASC_P8_BASE64` | The `.p8` named by `store.json`'s `key_filepath` |
| `FASTLANE_ENV_BASE64` | `env/<dev-or-prod>/fastlane/.env` |
| `ANDROID_KEY_PROPERTIES_BASE64` | `android/key.properties` |
| `ANDROID_KEYSTORE_BASE64` | `env/<dev-or-prod>/release-key.jks` |
| `PLAY_SERVICE_ACCOUNT_JSON` | `env/<dev-or-prod>/fastlane/play-service-account.json` |
| `ANDROID_FASTLANE_ENV_BASE64` | `env/<dev-or-prod>/fastlane/android.env` |

## Upload context variables from local files

Create the contexts first. Get their UUIDs with `circleci context list --json`
or from **Organization Settings → Contexts**. Create a CircleCI personal API
token and set it in `CIRCLECI_TOKEN`. The uploader uses the
[CircleCI context API](https://circleci.com/docs/api/v2/index.html)
to replace variables of the same name; it does not delete other variables.
It prints variable names but never secret values. From the repository root:

```bash
export CIRCLECI_BUILD_CONTEXT_ID='<build-context-uuid>'
export CIRCLECI_DEVELOPMENT_CONTEXT_ID='<development-context-uuid>'
export CIRCLECI_PRODUCTION_CONTEXT_ID='<production-context-uuid>'
read -rs 'CIRCLECI_TOKEN?CircleCI personal API token: '
export CIRCLECI_TOKEN
echo

scripts/upload-circleci-context-secrets.sh --type development --env env/dev --dry-run
scripts/upload-circleci-context-secrets.sh --type development --env env/dev
scripts/upload-circleci-context-secrets.sh --type production --env env/prod --dry-run
scripts/upload-circleci-context-secrets.sh --type production --env env/prod
```

On development, the uploader puts common app configuration in
`flutter-skeleton-build` and signing/upload files in
`flutter-skeleton-development`. On production, it puts both sets in
`flutter-skeleton-production`. Upload the Slack webhook separately; the script
prompts without echoing it:

```bash
scripts/upload-circleci-context-secrets.sh --type development --slack-webhook
scripts/upload-circleci-context-secrets.sh --type production --slack-webhook
```

Run `unset CIRCLECI_TOKEN` when finished. All source files stay local and
ignored by Git. The script validates every required file before sending any
variable. `env/prod` must be complete before its production upload can pass.

The build context contains only development app configuration and Slack. It
does not contain upload credentials. Deployment contexts are attached only to
upload jobs. iOS Match remains read-only in CI. Build and upload jobs notify
Slack on success or failure when `SLACK_WEBHOOK_URL` is present.

## Manual upload

In CircleCI, select **Trigger Pipeline**, choose a branch, and set the `action`
pipeline parameter to one of `ios_testflight`, `android_internal`,
`ios_production`, or `android_production`. Production actions must use `main`.
The default `action=ci` does not upload in a manual pipeline.

This CircleCI setup is independent of GitHub Actions. The repository's existing
GitHub Actions release workflows also contain `v*` tag triggers in the committed
version. If GitHub Actions is enabled for this repository, the same tag may run
both systems and attempt duplicate uploads. Confirm GitHub Actions is disabled
before using CircleCI tag releases. This setup does not require changing any
GitHub Actions workflow.

Validate the config with `circleci config validate .circleci/config.yml` if
the CircleCI CLI is installed. Then check a PR build pipeline, a commit on
`develop`, and finally a protected version tag after all contexts are set.
