# System Requirements for HyprMono

To ensure a smooth and responsive experience with the HyprMono configuration, we recommend the following minimum and recommended system specifications.

## ◈ Minimum Requirements

These specifications are intended for a functional, albeit basic, experience.

| Component | Minimum Specification |
| :--- | :--- |
| **CPU** | Dual-core 2.0GHz (x86_64) |
| **RAM** | 4 GB DDR4 |
| **GPU** | Integrated Graphics (Intel HD 4000+ / AMD Radeon Vega 3+) |
| **Storage** | 2 GB available space (excluding OS) |
| **Display** | 1280x720 resolution |
| **OS** | Arch Linux (Minimal Install) |

## ◈ Recommended Specifications

For optimal performance, smooth animations, and heavy multitasking.

| Component | Recommended Specification |
| :--- | :--- |
| **CPU** | Quad-core 3.0GHz+ (Ryzen 5 / Core i5 or better) |
| **RAM** | 8 GB+ DDR4/DDR5 |
| **GPU** | Dedicated GPU (NVIDIA GTX 10-series+ / AMD RX 500-series+) |
| **Storage** | SSD with 5 GB+ available space |
| **Display** | 1920x1080 or 4K resolution (144Hz+ supported) |
| **OS** | Arch Linux / EndeavourOS / CachyOS |

## ◈ Software Dependencies

The installation script (`install.sh`) will attempt to install these automatically via `pacman`.

### Core Packages
- `hyprland`: The tiling compositor.
- `waybar`: Status bar.
- `kitty`: Terminal emulator.
- `wofi` / `rofi-wayland`: Application launchers.
- `dunst` / `swaynotificationcenter`: Notifications.
- `hyprpaper`: Wallpaper utility.
- `hyprlock`: Screen locker.
- `hypridle`: Idle management daemon.

### Utilities & Drivers
- `pipewire` / `wireplumber`: Audio backend.
- `brightnessctl` / `playerctl`: Hardware controls.
- `network-manager-applet`: Network tray icon.
- `polkit-kde-agent`: Authentication agent.
- `xdg-desktop-portal-hyprland`: Wayland portal.

### Fonts
- `ttf-jetbrains-mono-nerd`
- `ttf-firacode-nerd`
- `noto-fonts`
- `noto-fonts-emoji`

---

## ◈ Hardware Compatibility Notes

- **NVIDIA Users:** Ensure you have the latest proprietary drivers (`nvidia` or `nvidia-open-dkms`) and have enabled DRM kernel mode setting.
- **Laptops:** Battery and backlight modules in Waybar are pre-configured but may require specific `sysfs` paths depending on your hardware.
- **Multi-Monitor:** Hyprland handles multi-monitor setups natively; check `config/hypr/hyprland/monitors.conf` to customize your layout.
