#!/bin/bash
# 1. Interactive Input
echo "--- Project Configuration ---"
read -p "Enter Android Package Name: " PACKAGE_NAME
read -p "Enter iOS Bundle ID: " BUNDLE_ID
read -p "Enter Domain Name: " DOMAIN
read -p "Enter Apple Team ID: " TEAM_ID

# Save to .env_vars for the Makefile to use if needed
echo "PACKAGE_NAME=$PACKAGE_NAME" > .env_vars
echo "BUNDLE_ID=$BUNDLE_ID" >> .env_vars
echo "DOMAIN=$DOMAIN" >> .env_vars
echo "TEAM_ID=$TEAM_ID" >> .env_vars

# 2. Android Manifest Update
echo "Updating AndroidManifest.xml..."
INTENT_BLOCK="        <intent-filter android:autoVerify=\"true\">
            <action android:name=\"android.intent.action.VIEW\" />
            <category android:name=\"android.intent.category.DEFAULT\" />
            <category android:name=\"android.intent.category.BROWSABLE\" />
            <data android:scheme=\"https\" android:host=\"$DOMAIN\" />
        </intent-filter>"

# Use a temporary file to avoid complex sed escaping
echo "$INTENT_BLOCK" > .tmp_intent
sed -i '' '/<activity/r .tmp_intent' android/app/src/main/AndroidManifest.xml
rm .tmp_intent

# 3. iOS Entitlements (using a heredoc for cleaner formatting)
cat <<EOF > ios/Runner/Runner.entitlements
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:$DOMAIN</string>
    </array>
</dict>
</plist>
EOF

echo "Link configuration complete!"