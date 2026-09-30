#!/bin/bash
GREEN='\033[1;32m'
NC='\033[0m'

HOOKS=("prepare-commit-msg" "commit-msg" "pre-commit")

for hook in "${HOOKS[@]}"; do
    if [ -f "hooks/$hook" ]; then
        cp "hooks/$hook" ".git/hooks/"
        chmod +x ".git/hooks/$hook"
    fi
done

echo -e "${GREEN}Git hooks setup successfully${NC}"