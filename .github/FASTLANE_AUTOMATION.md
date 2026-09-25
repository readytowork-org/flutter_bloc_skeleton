# Fastlane and GitHub Actions template

This skeleton keeps application version and minimum build number in `pubspec.yaml` (`version: 1.0.0+1`). Replace the placeholder iOS bundle ID and Android `applicationId` with the registered app IDs before uploading. Do not copy another app's certificates, API keys, Firebase files, or secrets into this repository.

## What runs

| Workflow | Trigger | Result |
| --- | --- | --- |
| Manual TestFlight internal-only upload | Actions → Run workflow, any selected branch | Development config; IPA marked internal-only and uploaded to TestFlight |
| Manual Google Play internal testing upload | Actions → Run workflow, any selected branch | Development config; available to internal testers only |
| App Store Connect upload | Manual on `main`, or `vX.Y.Z` tag whose commit is on `main` | Production config; upload to App Store Connect/TestFlight without submitting for App Store review |
| Google Play production draft | Manual on `main`, or `vX.Y.Z` tag whose commit is on `main` | Production config; creates a draft, without review submission or rollout |
| iOS and Android build checks | Manual only | Unsigned build check; sends Slack result |

A `vX.Y.Z` tag triggers **both** production workflows. The tag must match the version in `pubspec.yaml`. PRs and branch merges do not trigger uploads or build checks. The old Flutter test and broken deploy workflows have been removed. Unrelated translation workflow is unchanged.

## Prepare application and credentials

1. Set the real bundle ID in `ios/Runner.xcodeproj/project.pbxproj`, application ID in `android/app/build.gradle.kts`, Apple team, and Firebase registration. `flutter.bloc.skeleton` and `com.example.flutterBlocSkeleton` are template IDs.
2. Create `env/dev` and `env/prod` private configuration files: `config.dart`, `firebase_options.dart`, `GoogleService-Info.plist`, `google-services.json`, and `release-key.jks`. These paths are ignored by Git. Both environments can use the same signing key if they publish the same Android application ID.
3. In each `env/<type>/fastlane/`, create `.env` for iOS based on `ios/fastlane/.env.example`, `store.json` based on `ios/fastlane/store.json.example`, and the `.p8` named by `key_filepath`. Put the Android settings in `android.env` based on `android/fastlane/.env.example`, alongside `play-service-account.json`. Set `ANDROID_PACKAGE_NAME` to the Gradle `applicationId`.
4. Make an App Store distribution certificate and App Store provisioning profile available through your private Fastlane Match repository. The Match Git token in `MATCH_GIT_BASIC_AUTHORIZATION` must have **read** access for CI. `store.json` is for the App Store Connect API key; the `.p8` is kept beside it.
5. Give the Google service account access to the target app and testing/production tracks in Play Console. Place the upload keystore and `android/key.properties` locally; its `storeFile` must be `release-key.jks`.
6. Run `bundle install` in `ios` and `android`. Then try `scripts/deploy-ios-testflight-local.sh` and `scripts/deploy-android-internal-local.sh` before using Actions. These scripts restore local files afterward.

## Add GitHub secrets

Run from the repository root after `gh auth login`:

```bash
scripts/upload-ios-actions-secrets.sh --type development --env env/dev --dry-run
scripts/upload-android-actions-secrets.sh --type development --env env/dev --dry-run
scripts/upload-ios-actions-secrets.sh --type development --env env/dev
scripts/upload-android-actions-secrets.sh --type development --env env/dev
scripts/upload-ios-actions-secrets.sh --type production --env env/prod
scripts/upload-android-actions-secrets.sh --type production --env env/prod
scripts/upload-ios-actions-secrets.sh --slack-webhook
```

Development secrets are `DEV_` repository secrets. Production secrets are `PROD_` secrets under the `production` GitHub environment; create that environment before running the production upload commands. The scripts replace secrets of the same name; they do not delete other secrets. Both production workflows validate that a manual run uses `main` or a tag points to a commit on `main`. The Slack webhook is a repository secret used by all workflows.

## Run

The workflow files must be present on the repository's default branch before GitHub shows the **Run workflow** button. Once present, select the `fix/fastlane` (or other feature) branch to test a development upload without merging it. Production manual uploads are accepted only on `main`. A production tag can be made with `git tag v1.0.0 <commit-on-main>` and `git push origin v1.0.0` after the matching `pubspec.yaml` change is merged.

For iOS, Fastlane checks the latest TestFlight build for the `pubspec.yaml` version and increments the build number if needed. For Android, Fastlane checks Play tracks and bundles. It increments for an existing release version; for a new version it uses the `+build` in `pubspec.yaml`, which must be higher than every previously uploaded Android version code. Uploading to TestFlight or an internal track is not a public release. Review, screenshots, rollout, and publication stay manual.
