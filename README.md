#HyprMono
A dark monochrome Hyprland configuration.

```
background  #111111    foreground  #e5e5e5
surface     #222222    border      #444444
accent      #cccccc
```

---

## Contents

| Component | What it configures |
|---|---|
| **Hyprland** | Animations, binds, rules, env, monitors, decorations |
| **Hyprlock** | Lock screen layout — clock, date, user, status bar |
| **Hypridle** | Idle timeouts: lock at 5 min, display off at 10, suspend at 15 |
| **Hyprpaper** | Wallpaper daemon |
| **Waybar** | Status bar with colours |
| **Wofi** | Primary app launcher |
| **Rofi** | Alternative launcher (`drun`, `run`, `window` modes) |
| **Kitty** | Terminal — JetBrains Mono, matching colour scheme, split keybinds |
| **Fuzzel** | Compact launcher + emoji picker (`~/.local/bin/fuzzel-emojis`) |
| **Fontconfig** | Font rendering rules |
| **XDG portal** | `hyprland` portal backend |

---

## Requirements

### Required

These must be installed before running the installer.

```bash
# Arch / Arch-based (EndeavourOS, Manjaro, CachyOS…)
sudo pacman -S --needed \
    hyprland hyprpaper hypridle hyprlock \
    waybar kitty wofi
```

> The installer will detect missing packages and offer to install them via `pacman` if it is available.

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
```

The installer will:

1. Check for required and optional dependencies
2. Ask which components you want to install
3. Symlink every config file from the repo into `~/.config/`
4. Back up any existing files as `filename.bak.<timestamp>`
5. Create personal override stubs in `~/.config/hypr/custom/`
6. Place helper scripts in `~/.local/bin/`

### 4 — Apply

Log out and back in to start Hyprland, or if already running:

```bash
hyprctl reload
killall -SIGUSR2 waybar
```

---

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
    │   ├── hyprland.lua            ← Hyprland entry point
    │   ├── hyprland/               ← config modules
    │   │   ├── autostart.lua
    │   │   ├── binds.lua
    │   │   ├── colours.lua
    │   │   ├── env.lua
    │   │   ├── general.lua
    │   │   ├── monitors.lua
    │   │   ├── overlay.lua
    │   │   ├── permission.lua
    │   │   ├── variables.lua
    │   │   └── windowsrule.lua
    │   ├── hyprlock/
    │   │   ├── hyprlock.conf
    │   │   ├── hypridle.conf
    │   │   ├── colors.conf
    │   │   ├── status.sh
    │   │   └── caps-lock-check.sh
    │   ├── hyprpaper/
    │   │   ├── hyprpaper.conf
    │   │   └── wallpaper.jpg
    │   ├── lib/
    │   │   └── init.lua
    │   ├── services/
    │   │   ├── init.lua
    │   │   └── custom_config.lua
    │   └── custom/                 ← your personal overrides (created on first install)
    │       ├── env.lua
    │       ├── execs.lua
    │       ├── keybinds.lua
    │       ├── rules.lua
    │       └── variables.lua
    ├── waybar/
    │   ├── config.jsonc
    │   ├── style.css
    │   └── colours/colours.css
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
├── env.lua          # extra environment variables
├── execs.lua        # extra autostart commands
├── keybinds.lua     # extra / override keybinds
├── rules.lua        # extra window rules
└── variables.lua    # override terminal, browser, etc.
```

Example — change the default browser to Firefox:

```lua
-- ~/.config/hypr/custom/variables.lua
browser = "firefox"
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

Edit `~/.config/hypr/hyprland/monitors.lua` to match your setup:

```lua
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080",
    position = "auto",
    scale    = "1",
})

-- Second monitor example
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "2560x1440",
    position = "1920x0",
    scale    = "1",
})
```

---

## Updating

Pull the latest changes and re-run the installer. Your `~/.config/hypr/custom/` files are never touched.

```bash
cd ~/.local/share/Hypr.dots
git pull
bash install.sh
```

---

## Troubleshooting

**Hyprland doesn't start**  
Check `journalctl --user -xe` or `cat /tmp/hyprland*.log` for errors.

**Waybar is blank or missing**  
```bash
killall waybar; waybar &
# check for errors:
waybar 2>&1 | head -40
```

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
