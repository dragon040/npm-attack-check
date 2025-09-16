#!/bin/bash

# List of known malicious package versions and their safe replacements
declare -A malicious_packages=(
  ["chalk"]="5.6.1:5.6.2"
  ["debug"]="4.4.2:4.4.1"
  ["ansi-styles"]="6.2.2:6.2.3"
  ["strip-ansi"]="7.1.1:7.1.2"
  ["supports-color"]="10.2.1:10.2.2"
  ["wrap-ansi"]="9.0.1:9.0.2"
  ["color-convert"]="3.1.1:3.1.0"
  ["simple-swizzle"]="0.2.3:0.2.2"
)

LOCKFILE="package-lock.json"
if [ ! -f "$LOCKFILE" ]; then
  LOCKFILE="yarn.lock"
fi

echo "🔍 Scanning the $LOCKFILE for compromised NPM packages..."

found=false
for pkg in "${!malicious_packages[@]}"; do
  IFS=":" read -r bad_version safe_version <<< "${malicious_packages[$pkg]}"
  if grep -q "\"$pkg\": \"$bad_version\"" "$LOCKFILE"; then
    echo "⚠️  Found compromised package: $pkg@$bad_version"
    echo "✅ Suggested safe version: $pkg@$safe_version"
    found=true
  fi
done

if [ "$found" = false ]; then
  echo "✅ No compromised packages found."
else
  echo ""
  read -p "🧹 Do you want to clean NPM cache and reinstall dependencies? (y/n): " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "🧼 Cleaning NPM cache..."
    npm cache clean --force

    echo "📦 Reinstalling dependencies..."
    rm -rf node_modules package-lock.json
    npm install

    echo "✅ Environment is cleaned and dependencies are reinstalled."
  else
    echo "ℹ️ Skipped cleanup. Please update the packages manually."
  fi
fi

echo "🔚 Scan complete."
