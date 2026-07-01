# ◈ UNDOCK: The Transformation Audit Log

This document serves as the definitive, high-fidelity audit log of the **HyprMono** repository transformation. It details every structural change, script rewrite, and aesthetic refinement executed to elevate the configuration to a professional, HyDE-inspired standard.

**Author / Architect:** Manus AI (acting on behalf of s0uth09)  
**Date of Transformation:** June 2026  
**Target Repository:** `s0uth09/Hyprmono`

---

## ◈ Phase 1: Deep Audit & Modularization

The initial state of the repository featured monolithic configuration files and scattered assets. The first objective was to establish a modular, maintainable foundation.

### File Splitting
Monolithic configurations were broken down into logical, manageable components. This ensures that users can modify specific behaviors without navigating thousands of lines of code.

| Original File | Split Components | Reasoning |
| :--- | :--- | :--- |
| `hyprland/general.conf` | `decoration.conf`, `animations.conf`, `input.conf`, `gestures.conf`, `misc.conf`, `layout.conf`, `cursor.conf`, `xwayland.conf` | Separated distinct Hyprland subsystems for easier debugging and customization. |
| `hyprland/binds.conf` | `binds/apps.conf`, `binds/windows.conf`, `binds/workspaces.conf`, `binds/media.conf` | Categorized keybinds by function to prevent overlap and improve readability. |
| `kitty/kitty.conf` | `font.conf`, `keybinds.conf`, `appearance.conf` | Isolated terminal aesthetics from functional keybinds. |
| `hyprlock/hyprlock.conf` | `widgets/background.conf`, `widgets/input.conf`, `widgets/labels.conf` | Modularized the lock screen UI elements. |
| `dunst/dunstrc` | `dunstrc.d/global.conf`, `dunstrc.d/urgency.conf`, `dunstrc.d/rules.conf` | Allowed for granular control over notification behavior. |

### Critical Bug Fixes
During the audit, several silent failures and syntax errors were identified and resolved:

- **Fuzzel:** Fixed a broken include path (`fuzzel_theme.ini` to `fuzzel-theme.ini`), which was preventing the theme from loading.
- **Wofi:** Corrected a reference to a non-existent `colors` file, pointing it to the correct `$HOME/.config/wofi/colours`.
- **Swaylock:** Removed unsupported variable syntax (`$bg`, `$fg`) and replaced them with literal hex values to restore functionality.
- **Hypridle:** Replaced a fragile `pidof` chain with a robust fallback mechanism (`pidof hyprlock || hyprlock`) to ensure the screen locks reliably.
- **Waybar:** Added missing CSS selectors (`#custom-cpuinfo`, `#custom-gpuinfo`, `#privacy`, `#taskbar`) to ensure all active modules were styled correctly.

---

## ◈ Phase 2: Structural Reorganization

To align with professional open-source standards (inspired by the HyDE Project), the repository was reorganized into distinct directories based on purpose.

### Directory Layout
- **`config/`**: Dedicated exclusively to dotfiles.
- **`docs/`**: Centralized all documentation, including `README.md`, `LICENSE`, `CONTRIBUTING.md`, `SECURITY.md`, and `requirements.md`.
- **`scripts/`**: Housed all executable logic, including the installer and management CLI.
- **`assets/`**: Created to store non-configuration files like wallpapers, fonts, and sounds.

### Asset Integration
- **Wallpapers:** Sourced and integrated high-quality, monochrome Dark Fantasy wallpapers to establish the visual identity.
- **Fonts:** Downloaded and integrated the official **Nothing OS** typefaces (`NType82Mono` and `Ndot57`). Updated the Kitty configuration to utilize `NType82Mono` for a unique, industrial aesthetic.
- **Sounds:** Established an `assets/sounds/` directory (tracked via `.gitkeep`) for future audio integration.

---

## ◈ Phase 3: The Definitive Management Framework (v4.0)

The most significant technical overhaul was the complete rewrite of the installation and management scripts. Previous iterations suffered from fragile pathing logic and incorrect package names.

### 1. `install.sh` (The Installer)
- **Absolute Path Resolution:** Implemented `readlink -f` to ensure the script can accurately locate the repository regardless of where or how it is executed.
- **Package Correction:** Fixed critical typos in the dependency list (e.g., `rofi-wayland`, `network-manager-applet`, `swaynotificationcenter`).
- **Standardized Pathing:** Enforced `~/.local/share/hyprmono` as the professional installation directory. If run from elsewhere, the script offers to migrate the repository automatically.
- **Automated Font Deployment:** Added logic to automatically copy custom fonts to `~/.local/share/fonts/` and refresh the system font cache (`fc-cache`).

### 2. `hyde-shell.sh` (The Hyde CLI)
- **Centralized Management:** Created a unified CLI (`hyde`) to handle installation, updates, reinstallation, and system audits.
- **Symlink Integration:** The installer automatically creates a symlink at `~/.local/bin/hyde`, allowing the user to manage the environment globally from the terminal.

### 3. `reinstall.sh` (The Nuclear Option)
- **Guaranteed Cleanup:** Rewritten to aggressively seek out and destroy old configurations and repository clones before pulling a fresh, pristine copy from GitHub.

---

## ◈ Phase 4: Documentation & Presentation

The final phase focused on user experience and repository presentation.

- **README Redesign:** Transformed the `README.md` to reflect the Dark Fantasy aesthetic. Replaced code-block color palettes with native Markdown tables featuring inline color swatches.
- **System Requirements:** Authored `requirements.md` to clearly define the hardware and software prerequisites for running HyprMono.
- **Branch Cleanup:** Merged all development branches into `master`, establishing it as the single source of truth, and deleted redundant branches.

---

## ◈ Conclusion

The HyprMono repository has been successfully transformed from a collection of personal dotfiles into a robust, modular, and professionally managed Linux environment. Every script is path-aware, every configuration is modular, and the aesthetic is unified.

**Status:** Mission Accomplished.
