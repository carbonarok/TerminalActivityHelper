#!/usr/bin/env bash
set -euo pipefail

swift build -c release

mkdir -p TerminalActivityHelper.app/Contents/MacOS
mkdir -p TerminalActivityHelper.app/Contents/Resources

cp .build/release/TerminalActivityHelper TerminalActivityHelper.app/Contents/MacOS/
chmod +x TerminalActivityHelper.app/Contents/MacOS/TerminalActivityHelper

cat >TerminalActivityHelper.app/Contents/Info.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.yourcompany.TerminalActivityHelper</string>
    <key>CFBundleName</key>
    <string>TerminalActivityHelper</string>
    <key>CFBundleExecutable</key>
    <string>TerminalActivityHelper</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>

    <!-- Make it a menu-bar-only app: no Dock icon, no regular windows -->
    <key>LSUIElement</key>
    <string>1</string>

    <!-- URL Scheme: terminal-activity://start?... -->
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleURLName</key>
        <string>terminal-activity</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>terminal-activity</string>
        </array>
      </dict>
    </array>
</dict>
</plist>
EOF

codesign --force --deep --sign - TerminalActivityHelper.app
