#!/bin/bash

# Configuration
ANDROID_DIR="android"
APP_DIR="android/app"
PROPERTIES_FILE="$ANDROID_DIR/key.properties"

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${GREEN}--- Android Keystore & Properties Setup ---${NC}"

# 1. Collect Inputs
read -p "Enter Keystore Filename (e.g., release-key.jks): " KEY_NAME
read -s -p "Enter Store Password: " STORE_PASS
echo ""
read -p "Enter Key Alias: " KEY_ALIAS
read -s -p "Enter Key Password: " KEY_PASS
echo ""

# 2. Generate the Keystore directly into android/app/
echo -e "\n${GREEN}Generating keystore at $APP_DIR/$KEY_NAME...${NC}"
keytool -genkey -v \
    -keystore "$APP_DIR/$KEY_NAME" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storetype JKS \
    -storepass "$STORE_PASS" \
    -keypass "$KEY_PASS"

# 3. Create key.properties
echo -e "${GREEN}Creating $PROPERTIES_FILE...${NC}"
cat <<EOF > "$PROPERTIES_FILE"
storeFile=$KEY_NAME
storePassword=$STORE_PASS
keyAlias=$KEY_ALIAS
keyPassword=$KEY_PASS
EOF

# 4. Update .gitignore (Safety first!)
if ! grep -q "key.properties" .gitignore; then
    echo "key.properties" >> .gitignore
    echo "*.jks" >> .gitignore
    echo -e "${GREEN}Added keys to .gitignore to prevent accidental leaks.${NC}"
fi

echo -e "\n${GREEN}✅ Setup Complete!${NC}"
echo "Keystore: $APP_DIR/$KEY_NAME"
echo "Properties: $PROPERTIES_FILE"