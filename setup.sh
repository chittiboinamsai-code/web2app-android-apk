#!/bin/bash

set -e

echo "🚀 Web2App Android APK - Complete End-to-End Setup"
echo "================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Step 1: Install Node dependencies${NC}"
npm install

echo -e "${BLUE}Step 2: Initialize Capacitor${NC}"
npx cap init SbaigenPro com.sbaigenpro.web2app || true
npx cap add android || true

echo -e "${BLUE}Step 3: Create www/index.html${NC}"
mkdir -p www
cat > www/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SbaigenPro - Web2App</title>
    <script src="capacitor.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container { text-align: center; color: white; padding: 40px; }
        h1 { font-size: 48px; margin-bottom: 20px; }
        p { font-size: 18px; opacity: 0.9; margin-bottom: 40px; }
        .button { background: white; color: #667eea; padding: 15px 30px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; box-shadow: 0 10px 25px rgba(0,0,0,0.2); }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 SbaigenPro</h1>
        <p>Web2App Converter - Android Edition</p>
        <button class="button" onclick="window.location.href='https://www.sbaigenpro.shop/'">Open Web App</button>
    </div>
</body>
</html>
HTMLEOF

echo -e "${BLUE}Step 4: Generate Android Keystore${NC}"
keytool -genkey -v -keystore ~/.android/sbaigenpro-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias sbaigenpro \
  -storepass sbaigenpro123 \
  -keypass sbaigenpro123 \
  -dname "CN=SbaigenPro,O=SbaigenPro,C=IN" || echo "Keystore already exists"

echo -e "${BLUE}Step 5: Copy web files to Capacitor${NC}"
npm run build

echo -e "${BLUE}Step 6: Build Release APK${NC}"
cd android
./gradlew assembleRelease
cd ..

echo -e "${GREEN}✅ APK Built Successfully!${NC}"
echo -e "${GREEN}📍 Location: android/app/build/outputs/apk/release/app-release.apk${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Install: adb install -r android/app/build/outputs/apk/release/app-release.apk"
echo "2. Verify: adb shell pm list packages | grep sbaigenpro"
echo "3. Push to GitHub: git add . && git commit -m 'Complete setup' && git push"
echo "4. Deploy to Cloud: gcloud builds submit --config=cloudbuild.yaml"
echo ""
echo -e "${GREEN}Build Complete! 🎉${NC}"
