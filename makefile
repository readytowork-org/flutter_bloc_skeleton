# --- Config ---
GREEN=\033[1;32m
NC=\033[0m
-include .env_vars
AGENT ?= codex

# --- Project Setup ---
project-setup:
	@$(MAKE) flutter-clean
	@bash scripts/setup_hooks.sh
	@$(MAKE) setup-skills AGENT=$(AGENT)

setup-skills:
	@test -d .agents/skills || { echo "Missing .agents/skills"; exit 1; }
	@case "$(AGENT)" in \
		codex) directory=.codex ;; \
		claude) directory=.claude ;; \
		opencode) directory=.opencode ;; \
		antigravity|goose) echo "$(AGENT) discovers .agents/skills directly; no symlink needed"; exit 0 ;; \
		*) echo "Unsupported AGENT=$(AGENT). Use codex, claude, opencode, antigravity, or goose."; exit 2 ;; \
	esac; \
	if [ -L "$$directory" ] || { [ -e "$$directory" ] && [ ! -d "$$directory" ]; }; then \
		echo "$$directory already exists and is not a directory; inspect it before changing it"; exit 1; \
	fi; \
	mkdir -p "$$directory"; \
	link="$$directory/skills"; \
	if [ -L "$$link" ]; then \
		[ "$$(readlink "$$link")" = "../.agents/skills" ] || { echo "$$link points elsewhere; inspect it before changing it"; exit 1; }; \
	elif [ -e "$$link" ]; then \
		echo "$$link already exists; inspect it before changing it"; exit 1; \
	else \
		ln -s ../.agents/skills "$$link"; \
	fi

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

.PHONY: project-setup setup-skills set-env-local set-env-dev set-env-prod flutter-clean flutter-fix generate watch generate_dynamic_links setup-firebase swagger-gen
