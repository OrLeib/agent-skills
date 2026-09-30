---
name: capacitor-app-icons
description: Generate and replace iOS, Android, and PWA app icon and splash screen assets from a source image for Capacitor projects. Use when the user wants to update the app icon, generate icon sizes, create splash screens, or asks about icon requirements.
metadata:
  version: 1.0.0
license: MIT
---

# Capacitor App Icons

Generate all required icon assets (iOS, Android, Web/PWA) from a single 1024x1024 source PNG using bundled shell scripts. macOS only, zero dependencies.

## When to Use This Skill

- User wants to update or replace the app icon
- User needs to generate icons for all platforms
- User asks about required icon sizes for iOS or Android
- User needs a custom notification icon
- User wants to generate splash screen images

## Icon Generation

Run the bundled script from the skill directory:

```bash
bash scripts/replace-icon.sh /path/to/icon-1024x1024.png
```

### Source Image Requirements

- **Format:** PNG, no transparency (iOS rejects transparent app icons)
- **Size:** Exactly 1024x1024 pixels
- **Design:** Keep important content within the center 80% (rounded corners crop edges)
- **Android adaptive:** Design with ~30% padding to account for adaptive icon masking

### What It Generates

**Web / PWA** (`public/icons/`):

| File | Size |
|------|------|
| `{prefix}-512.png` | 512x512 |
| `{prefix}-192.png` | 192x192 |
| `favicon.ico` | 192x192 |

Default prefix is `icon`. Override with `ICON_PREFIX` env var.

**iOS** (`ios/App/App/Assets.xcassets/AppIcon.appiconset/`):
All required sizes: 1024, 180, 167, 152, 120, 87, 80, 76, 58, 40, 29, 20.

Since Xcode 14, you can provide a single 1024x1024 icon and Xcode auto-generates all sizes. Select "Single Size" in the asset catalog inspector. Use "All Sizes" mode only if you need custom-tuned icons at specific sizes.

**Android** (`android/app/src/main/res/`):
- Launcher icons (`ic_launcher.png`, `ic_launcher_round.png`) -- mdpi through xxxhdpi
- Adaptive foreground (`ic_launcher_foreground.png`) -- mdpi through xxxhdpi
- Notification icons (`notification_icon.png`) -- mdpi through xxxhdpi

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PROJ_ROOT` | Current directory | Project root path |
| `ICON_PREFIX` | `icon` | Web/PWA icon filename prefix |
| `NOTIFICATION_ICON_SOURCE` | Same as source | Separate white-on-transparent notification icon |

### Examples

```bash
# Basic usage (run from project root)
bash scripts/replace-icon.sh ./assets/logo.png

# Custom icon prefix for PWA files
ICON_PREFIX=myapp bash scripts/replace-icon.sh ./assets/logo.png

# Separate notification icon
NOTIFICATION_ICON_SOURCE=./assets/notif-white.png \
  bash scripts/replace-icon.sh ./assets/logo.png
```

The script skips iOS or Android sections if their directories don't exist.

## Splash Screen Generation

Generate solid-color iOS splash screens:

```bash
bash scripts/gen-splash.sh "#0f172a"
```

### Arguments

| Position | Default | Description |
|----------|---------|-------------|
| 1 | `#FFFFFF` | Background hex color |
| 2 | `ios/App/.../Splash.imageset` | Output directory |

Generates three 2732x2732 splash images for the iOS asset catalog.

## Alternative: @capacitor/assets

For cross-platform use (Linux/Windows), the official Capacitor tool works on all platforms:

```bash
npm install -D @capacitor/assets
npx capacitor-assets generate
```

Place source files in `resources/icon-only.png` (1024x1024) and `resources/splash.png` (2732x2732).
