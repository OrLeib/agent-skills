#!/bin/bash
# Generate all app icon assets (Web/PWA, iOS, Android) from a 1024x1024 source.
# Uses macOS `sips` (built-in, no dependencies).
#
# Usage:
#   ./replace-icon.sh /path/to/source-1024x1024.png
#
# Environment variables (all optional):
#   PROJ_ROOT                 Project root (default: current directory)
#   ICON_PREFIX               Web/PWA icon filename prefix (default: "icon")
#   NOTIFICATION_ICON_SOURCE  Separate white-on-transparent notification icon

set -euo pipefail

SOURCE="${1:?Usage: $0 /path/to/source-1024x1024.png}"
PROJ_ROOT="${PROJ_ROOT:-$(pwd)}"
ICON_PREFIX="${ICON_PREFIX:-icon}"

if [ ! -f "$SOURCE" ]; then
  echo "Error: Source file not found: $SOURCE"
  exit 1
fi

# Verify source is 1024x1024
WIDTH=$(sips -g pixelWidth "$SOURCE" | awk '/pixelWidth/{print $2}')
HEIGHT=$(sips -g pixelHeight "$SOURCE" | awk '/pixelHeight/{print $2}')
if [ "$WIDTH" != "1024" ] || [ "$HEIGHT" != "1024" ]; then
  echo "Error: Source must be 1024x1024, got ${WIDTH}x${HEIGHT}"
  exit 1
fi

resize() {
  local size=$1
  local dest=$2
  mkdir -p "$(dirname "$dest")"
  cp "$SOURCE" "$dest"
  sips -z "$size" "$size" -s format png "$dest" --out "$dest" >/dev/null 2>&1
  echo "  ✓ ${dest##$PROJ_ROOT/} (${size}x${size})"
}

# ── Web / PWA ────────────────────────────────────────────────────────────────
echo "=== Web / PWA ==="
resize 512 "$PROJ_ROOT/public/icons/${ICON_PREFIX}-512.png"
resize 192 "$PROJ_ROOT/public/icons/${ICON_PREFIX}-192.png"
resize 192 "$PROJ_ROOT/public/favicon.ico"

# ── iOS ──────────────────────────────────────────────────────────────────────
echo ""
echo "=== iOS App Icons ==="
IOS_DIR="$PROJ_ROOT/ios/App/App/Assets.xcassets/AppIcon.appiconset"
if [ -d "$IOS_DIR" ]; then
  for size in 1024 180 167 152 120 87 80 76 58 40 29 20; do
    resize "$size" "$IOS_DIR/${size}.png"
  done
else
  echo "  ⚠ Skipped — directory not found: $IOS_DIR"
fi

# ── Android Launcher Icons ───────────────────────────────────────────────────
echo ""
echo "=== Android Launcher Icons ==="
ANDROID_RES="$PROJ_ROOT/android/app/src/main/res"
ANDROID_CONFIGS="mdpi:48:108 hdpi:72:162 xhdpi:96:216 xxhdpi:144:324 xxxhdpi:192:432"

if [ -d "$ANDROID_RES" ]; then
  for config in $ANDROID_CONFIGS; do
    density="${config%%:*}"
    rest="${config#*:}"
    launcher_size="${rest%%:*}"
    resize "$launcher_size" "$ANDROID_RES/mipmap-${density}/ic_launcher.png"
    resize "$launcher_size" "$ANDROID_RES/mipmap-${density}/ic_launcher_round.png"
  done

  # ── Android Adaptive Foreground ──────────────────────────────────────────
  echo ""
  echo "=== Android Adaptive Foreground ==="
  for config in $ANDROID_CONFIGS; do
    density="${config%%:*}"
    rest="${config#*:}"
    foreground_size="${rest#*:}"
    resize "$foreground_size" "$ANDROID_RES/mipmap-${density}/ic_launcher_foreground.png"
  done

  # ── Android Notification Icon ────────────────────────────────────────────
  echo ""
  echo "=== Android Notification Icon ==="
  NOTIF_SOURCE="${NOTIFICATION_ICON_SOURCE:-$SOURCE}"
  NOTIF_CONFIGS="mdpi:24 hdpi:36 xhdpi:48 xxhdpi:72 xxxhdpi:96"
  for config in $NOTIF_CONFIGS; do
    density="${config%%:*}"
    notif_size="${config#*:}"
    mkdir -p "$ANDROID_RES/mipmap-${density}"
    cp "$NOTIF_SOURCE" "$ANDROID_RES/mipmap-${density}/notification_icon.png"
    sips -z "$notif_size" "$notif_size" -s format png \
      "$ANDROID_RES/mipmap-${density}/notification_icon.png" \
      --out "$ANDROID_RES/mipmap-${density}/notification_icon.png" >/dev/null 2>&1
    echo "  ✓ mipmap-${density}/notification_icon.png (${notif_size}x${notif_size})"
  done
else
  echo "  ⚠ Skipped — directory not found: $ANDROID_RES"
fi

echo ""
echo "Done! All icon assets replaced."
