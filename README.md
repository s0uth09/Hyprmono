# HyprMono

A refined, high-contrast monochrome Hyprland configuration. Designed for minimalism, consistency, and performance.

```text
BACKGROUND  #000000    FOREGROUND  #FFFFFF
SURFACE     #111111    BORDER      #444444
ACCENT      #CCCCCC    ACTIVE      #FFFFFF
```

---

## ◈ Design Philosophy

HyprMono is built on the principle of **visual silence**. By stripping away color, the interface becomes a neutral canvas that prioritizes content and focus. Every component—from the status bar to the notification daemon—has been meticulously audited to ensure a perfect grayscale aesthetic.

---

## ◈ Core Components

| Component | Description |
| :--- | :--- |
| **Hyprland** | Native `.conf` based tiling compositor configuration. |
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
    hyprland hyprpaper hypridle hyprlock \
    waybar kitty wofi rofi-wayland fuzzel \
    dunst swaynotificationcenter swaylock \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    brightnessctl playerctl fish fastfetch wlogout
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

## ◈ Customization

All configuration files are now in native `.conf` formats (no Lua dependencies). You can find the main variables in:
`~/.config/hypr/hyprland/variables.conf`

To change the monochrome palette, simply update the hex values in that file and reload Hyprland with `Super + Shift + R`.

---

## ◈ Uninstallation

To safely remove the configuration and restore your previous setup:

```bash
bash ~/.local/bin/uninstall.sh
```

---

## ◈ License
This project is open-source and available under the MIT License.
