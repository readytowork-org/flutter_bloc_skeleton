# CircleCI for the Flutter skeleton

CircleCI runs unsigned iOS and Android builds for branch/PR pipelines. A merge to
`main` is another branch pipeline, so it also builds. Tests are not run. Uploads
run only when someone starts a pipeline with a non-default `action` parameter.
The existing GitHub Actions workflows are separate; they do not provide secrets
to CircleCI.

## Connect the project

1. Add `readytowork-org/flutter_bloc_skeleton` as a CircleCI project and use
   `.circleci/config.yml` as its config file. Enable the GitHub push/PR trigger.
2. Create the three contexts below in **Organization Settings → Contexts**.
   Restrict deployment contexts to this project and the trusted release team.
   Add the expression restriction `pipeline.git.branch == "main" and not job.ssh.enabled`
   to `flutter-skeleton-production`. Keep "Pass secrets to builds from forked
   pull requests" disabled.
3. Put each variable into the indicated context. Use the same application IDs,
   Match repository, Apple API key, Android upload key, and Google service account
   that work with the local Fastlane lanes. Replace template IDs before uploading.

| Context | Variables |
| --- | --- |
| `flutter-skeleton-build` | `CONFIG_DART_BASE64`, `FIREBASE_OPTIONS_BASE64`, `GOOGLE_SERVICE_PLIST_BASE64`, `ANDROID_GOOGLE_SERVICES_BASE64`, `SLACK_WEBHOOK_URL` |
| `flutter-skeleton-development` | `ASC_JSON_KEY`, `ASC_P8_BASE64`, `FASTLANE_ENV_BASE64`, `ANDROID_KEY_PROPERTIES_BASE64`, `ANDROID_KEYSTORE_BASE64`, `PLAY_SERVICE_ACCOUNT_JSON`, `ANDROID_FASTLANE_ENV_BASE64` |
| `flutter-skeleton-production` | All variables in the two rows above, with production values |

The `*_BASE64` variables contain the file content encoded as a single line.
For example, `base64 < env/dev/config.dart | tr -d '\r\n'` gives
`CONFIG_DART_BASE64`; repeat for the corresponding files below.
`ASC_JSON_KEY` and `PLAY_SERVICE_ACCOUNT_JSON` contain the raw JSON text.
`SLACK_WEBHOOK_URL` is the incoming webhook URL.

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

The build context contains only development app configuration and the Slack
webhook. It does not contain Apple signing, App Store Connect, or Play upload
credentials. Deployment contexts are attached only to upload jobs.

## Trigger a pipeline

In CircleCI, open the project, select **Trigger Pipeline**, choose the branch,
and set the pipeline parameter `action`:

| `action` | Branch | Result |
| --- | --- | --- |
| `ci` (default) | Any branch/PR | Unsigned iOS and Android builds; no upload |
| `ios_testflight` | Any selected branch | Development config; internal-only TestFlight upload |
| `android_internal` | Any selected branch | Development config; Google Play internal testing upload |
| `ios_production` | `main` only | Production config; App Store Connect/TestFlight upload, no review submission |
| `android_production` | `main` only | Production config; Google Play production draft, no review submission or rollout |

The `action` default means ordinary pushes and PRs cannot upload. Do not change
it for branch triggers. Production jobs also verify `CIRCLE_BRANCH=main` before
restoring credentials. This config does not upload on tag creation; the existing
GitHub Actions tag workflows remain separate.

Both upload lanes use `pubspec.yaml` as the version source and reuse the local
Fastlane behavior. iOS Match remains read-only in CI. Build and upload jobs send
success or failure to Slack when the webhook is available. The production
context must contain its own webhook value.

To check the YAML locally, run `circleci config validate .circleci/config.yml`
if you have the CircleCI CLI installed. The first safe live check is a normal
branch pipeline with `action=ci`; then trigger one development upload only
after its CircleCI context variables are present.
