<div align="center">
  <h1 align="center">H Y P R M O N O</h1>
  <p align="center">
    <b>A refined, high-contrast monochrome Hyprland configuration.</b><br>
    <i>Designed for minimalism, modularity, consistency, and performance.</i>
  </p>
</div>

---

## ◈ Palette

| Role | Color | Hex Code |
| :--- | :---: | :--- |
| **Background** | <img src="https://placehold.co/15x15/000000/000000.png" width="15" height="15" /> | `#000000` |
| **Surface** | <img src="https://placehold.co/15x15/111111/111111.png" width="15" height="15" /> | `#111111` |
| **Border** | <img src="https://placehold.co/15x15/444444/444444.png" width="15" height="15" /> | `#444444` |
| **Accent** | <img src="https://placehold.co/15x15/cccccc/cccccc.png" width="15" height="15" /> | `#CCCCCC` |
| **Foreground / Active** | <img src="https://placehold.co/15x15/ffffff/ffffff.png" width="15" height="15" /> | `#FFFFFF` |

---

## ◈ Design Philosophy

HyprMono is built on the principle of **visual silence**. By stripping away color, the interface becomes a neutral canvas that prioritizes content and focus. Every component—from the status bar to the notification daemon—has been meticulously audited and modularized to ensure a perfect grayscale aesthetic.

---

## ◈ Core Components

| Component | Description |
| :--- | :--- |
| **Hyprland** | Native `.conf` based tiling compositor configuration, heavily modularized. |
| **Waybar** | Minimalist status bar with custom monochrome modules. |
| **Hyprlock** | Clean, high-contrast lock screen with JetBrains Mono typography. |
| **Kitty** | GPU-accelerated terminal with a custom grayscale theme. |
| **Wofi / Rofi** | Unified application launchers and window switchers. |
| **Dunst / SwayNC** | Ported notification systems for seamless visual integration. |
| **Fuzzel** | Compact launcher with an integrated monochrome emoji picker. |
| **Vim** | Monochrome color scheme for the Vim text editor. |
| **Fish** | Clean and functional shell configuration. |
| **Fastfetch** | System information tool with monochrome output. |
| **Wlogout** | Monochrome logout menu. |

---

## ◈ Installation

### 1. Requirements
Ensure you have the following packages installed (Arch Linux / Pacman):

```bash
sudo pacman -S --needed \
    hyprland hyprpaper hypridle waybar kitty wofi rofi-wayland fuzzel \
    xdg-desktop-portal-hyprland xdg-user-dirs polkit-kde-agent \
    ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji \
    nm-applet brightnessctl playerctl wireplumber pipewire-pulse \
    swaynotificationcenter dunst wlogout swaylock-effects \
    fish fastfetch
```

### 2. Setup
Clone the repository and run the automated installer:

```bash
git clone https://github.com/s0uth09/Hyprmono.git
cd Hyprmono
bash install.sh
```

The installer will automatically handle backups of your existing configurations and place all files in their correct locations.

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
.
├── config/
│   ├── dunst/
│   ├── fastfetch/
│   ├── fish/
│   ├── fontconfig/
│   ├── fuzzel/
│   ├── hypr/
│   │   ├── hyprland/
│   │   │   ├── binds/
│   │   │   ├── general/
│   │   │   └── ...
│   │   ├── hyprlock/
│   │   │   └── widgets/
│   │   └── hyprpaper/
│   ├── kde-material-you-colors/
│   ├── kitty/
│   ├── rofi/
│   ├── swaylock/
│   ├── swaync/
│   ├── vim/
│   ├── waybar/
│   ├── wlogout/
│   ├── wofi/
│   └── xdg-desktop-portal/
├── scripts/
├── install.sh
├── reinstall.sh
└── uninstall.sh
```

---

## ◈ Uninstallation & Reinstallation

To safely remove the configuration and restore your previous setup:

```bash
bash ~/.local/bin/uninstall.sh
```

If you wish to completely wipe your local configs and reinstall a fresh copy from GitHub:

```bash
bash reinstall.sh
```

---

## ◈ License

This project is open-source and available under the [MIT License](LICENSE).
Copyright (c) 2025 s0uth09.
