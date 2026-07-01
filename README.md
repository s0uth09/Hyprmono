<<<<<<< HEAD
<div align="center">
  <h1 align="center">H Y P R M O N O</h1>
  <p align="center">
    <b>A dark fantasy, high-contrast monochrome Hyprland environment.</b><br>
    <i>Inspired by the modularity of the HyDE Project. Designed for visual silence and lethal efficiency.</i>
  </p>
</div>

<p align="center">
  <img src="../assets/wallpapers/dark_fantasy_city.jpg" width="800" alt="Dark Fantasy Monochrome Preview" />
</p>

---

## ◈ Palette

| Role | Color | Hex Code |
| :--- | :---: | :--- |
| **Background** | <img src="https://placehold.co/15x15/000000/000000.png" width="15" height="15" /> | `#000000` |
| **Surface** | <img src="https://placehold.co/15x15/111111/111111.png" width="15" height="15" /> | `#111111` |
| **Border** | <img src="https://placehold.co/15x15/444444/444444.png" width="15" height="15" /> | `#444444` |
| **Accent** | <img src="https://placehold.co/15x15/cccccc/cccccc.png" width="15" height="15" /> | `#CCCCCC` |
| **Foreground / Active** | <img src="https://placehold.co/15x15/ffffff/ffffff/ffffff.png" width="15" height="15" /> | `#FFFFFF` |
=======
#HyprMono
A dark monochrome Hyprland configuration.

```
background  #111111    foreground  #e5e5e5
surface     #222222    border      #444444
accent      #cccccc
```
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8

---

## Contents

<<<<<<< HEAD
HyprMono is built on the principle of **visual silence**. By stripping away color, the interface becomes a neutral canvas that prioritizes content and focus. Every component—from the status bar to the notification daemon—has been meticulously audited and modularized to ensure a perfect grayscale aesthetic.
=======
| Component | What it configures |
|---|---|
| **Hyprland** | Animations, binds, rules, env, monitors, decorations |
| **Hyprlock** | Lock screen layout — clock, date, user, status bar |
| **Hypridle** | Idle timeouts: lock at 5 min, display off at 10, suspend at 15 |
| **Hyprpaper** | Wallpaper daemon |
| **Waybar** | Status bar |
| **Wofi** | Primary app launcher |
| **Rofi** | Alternative launcher (`drun`, `run`, `window` modes) |
| **Kitty** | Terminal — JetBrains Mono, matching colour scheme, split keybinds |
| **Fuzzel** | Compact launcher + emoji picker (`~/.local/bin/fuzzel-emojis`) |
| **Fontconfig** | Font rendering rules |
| **XDG portal** | `hyprland` portal backend |
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8

---

## Requirements

<<<<<<< HEAD
| Component | Description |
| :--- | :--- |
| **Hyprland** | Native `.conf` based tiling compositor configuration, heavily modularized. |
| **Waybar** | Minimalist status bar with custom monochrome modules. |
| **Hyprlock** | Clean, high-contrast lock screen with Nothing OS typography. |
| **Kitty** | GPU-accelerated terminal with a custom grayscale theme and Nothing OS font. |
| **Wofi / Rofi** | Unified application launchers and window switchers. |
| **Dunst / SwayNC** | Ported notification systems for seamless visual integration. |
| **Fuzzel** | Compact launcher with an integrated monochrome emoji picker. |
| **Vim** | Monochrome color scheme for the Vim text editor. |
| **Fish** | Clean and functional shell configuration. |
| **Fastfetch** | System information tool with monochrome output. |
| **Wlogout** | Monochrome logout menu. |
=======
### Required
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8

These must be installed before running the installer.

```bash
# Arch / Arch-based (EndeavourOS, Manjaro, CachyOS…)
sudo pacman -S --needed \
    hyprland hyprpaper hypridle hyprlock \
    kitty wofi

<<<<<<< HEAD
### 1. Requirements
Before installing, please review the [System Requirements](requirements.md) to ensure your hardware is compatible. Ensure you have the following packages installed (Arch Linux / Pacman):

```bash
sudo pacman -S --needed \
    hyprland hyprpaper hypridle waybar kitty wofi rofi-wayland fuzzel \
    xdg-desktop-portal-hyprland xdg-user-dirs polkit-kde-agent \
    ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji \
    network-manager-applet brightnessctl playerctl wireplumber pipewire-pulse \
    swaynotificationcenter dunst wlogout swaylock-effects \
    fish fastfetch
```

### 2. Setup
Clone the repository into the standard local share directory and run the automated installer:

```bash
mkdir -p ~/.local/share
cd ~/.local/share
git clone https://github.com/s0uth09/Hyprmono.git hyprmono
cd hyprmono
bash scripts/install.sh
```

Alternatively, you can use the `hyde` command directly after cloning:

```bash
mkdir -p ~/.local/share
cd ~/.local/share
git clone https://github.com/s0uth09/Hyprmono.git hyprmono
cd hyprmono
./hyde install
=======

### Optional — enables extra features

```bash
sudo pacman -S --needed \
    rofi-wayland \
    fuzzel \
    network-manager-applet \
    playerctl \
    brightnessctl \
    wireplumber \
    ttf-jetbrains-mono-nerd \
    noto-fonts noto-fonts-emoji \
    papirus-icon-theme
```

---

## Installation


```bash
git clone https://github.com/s0uth09/Hyprmono.git ~/.local/share/Hyprmono
cd ~/.local/share/Hyprmono
bash install.sh
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8
```

The installer will:

1. Check for required and optional dependencies
2. Ask which components you want to install
3. Symlink every config file from the repo into `~/.config/`
4. Back up any existing files as `filename.bak.<timestamp>`
5. Create personal override stubs in `~/.config/hypr/custom/`
6. Place helper scripts in `~/.local/bin/`

<<<<<<< HEAD
## ◈ Hyde Shell

HyprMono features a centralized management utility: **Hyde Shell**.

```bash
~/.local/share/hyprmono/hyde [command]
```

For convenience, a symlink `hyde` is created in `~/.local/bin/`, so you can simply run:

```bash
hyde [command]
```

Available commands:
- `install`: Run the main installation script.
- `reinstall`: Completely wipe local configs and reinstall from GitHub.
- `uninstall`: Remove all HyprMono configurations.
- `update`: Pull latest changes and sync configurations.
- `audit`: Perform a system check for dependencies.

---

## ◈ Keybinds

| Key | Action |
| :--- | :--- |
| `Super + Return` | Open Terminal (Kitty) |
| `Super + B` | Launch Browser |
| `Super + E` | Open File Manager |
| `Super + R` | Application Launcher |
| `Super + Q` | Close Active Window |
| `Super + M` | Exit Hyprland |
| `Super + 1-0` | Switch Workspaces |
| `Super + Shift + 1-0` | Move Window to Workspace |

---

## ◈ Configuration Structure

The configuration has been refactored for maximum modularity. You can find the main entry points here:

- **Hyprland Variables:** `~/.config/hypr/hyprland/variables.conf`
- **Keybinds:** `~/.config/hypr/hyprland/binds/` (Split into apps, media, windows, workspaces)
- **General Settings:** `~/.config/hypr/hyprland/general/`
- **Kitty Settings:** `~/.config/kitty/` (Split into font, keybinds, appearance, theme)

To change the monochrome palette, simply update the hex values in `variables.conf` and reload Hyprland with `Super + Shift + R`.

### File Tree

```text
~/.local/share/hyprmono/
├── assets/
│   ├── fonts/
│   ├── sounds/
│   └── wallpapers/
├── config/
│   ├── dunst/
│   ├── fastfetch/
│   ├── fish/
│   ├── ...
├── docs/
│   ├── CONTRIBUTING.md
│   ├── LICENSE
│   ├── README.md
│   ├── requirements.md
│   └── SECURITY.md
├── scripts/
│   ├── hyde-shell.sh
│   ├── install.sh
│   ├── reinstall.sh
│   └── uninstall.sh
├── hyde -> scripts/hyde-shell.sh
├── install.sh -> scripts/install.sh
└── uninstall.sh -> scripts/uninstall.sh
```

---

## ◈ Uninstallation & Reinstallation

To safely remove the configuration and restore your previous setup:

```bash
hyde uninstall
```

If you wish to completely wipe your local configs and reinstall a fresh copy from GitHub:

```bash
hyde reinstall
=======
### 4 — Apply

Log out and back in to start Hyprland, or if already running:

```bash
hyprctl reload
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8
```

---

<<<<<<< HEAD
## ◈ License

This project is open-source and available under the [MIT License](LICENSE).
Copyright (c) 2025 s0uth09.
=======
## File structure

The repo layout mirrors `~/.config` exactly — the path in the repo is the path on disk.

```
Hypr.dots/
├── install.sh
├── README.md
├── scripts/
│   ├── launch_first_available.sh   → ~/.local/bin/
│   └── fuzzel-emojis.sh            → ~/.local/bin/fuzzel-emojis
└── config/
    ├── hypr/
    │   ├── hyprland.conf           ← Hyprland entry point
    │   ├── conf.d/                 ← config modules
    │   │   ├── autostart.conf
    │   │   ├── binds.conf
    │   │   ├── colours.conf
    │   │   ├── env.conf
    │   │   ├── general.conf
    │   │   ├── monitors.conf
    │   │   ├── permission.conf
    │   │   ├── variables.conf
    │   │   └── windowrules.conf
    │   ├── hyprlock/
    │   │   ├── hyprlock.conf
    │   │   ├── hypridle.conf
    │   │   ├── colors.conf
    │   │   ├── status.sh
    │   │   └── caps-lock-check.sh
    │   ├── hyprpaper/
    │   │   ├── hyprpaper.conf
    │   │   └── wallpaper.jpg
    │   └── custom/                 ← your personal overrides, sourced last
    │       ├── env.conf
    │       ├── execs.conf
    │       ├── general.conf
    │       ├── keybinds.conf
    │       ├── rules.conf
    │       └── variables.conf
    ├── wofi/
    │   ├── config
    │   ├── style.css
    │   └── colours
    ├── rofi/
    │   └── config.rasi
    ├── kitty/
    │   ├── kitty.conf
    │   └── kitty-colours.conf
    ├── fuzzel/
    │   ├── fuzzel.ini
    │   └── fuzzel-theme.ini
    ├── fontconfig/
    │   └── fonts.conf
    └── xdg-desktop-portal/
        └── hyprland-portals.conf
```

---

## Personal overrides

The installer creates stub files in `~/.config/hypr/custom/` on first run and **never overwrites them** on future installs. Put your personal settings there.

```bash
~/.config/hypr/custom/
├── env.conf          # extra environment variables
├── execs.conf        # extra autostart commands
├── general.conf      # extra / override general settings
├── keybinds.conf     # extra / override keybinds
├── rules.conf        # extra window rules
└── variables.conf    # override terminal, browser, etc.
```

Example — change the default browser to Firefox:

```ini
# ~/.config/hypr/custom/variables.conf
$browser = firefox
```

---

## Keybinds

| Key | Action |
|---|---|
| `Super + Return` | Terminal (first available: foot, kitty, alacritty…) |
| `Super + E` | File manager (dolphin, nautilus, thunar, yazi…) |
| `Super + B` | Browser (chrome, zen, firefox, brave…) |
| `Super + R` | App launcher (wofi) |
| `Super + 1–0` | Switch workspace |
| `Super + Shift + 1–0` | Move window to workspace |
| `Super + S` | Toggle special workspace |
| `Super + V` | Toggle float |
| `Super + P` | Toggle pseudo-tile |
| `Super + J` | Toggle split direction |
| `Super + ←/→/↑/↓` | Move focus |
| `Super + M` | Exit Hyprland |
| `Alt + F4` | Close window |
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Mute toggle |
| `XF86MonBrightnessUp/Down` | Brightness ±5% |
| `XF86AudioNext/Prev/Play` | Media controls |

---

## Wallpaper

The default wallpaper is at `~/.config/hypr/hyprpaper/wallpaper.jpg`.  
Replace it with any image and reload:

```bash
cp ~/Pictures/my-wallpaper.jpg ~/.config/hypr/hyprpaper/wallpaper.jpg
killall hyprpaper && hyprpaper &
```

---

## Monitors

Edit `~/.config/hypr/conf.d/monitors.conf` to match your setup:

```ini
monitor = eDP-1, 1920x1080, auto, 1

# Second monitor example
monitor = HDMI-A-1, 2560x1440, 1920x0, 1
```

---

## Updating

Pull the latest changes and re-run the installer. Your `~/.config/hypr/custom/` files are never touched.

```bash
cd ~/.local/share/Hyprmono
git pull
bash install.sh
```

---

## Troubleshooting

**Hyprland doesn't start**  
Check `journalctl --user -xe` or `cat /tmp/hyprland*.log` for errors.


**Wallpaper not showing**  
Make sure `hyprpaper` is running and the path in `hyprpaper.conf` exists:
```bash
cat ~/.config/hypr/hyprpaper/hyprpaper.conf
ls ~/.config/hypr/hyprpaper/wallpaper.jpg
```

**Lock screen script errors**  
```bash
chmod +x ~/.config/hypr/hyprlock/status.sh
chmod +x ~/.config/hypr/hyprlock/caps-lock-check.sh
```

**Fonts look wrong**  
```bash
fc-cache -f
# then log out and back in
```
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8
