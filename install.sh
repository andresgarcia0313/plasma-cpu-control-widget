#!/bin/bash
# Install CPU Control Plasma Widget
# Installs: plasmoid files + polkit policy + helper script

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids/org.kde.plasma.cpucontrol"
HELPER="/usr/local/bin/cpu-perf-set"
POLICY="/usr/share/polkit-1/actions/org.kde.plasma.cpucontrol.policy"

echo "=== CPU Control Widget Installer ==="

# 1. Install plasmoid files
echo "[1/3] Installing widget files..."
rm -rf "$PLASMOID_DIR"
mkdir -p "$PLASMOID_DIR/contents/ui/components"
mkdir -p "$PLASMOID_DIR/contents/ui/logic"

cp "$SCRIPT_DIR/metadata.json" "$PLASMOID_DIR/"
cp "$SCRIPT_DIR/metadata.desktop" "$PLASMOID_DIR/"
cp "$SCRIPT_DIR/contents/ui/main.qml" "$PLASMOID_DIR/contents/ui/"
cp "$SCRIPT_DIR/contents/ui/CompactView.qml" "$PLASMOID_DIR/contents/ui/"
cp "$SCRIPT_DIR/contents/ui/FullView.qml" "$PLASMOID_DIR/contents/ui/"
cp "$SCRIPT_DIR/contents/ui/components/"*.qml "$PLASMOID_DIR/contents/ui/components/"
cp "$SCRIPT_DIR/contents/ui/logic/"*.js "$PLASMOID_DIR/contents/ui/logic/"

echo "    Widget → $PLASMOID_DIR"

# 2. Install helper script (requires sudo)
echo "[2/3] Installing helper script..."
sudo cp "$SCRIPT_DIR/system/cpu-perf-set" "$HELPER"
sudo chmod 755 "$HELPER"
echo "    Helper → $HELPER"

# 3. Install polkit policy (requires sudo)
echo "[3/3] Installing polkit policy..."
sudo cp "$SCRIPT_DIR/system/org.kde.plasma.cpucontrol.policy" "$POLICY"
echo "    Policy → $POLICY"

echo ""
echo "=== Installation complete ==="
echo "Restart Plasma: kquitapp6 plasmashell && kstart plasmashell"
echo "Then add 'CPU Control' widget to your panel."
