#!/usr/bin/env bash
set -euo pipefail

mode="${1:-auto}"
if [[ "$mode" != auto && "$mode" != tag ]]; then
  echo 'Expected auto or tag mode' >&2
  exit 2
fi

if [[ -n "${CIRCLE_TAG:-}" ]]; then
  [[ "$CIRCLE_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
    echo 'Production tag must be v<major>.<minor>.<patch>' >&2
    exit 1
  }
  version="$(sed -nE 's/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)\+[0-9]+[[:space:]]*$/\1/p' pubspec.yaml)"
  [[ -n "$version" && "$CIRCLE_TAG" == "v$version" ]] || {
    echo 'Production tag must match the version in pubspec.yaml' >&2
    exit 1
  }
  if [[ "$(git rev-parse --is-shallow-repository)" == true ]]; then
    git fetch --unshallow origin
  fi
  git fetch --no-tags origin main:refs/remotes/origin/main
  git merge-base --is-ancestor HEAD refs/remotes/origin/main || {
    echo 'Production tag commit must be on main' >&2
    exit 1
  }
elif [[ "$mode" == tag ]]; then
  echo 'A version tag is required for this release' >&2
  exit 1
else
  [[ "${CIRCLE_BRANCH:-}" == main ]] || {
    echo 'Manual production uploads must run from main' >&2
    exit 1
  }
fi
