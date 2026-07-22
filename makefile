# --- Config ---
GREEN=\033[1;32m
NC=\033[0m
-include .env_vars

# --- Project Setup ---
project-setup:
	@$(MAKE) flutter-clean
	@bash scripts/setup_hooks.sh

set-env-local:
	@bash scripts/set_env.sh local

set-env-dev:
	@bash scripts/set_env.sh dev

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

# --- Advanced Setup ---
generate_dynamic_links:
	@bash scripts/configure_links.sh

setup-firebase:
	@bash scripts/setup_firebase.sh

update-gradle:
	@chmod +x scripts/patch_gradle.sh
	@bash scripts/patch_gradle.sh

setup-android-keys:
	@bash scripts/generate_keystore.sh

setup-android-production: setup-android-keys update-gradle

.PHONY: project-setup set-env-dev set-env-staging set-env-prod flutter-clean flutter-fix generate_dynamic_links setup-firebase
