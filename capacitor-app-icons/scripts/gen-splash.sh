#!/bin/bash
# Generate solid-color splash screen images for iOS Capacitor apps.
# Uses macOS `sips` (built-in, no dependencies).
#
# Usage:
#   ./gen-splash.sh                        # white, default output dir
#   ./gen-splash.sh "#0f172a"              # custom color
#   ./gen-splash.sh "#0f172a" path/to/dir  # custom color + output dir
#
# Environment variables (all optional):
#   PROJ_ROOT   Project root (default: current directory)

set -euo pipefail

BG_COLOR="${1:-#FFFFFF}"
PROJ_ROOT="${PROJ_ROOT:-$(pwd)}"
OUT_DIR="${2:-$PROJ_ROOT/ios/App/App/Assets.xcassets/Splash.imageset}"
CANVAS=2732

if [ ! -d "$OUT_DIR" ]; then
  echo "Error: Output directory not found: $OUT_DIR"
  echo "Create it first or pass a valid path as the second argument."
  exit 1
fi

TEMP=$(mktemp /tmp/splash-XXXXXX.png)
trap 'rm -f "$TEMP"' EXIT

# Create a 1x1 white PNG, then pad to canvas size with the desired color.
# The minimal valid 1x1 white PNG is 67 bytes.
printf '\x89PNG\r\n\x1a\n' > "$TEMP"
printf '\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02' >> "$TEMP"
printf '\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx' >> "$TEMP"
printf '\x9cc\xf8\x0f\x00\x00\x01\x01\x00\x05\x18\xd8N' >> "$TEMP"
printf '\x00\x00\x00\x00IEND\xaeB\x60\x82' >> "$TEMP"

sips -p "$CANVAS" "$CANVAS" --padColor "$BG_COLOR" "$TEMP" --out "$TEMP" >/dev/null 2>&1

echo "=== iOS Splash Screens (${CANVAS}x${CANVAS}, ${BG_COLOR}) ==="
for name in "splash-2732x2732.png" "splash-2732x2732-1.png" "splash-2732x2732-2.png"; do
  cp "$TEMP" "$OUT_DIR/$name"
  echo "  done: $name"
done

echo ""
echo "Done! Splash screens generated."
