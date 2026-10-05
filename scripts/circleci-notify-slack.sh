#!/usr/bin/env bash
set -euo pipefail

status="${1:-}"
summary="${2:-}"
[[ "$status" == success || "$status" == failure ]] && [[ -n "$summary" ]] || {
  echo 'Usage: circleci-notify-slack.sh success|failure "summary"' >&2
  exit 2
}
if [[ -z "${SLACK_WEBHOOK_URL:-}" ]]; then
  echo 'SLACK_WEBHOOK_URL is unavailable; no Slack message was sent' >&2
  exit 0
fi

if [[ "$status" == success ]]; then
  icon='✅'
else
  icon='❌'
fi
ref="${CIRCLE_TAG:-${CIRCLE_BRANCH:-unknown}}"
message="$(printf '%s %s\nRef: %s\n<%s|View CircleCI job>' "$icon" "$summary" "$ref" "${CIRCLE_BUILD_URL:-https://app.circleci.com}")"
payload="$(MESSAGE="$message" python3 -c 'import json, os; print(json.dumps({"text": os.environ["MESSAGE"]}))')"
curl --fail --silent --show-error --retry 3 --max-time 20 \
  -H 'Content-Type: application/json' --data "$payload" "$SLACK_WEBHOOK_URL"
