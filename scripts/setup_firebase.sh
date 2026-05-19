#!/bin/bash
read -p "Enter Firebase PROJECT_ID: " PROJECT_ID
read -p "Enter Firebase DISPLAY_NAME: " DISPLAY_NAME
read -p "Enter Android Package Name: " ANDROID_PACKAGE
read -p "Enter iOS Bundle ID: " IOS_BUNDLE_ID

echo "Creating Firebase project..."
firebase projects:create "$PROJECT_ID" --display-name "$DISPLAY_NAME"

echo "Configuring FlutterFire..."
flutterfire configure \
    --project="$PROJECT_ID" \
    --android-package-name="$ANDROID_PACKAGE" \
    --ios-bundle-id="$IOS_BUNDLE_ID" \
    --yes

echo "Adding Firebase packages..."
flutter pub add firebase_core firebase_auth cloud_firestore firebase_messaging