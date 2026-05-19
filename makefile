# --- Config ---
GREEN=\033[1;32m
NC=\033[0m
-include .env_vars

# --- Project Setup ---
project-setup:
	@$(MAKE) flutter-clean
	@bash scripts/setup_hooks.sh

set-env-dev:
	@bash scripts/set_env.sh dev

set-env-staging:
	@bash scripts/set_env.sh staging

set-env-prod:
	@bash scripts/set_env.sh prod

# --- Flutter Maintenance ---
flutter-clean:
	@echo "$(GREEN)Cleaning Flutter project...$(NC)"
	@flutter clean
	@flutter pub get

flutter-fix:
	@dart format .
	@dart fix --apply

generate:
	@dart run build_runner build --delete-conflicting-outputs

watch:
	@dart run build_runner watch --delete-conflicting-outputs

# --- Advanced Setup ---
generate_dynamic_links:
	@bash scripts/configure_links.sh

setup-firebase:
	@bash scripts/setup_firebase.sh

swagger-gen:
	@dart generator/swagger_parser.dart $(TAG) $(FILE)

update-gradle:
	@chmod +x scripts/patch_gradle.sh
	@bash scripts/patch_gradle.sh

setup-android-keys:
	@bash scripts/generate_keystore.sh

setup-android-production: setup-android-keys update-gradle

.PHONY: project-setup set-env-dev set-env-staging set-env-prod flutter-clean flutter-fix generate watch generate_dynamic_links setup-firebase swagger-gen