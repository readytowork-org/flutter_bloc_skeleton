# MEMORY.md

Project memory for flutter_bloc_skeleton, from the first commit on `main` (2023-03-21) to 2026-09-29. Current branch: `fix/skills`.

---

## Memory

What to know before touching anything:

- **Product.** A reusable Flutter application skeleton demonstrating authentication, session recovery, product browsing and pagination, product creation/editing, cart screens, profile management, and locale switching. It provides a starting point for client applications; the repository does not establish a separate production product or commercial roadmap.
- **Shape.** Single application with feature-first Clean Architecture. `lib/features/` contains auth, cart, product, and profile modules with data/domain/presentation layers. `lib/core/` owns networking, errors, storage, DI, themes, and routing; `lib/shared/` holds reusable widgets and state. Unit/widget tests live in `test/`; device tests in `integration_test/`; generators and automation in `generator/`, `scripts/`, and `.github/`.
- **Stack.** Flutter pin: `3.47.1`; Dart SDK constraint: `^3.10.3`. Declared package constraints include `flutter_bloc ^9.1.1`, `get_it ^9.2.0`, `dio ^5.8.0+1`, `go_router ^18.0.1`, `freezed ^4.0.1`, `equatable ^3.0.0`, `build_runner ^2.4.11`, `json_serializable ^6.8.0`, `mocktail ^1.0.5`, and `bloc_test ^10.0.0`. These are manifest constraints, not a claim about resolved or installed versions; consult `pubspec.lock`. Firebase, OneSignal, secure storage, and Flutter localization support platform integrations.
- **Rules / Layer Boundaries.** Follow `AGENTS.md`. Presentation calls use cases; data implementations satisfy domain repository contracts and map DTOs to entities. New domain code must not import UI, data implementations, Dio, Firebase, or GetIt. Existing contracts return `ApiResult<T>`, not `Either`; neither fpdart nor dartz is declared. `Failure` currently shares a file with Dio error mapping, creating known transitive coupling. Preserve compatibility during focused tasks and avoid expanding this debt. Prefer immutable state, relative imports, and generated Freezed/JSON outputs committed with their sources.
- **Key Modules / Services.** `lib/main.dart` awaits the GetIt bootstrap in `lib/core/di/service_locator.dart`, which initializes Firebase, OneSignal, token storage, and notification services before the app. Feature DI functions register implementations; profile DI is under `presentation/`. `DioClient` and interceptors manage HTTP/session behavior; endpoints include `/auth/login`, `/auth/me`, `/auth/refresh`, and product APIs. `AppRouter` and `app_route_redirect.dart` handle navigation/authentication. Shared pagination supports product lists. ARBs under `lib/l10n/` drive generated localization.
- **Configuration.** `lib/config.dart`, `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist` are private, ignored inputs. Environment switching overwrites destinations and cleans Gradle; verify all source files before running it. The Sheets importer needs private credentials and overwrites both ARBs. Never copy secrets into this memory.
- **Roles / Team.** Local Git history records contributions under `Aashish-Dahal`, `bhattaraibishal50`, and `Bishal Bhattarai`. Formal ownership and current role assignments are not documented; do not infer them from commit counts.
- **Snapshot / Evidence.** HEAD is `f5c6ebc` (PR #21). At inspection, `main..HEAD` contained no branch-only commits. Working-tree changes include untracked `AGENTS.md`, `MEMORY.md`, six skill playbooks, and skill symlinks for Codex, Claude, and OpenCode; `makefile` has `make setup-skills AGENT=<name>`, and the pre-existing `SKIll.md` deletion remains. The `feature` playbook now follows an explicit Domain → Data → Presentation → DI/routing → Testing sequence and is configured for explicit invocation in Codex and Claude. Antigravity and Goose read `.agents/skills/` directly. Historical entries below summarize local reachable Git history using author dates and merge subjects; remote state was not refreshed. All six skill validators passed before this update. Link targets resolved, reruns succeeded, and an existing-directory conflict was left untouched. No Flutter tests, analysis, builds, or generation were run for this documentation and tooling task.
- **Memory maintenance.** Use this uppercase `MEMORY.md` as the canonical log; avoid creating a separate lowercase copy. Append verified milestones chronologically, distinguish committed changes from working-tree work, and recheck branch/status before relying on this snapshot. `AGENTS.md` now points to this file.

---

## Next steps / Open items

Current branch (`fix/skills`):

- [ ] Review the new `AGENTS.md`, `MEMORY.md`, six playbooks, and Makefile symlink target; commit when authorized. These are not recorded as landed history yet.
- [ ] Confirm the intended disposition of the pre-existing `SKIll.md` deletion; preserve it until the owner decides.
- [x] Align `AGENTS.md` memory references with uppercase `MEMORY.md` and remove its statement that no memory file exists.
- [x] Define six repository playbooks (`feature`, `api`, `bloc`, `routing`, `codegen`, `sync`) in `.agents/skills/` and add setup for five assistants.
- [ ] Before application work, verify the pinned SDK and private configuration, run `flutter pub get`, then relevant tests and `flutter analyze`. Configuration availability and runtime health were not validated in this session.

Product / platform backlog:

These are observed maintenance candidates, not an approved feature roadmap.

- [ ] Reconcile manual Android/iOS build workflows pinned to Flutter `3.41.4` with local Flutter `3.47.1` after compatibility validation.
- [ ] Correct outdated README paths/result examples and `TESTING.md` claims of automatic full-suite CI; the format workflow is disabled.
- [ ] Plan separation of pure failure types from Dio-specific mapping while preserving existing `ApiResult` consumers.
- [ ] Assess coverage for authentication/session expiry, repository error mapping, and pagination boundaries; no numeric coverage threshold is configured.

---

## Decisions made

Dates identify the introducing commit or historical milestone. Notes describe observable implementation benefits; undocumented original motivations are not asserted.

| Date | Decision | Why / notes |
| :--- | :--- | :--- |
| 2023-03-21 | Establish a Flutter BLoC skeleton | Initial repository commit `5f9c8c3`; foundation for a reusable application. |
| 2024-04-29 | Add Makefile-based development tasks | `5926aeb`; central entry points for repeatable local commands. |
| 2024-04-30 | Introduce GetIt and shared Dio/interceptor setup | `cf27e09`, `381b35a`; central dependency composition and networking infrastructure. |
| 2024-05-02 | Introduce reusable pagination state and widgets | `3bc8a33` and related commits; shared list loading behavior. |
| 2024-10-06 | Add commit-message and maintenance hooks | `7ab4a55`, `df5b9d8`; current hooks enforce Conventional Commits and run formatting, analysis, and fixes. |
| 2025-12-09 | Adopt feature-based organization | `9e23661`, PR #1; group implementation by feature rather than only by technical layer. |
| 2026-04-09 | Add the current `ApiResult<T>` source | Introduced in `d0ccc11`; typed success/failure contracts now shared by repositories and use cases. |
| 2026-05-05 | Move app localization to ARBs with locale switching | `2c033f2`; Flutter-generated localization becomes the application workflow. |
| 2026-05-09 | Abstract secure token storage | `3890a16`; `TokenStorage` separates consumers from secure persistence implementation. |
| 2026-05-10 | Consolidate application routing and token lifecycle wiring | `fca75c1`; `AppRouter` and secure token storage changes coordinate navigation/session behavior. |
| 2026-05-14 | Integrate OneSignal and reorganize tests | `c373564`, `2d8f8d8`; notification integration plus explicit unit/widget/integration organization. |
| 2026-09-28 | Pin Flutter to 3.47.1 | `9e589e4`, PR #21; current local SDK baseline. Build workflows still use 3.41.4. |
| 2026-09-29 | Maintain a shared AI contributor contract and project memory | Working-tree documentation, not committed: `AGENTS.md` records 12 guidance sections; `MEMORY.md` records verified history and pending work. |

---

## Progress log

Grouped milestones cover the available history without treating every commit as a separate deliverable. PR identifiers are taken from local merge subjects; commit hashes are used where no PR association is established.

| Date | PR / branch | What landed |
| :--- | :--- | :--- |
| 2023-03-21 | `5f9c8c3` / history reachable from `main` | Initial Flutter BLoC skeleton. |
| 2024-04-29 | `5926aeb`–`cc45789` | Makefile, lint/package updates, login/register views, auth repository/service, and auth BLoC. |
| 2024-04-30 | `9bd85ab`–`381b35a` | BLoC observer, GetIt, validation, themes, routing, root widget, and Dio/interceptors. |
| 2024-05-02 | `6ed5ed3`–`6646b5d` | Pagination models/BLoC/widgets, refresh lists, post service, setup fixes, and documentation updates. |
| 2024-05-20 | `a07b531`–`965aa0e` | Firebase ID-token refresh, GitHub Actions work, Java/format fixes, and responsive layout changes. |
| 2024-10-01–2024-10-06 | `01209a7`–`fbe1e4a` | App extensions, Git hooks, Makefile updates, platform maintenance, and CI/build configuration changes. |
| 2024-12-11 | `e7b2a6d`, `727b9ad`, `ad0f5f6` | Code refactor and README updates. |
| 2025-01-14–2025-01-19 | `b1540fb`–`e861a96` | API authentication, login UI, theme update, and Android activity work. |
| 2025-04-15–2025-04-29 | `2724ebe`–`ea1d8af` | Auth/API/theme refactors, repositories, Firebase messaging initialization, Sheets translation tooling, and documentation updates. |
| 2025-12-09 | PR #1 / `feature-based` | Feature-based project structure merged. |
| 2026-04-09 | PR #2 / `swagger-gen` | Authentication/pagination widgets and supporting functionality; current `ApiResult` source introduced. |
| 2026-04-11 | PR #3 / `swagger-gen` | Signup use case, auth event/state changes, validated inputs, product data sources/repository, and product pagination integration. |
| 2026-05-05–2026-05-06 | PR #4 / `swagger-gen` | ARB localization, locale switching, and cart routing/UI/localization changes. |
| 2026-05-06 | PR #5 / `dynamic-link`; PR #6 / `assets-generator` | Platform link configuration and asset-generation tooling merged; later repository state must be checked before using historical commands. |
| 2026-05-06–2026-05-10 | `d376126`–`fca75c1` | Pagination callbacks/scroll handling, secure token storage, logout, product fetching/add/edit/search/category/detail UI, splash/icons, and routing updates. |
| 2026-05-11 | PR #7 / `pr-guide`; PR #8 and #9 / `profile-feature` | PR template and profile data sources, UI, and state management; localization workflow improvements. |
| 2026-05-11–2026-05-14 | `43af67d`–`324b400`; PR #11 / `auto/update-translation` | Translation workflow fixes, Firebase/setup integration, endpoint constants, OneSignal, reorganized tests/integration tests, and request-body/API generator improvements. |
| 2026-07-21 | PR #18 / `fix/updates` | Architecture updates and cart fixes (`8f4c959`, `51e6eac`). |
| 2026-07-22 | `60c8133` | FCM package update. |
| 2026-09-25 | PR #20 / `fix/fastlane` | Fastlane setup guide update. |
| 2026-09-25–2026-09-28 | PR #21 / `fix/version-update` | FVM configuration and Flutter 3.47.1 update; merged at `f5c6ebc`. |
| 2026-09-29 | `fix/skills` / uncommitted | Prepared the 12-section AI contributor guide, historical memory file, six repository skills, and a Makefile target to configure discovery for five assistants. These changes have not landed in a commit; pre-existing `SKIll.md` deletion remains unresolved. |
