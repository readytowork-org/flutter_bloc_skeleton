#!/bin/bash

GRADLE_FILE="android/app/build.gradle.kts"
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${GREEN}Patching $GRADLE_FILE...${NC}"

# 1. Add Imports at the very top if they don't exist
if ! grep -q "import java.util.Properties" "$GRADLE_FILE"; then
    sed -i '' '1i\
import java.util.Properties\
import java.io.FileInputStream\
' "$GRADLE_FILE"
fi

# 2. Inject Keystore Loading Logic (Above the 'android {' block)
if ! grep -q "val keystoreProperties =" "$GRADLE_FILE"; then
    sed -i '' '/android {/i\
val keystoreProperties = Properties()\
val keystorePropertiesFile = rootProject.file("key.properties")\
\
if (keystorePropertiesFile.exists()) {\
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))\
}\
' "$GRADLE_FILE"
fi

# 3. Inject signingConfigs (Inside 'android {' block, before 'defaultConfig')
if ! grep -q "signingConfigs {" "$GRADLE_FILE"; then
    sed -i '' '/defaultConfig {/i\
    signingConfigs {\
        create("release") {\
            if (keystorePropertiesFile.exists()) {\
                storeFile = file(keystoreProperties["storeFile"] as String)\
                storePassword = keystoreProperties["storePassword"] as String\
                keyAlias = keystoreProperties["keyAlias"] as String\
                keyPassword = keystoreProperties["keyPassword"] as String\
            }\
        }\
    }\
' "$GRADLE_FILE"
fi

# 4. Update BuildTypes (Replace the existing release block)
# This finds the release block and replaces its content
sed -i '' '/release {/,/}/c\
        release {\
            signingConfig = if (keystorePropertiesFile.exists())\
                signingConfigs.getByName("release")\
            else\
                signingConfigs.getByName("debug")\
        }' "$GRADLE_FILE"

echo -e "${GREEN}✅ Gradle file patched successfully!${NC}"