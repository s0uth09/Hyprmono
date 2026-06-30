# HyprMono Configuration Rewrite and Audit Report

## 1. Introduction

This report details the process of rewriting the HyprMono Hyprland configuration from its original Lua-based format to native Hyprland `.conf` files. Additionally, an audit was performed to identify potential bugs, inconsistencies, and suspicious patterns within the repository's configuration and scripts.

## 2. Lua to .conf Rewrite

The original Hyprland configuration in the Hyprmono repository utilized Lua scripts to dynamically generate configuration. This approach, while flexible, deviates from Hyprland's native `.conf` format, which is designed for static, declarative configuration. The rewrite aimed to translate the Lua logic into equivalent `.conf` directives, improving readability, maintainability, and direct compatibility with Hyprland.

The following Lua files were identified and translated:

*   `/home/ubuntu/Hyprmono/config/hypr/hyprland.lua` (main entry point)
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/autostart.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/binds.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/colours.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/env.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/general.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/monitors.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/permission.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/variables.lua`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/windowsrule.lua`

These were rewritten into the following `.conf` files:

*   `/home/ubuntu/Hyprmono/config/hypr/hyprland.conf` (main entry point, sourcing other `.conf` files)
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/autostart.conf`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/binds.conf`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/env.conf`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/general.conf`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/monitors.conf`
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/rules.conf` (from `windowsrule.lua` and `permission.lua`)
*   `/home/ubuntu/Hyprmono/config/hypr/hyprland/variables.conf` (from `variables.lua` and `colours.lua`)

## 3. Audit Findings

During the review of the repository, several potential issues and suspicious patterns were identified:

### 3.1. `install.sh` - Nested Function Definition

The `install.sh` script contains a nested definition of the `detect_package_manager()` function within the `main()` function (lines 732-745). This nested definition shadows an earlier, top-level definition of the same function (lines 254-270) and is never actually invoked. This suggests a potential bug where the intended package manager detection logic might not be executed, or it's an accidental leftover from development.

### 3.2. `hyprpaper.conf` - Hardcoded User Path

The `hyprpaper.conf` file contains a hardcoded absolute path to a wallpaper image: `/home/south/.local/share/hypr/hyprpaper/wallpaper.jpg`. This path is specific to a particular user (`south`) and will likely cause issues for other users attempting to use this configuration without modification. It is recommended to use relative paths or environment variables (e.g., `$HOME`) to ensure portability.

### 3.3. `autostart.lua` (now `autostart.conf`) - External Script and Inconsistent Waybar Path

The `autostart.lua` file, now translated to `autostart.conf`, includes two potentially problematic entries:

*   **External `tsumiki` script**: `exec-once = sleep 5; ~/.config/tsumiki/init.sh -start` calls an external script located in `~/.config/tsumiki/`. The functionality and security implications of this script are unknown without further investigation.
*   **Inconsistent Waybar path**: `exec-once = waybar -c ~/.config/hypr/waybar/config -s ~/.config/hypr/waybar/style.css` specifies a Waybar configuration path that appears inconsistent with the repository's `config/waybar/` structure. The repository contains `config.jsonc` and `style.css` directly under `config/waybar/`, suggesting the command should be `waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waypr/style.css` or similar, depending on the exact Waybar setup. This discrepancy could lead to Waybar failing to load its configuration correctly.

## 4. Conclusion and Recommendations

The HyprMono Hyprland configuration has been successfully rewritten from Lua to native `.conf` files, enhancing its compatibility and maintainability. The audit revealed several areas for improvement, primarily concerning script robustness and path portability.

**Recommendations:**

*   **`install.sh`**: Review and correct the `detect_package_manager()` function definition to ensure the correct logic is executed and remove any redundant code.
*   **`hyprpaper.conf`**: Modify the wallpaper path to be relative or use an environment variable for better portability across different user environments.
*   **`autostart.conf`**: Investigate the `~/.config/tsumiki/init.sh` script for its purpose and security implications. Correct the Waybar configuration path to accurately reflect the repository's structure and ensure proper loading of Waybar.

These changes will contribute to a more robust, portable, and easily maintainable Hyprland configuration.
