#!/bin/bash
ENV=$1
ANDROID_DIR="android/app"
IOS_DIR="ios/Runner"
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

if [ ! -d "env/$ENV" ]; then
    echo -e "${RED}Error: Directory env/$ENV does not exist.${NC}"
    exit 1
fi

echo -e "${GREEN}Switching to $ENV environment...${NC}"

# Copy Config and Services
cp -r "env/$ENV/config.dart" lib/
cp -r "env/$ENV/google-services.json" "$ANDROID_DIR/"
cp -r "env/$ENV/GoogleService-Info.plist" "$IOS_DIR/"

# Clean Native Caches
(cd android && ./gradlew clean)
yarn cache clean 2>/dev/null || true

echo -e "${GREEN}Successfully copied $ENV environment config${NC}"