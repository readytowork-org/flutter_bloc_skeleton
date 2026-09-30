---
name: codegen
description: Run and review this Flutter repository's Freezed, JSON, localization, or Swagger code generation after source inputs change.
---

# Skill Playbook: /codegen

Use this playbook when generated outputs need updating. Identify source inputs and expected generated files, then inspect `git status` before running a generator so existing changes remain attributable.

## 1. Run the appropriate generator

- Freezed or JSON annotation changes: `make generate` (`dart run build_runner build --delete-conflicting-outputs`).
- ARB changes: `flutter gen-l10n`; review tracked `lib/l10n/s*.dart` outputs. The Sheets importer overwrites both ARBs and requires ignored credentials, so use it only for an explicit Sheet import.
- Swagger input changes: `make swagger-gen TAG=<tag> FILE=<swagger.json>` after verifying the tag and input. Inspect generated feature code before connecting DI/routes.

This repository does not use `injectable` and has no `injection.config.dart` output. Do not add either solely for generation.

## 2. Review and validate

Review `*.g.dart` and `*.freezed.dart` diffs, include them with source changes, and never hand-edit generated files. If build_runner reports a persistent cache conflict, inspect the error before using `dart run build_runner clean`, then rerun `make generate`. Run formatting, `flutter analyze`, and affected tests after generation. Report generated files and any unresolved conflict.
