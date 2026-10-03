# Capacitor App Icons

AI agent skill that generates all required app icon and splash screen assets for Capacitor projects (iOS, Android, Web/PWA) from a single source image.

**Zero dependencies** -- uses macOS built-in `sips`. No Node packages, no Python, no ImageMagick.

## Installation

```bash
npx skills add orleib/agent-skills --skill capacitor-app-icons
```

## Usage

### Generate Icons

From your Capacitor project root:

```bash
bash scripts/replace-icon.sh /path/to/icon-1024x1024.png
```

This generates all icon sizes for:

| Platform | Output Directory | Assets |
|----------|-----------------|--------|
| Web/PWA | `public/icons/` | 512px, 192px icons + favicon |
| iOS | `ios/App/.../AppIcon.appiconset/` | 16 sizes (20px -- 1024px) |
| Android | `android/app/src/main/res/` | Launcher, round, adaptive foreground, notification icons |

### Generate Splash Screens

```bash
bash scripts/gen-splash.sh "#0f172a"
```

Generates three 2732x2732 solid-color splash images for the iOS asset catalog.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PROJ_ROOT` | Current directory | Project root path |
| `ICON_PREFIX` | `icon` | Web/PWA icon filename prefix (e.g., `myapp` produces `myapp-512.png`) |
| `NOTIFICATION_ICON_SOURCE` | Same as source | Path to a separate white-on-transparent notification icon |

### Examples

```bash
# Custom PWA icon prefix
ICON_PREFIX=myapp bash scripts/replace-icon.sh ./logo.png
# Produces: public/icons/myapp-512.png, public/icons/myapp-192.png

# Separate notification icon (white on transparent)
NOTIFICATION_ICON_SOURCE=./notif.png \
  bash scripts/replace-icon.sh ./logo.png

# Splash with custom color and output directory
bash scripts/gen-splash.sh "#1e293b" ./custom/splash/dir
```

## Source Image Guidelines

- **Format:** PNG, no transparency (iOS rejects transparent app icons)
- **Size:** Exactly 1024x1024 pixels
- **Safe zone:** Keep content within center 80% -- rounded corners crop edges
- **Android adaptive:** Design with ~30% padding for adaptive icon masking

## Output Reference

### Icon Sizes

<details>
<summary>iOS (16 sizes)</summary>

| Size | File |
|------|------|
| 1024 | `1024.png` |
| 512 | `AppIcon-512@2x.png` |
| 180 | `180.png` |
| 167 | `167.png` |
| 152 | `152.png` |
| 120 | `120.png` |
| 114 | `114.png` |
| 87 | `87.png` |
| 80 | `80.png` |
| 76 | `76.png` |
| 60 | `60.png` |
| 58 | `58.png` |
| 57 | `57.png` |
| 40 | `40.png` |
| 29 | `29.png` |
| 20 | `20.png` |

</details>

<details>
<summary>Android (5 densities x 4 types)</summary>

| Density | Launcher | Foreground | Notification |
|---------|----------|------------|--------------|
| mdpi | 48px | 108px | 24px |
| hdpi | 72px | 162px | 36px |
| xhdpi | 96px | 216px | 48px |
| xxhdpi | 144px | 324px | 72px |
| xxxhdpi | 192px | 432px | 96px |

</details>

## Requirements

- **macOS** (uses built-in `sips` command)
- Source image: 1024x1024 PNG

For cross-platform support (Linux/Windows), use the official [@capacitor/assets](https://github.com/ionic-team/capacitor-assets) tool instead.

## License

MIT
