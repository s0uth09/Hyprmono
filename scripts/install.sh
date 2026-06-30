#!/usr/bin/env bash

# H Y P R M O N O - The Definitive Installer
# Version: 4.0 (Final Rewrite)
# Purpose: Robust, path-aware installation for the HyprMono environment.

set -Eeuo pipefail

# --- Absolute Path Resolution ---
# This ensures the script knows where it is, regardless of how it was called.
REAL_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(dirname "$REAL_PATH")
DOTS=$(cd "$SCRIPTS_DIR/.." && pwd)

# --- Configuration ---
readonly PROJECT="HyprMono"
SKIP_PACKAGES=false
ASSUME_YES=false
NO_MIGRATE=false
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOGFILE="$DOTS/install.log"
TARGET_REPO_DIR="$HOME/.local/share/hyprmono"

# --- Colors ---
RESET="\e[0m"
GRAY="\e[38;5;245m"
LIGHT="\e[38;5;255m"
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
BOLD="\e[1m"

WIDTH=$(tput cols 2>/dev/null || echo 80)

# --- Helpers ---
log() { printf "[%s] %s\n" "$(date '+%H:%M:%S')" "$*" >> "$LOGFILE"; }
line() { printf "%b" "${GRAY}"; printf '─%.0s' $(seq 1 "$WIDTH"); printf "%b\n" "${RESET}"; }
title() { echo; echo -e "${BOLD}${LIGHT}$*${RESET}"; line; }
ok() { echo -e "${GREEN}✓${RESET} $*"; log "[ OK ] $*"; }
warn() { echo -e "${YELLOW}!${RESET} $*"; log "[WARN] $*"; }
err() { echo -e "${RED}✗${RESET} $*"; log "[FAIL] $*"; }
info() { echo -e "${CYAN}>${RESET} $*"; log "[INFO] $*"; }

has() { command -v "$1" >/dev/null 2>&1; }

usage() {
    cat <<EOF
Usage: $(basename "$0") [--skip-pkgs] [--yes] [--no-migrate] [--help]

Options:
  --skip-pkgs     Skip package dependency checks and installation.
  --yes, -y       Accept prompts with their yes path for unattended syncs.
  --no-migrate    Do not offer to copy this checkout to the standard location.
  --help          Show this help.
EOF
}

parse_args() {
    while (( $# > 0 )); do
        case "$1" in
            --skip-pkgs|--skip-packages)
                SKIP_PACKAGES=true
                ;;
            -y|--yes)
                ASSUME_YES=true
                ;;
            --no-migrate)
                NO_MIGRATE=true
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                err "Unknown option: $1"
                usage
                exit 2
                ;;
        esac
        shift
    done
}

ask() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    [[ "$default" == "y" ]] && prompt="$prompt [Y/n]" || prompt="$prompt [y/N]"
    if [[ "$ASSUME_YES" == true ]]; then
        return 0
    fi

    if [[ ! -t 0 ]]; then
        [[ "$default" =~ ^[Yy]$ ]]
        return
    fi

    printf "%b %s " "${BOLD}${YELLOW}?${RESET}" "$prompt"
    read -r response
    [[ -z "$response" ]] && response="$default"
    [[ "$response" =~ ^[Yy]$ ]]
}

# --- Package Management ---
PACMAN_PACKAGES=(
    hyprland hyprlock hyprpaper hypridle waybar kitty wofi rofi-wayland fuzzel
    xdg-desktop-portal-hyprland xdg-user-dirs polkit-kde-agent
    ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    network-manager-applet brightnessctl playerctl wireplumber pipewire-pulse
    swaynotificationcenter dunst wlogout swaylock-effects
    fish fastfetch
)

install_packages() {
    title "Package Check"
    if ! has pacman; then
        err "Pacman not found. This script requires an Arch-based system."
        exit 1
    fi

    local missing=()
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        pacman -Qi "$pkg" &>/dev/null || missing+=("$pkg")
    done

    if (( ${#missing[@]} > 0 )); then
        warn "Missing packages: ${missing[*]}"
        if ask "Install missing dependencies?" y; then
            sudo -v || { err "Sudo authentication failed."; exit 1; }
            sudo pacman -S --needed --noconfirm "${missing[@]}"
        fi
    else
        ok "All dependencies met."
    fi
}

# --- Core Installation ---
install_configs() {
    title "Configuration Deployment"

    if [[ ! -d "$DOTS/config" ]]; then
        err "Critical Failure: Config directory not found at $DOTS/config"
        exit 1
    fi

    log "Starting backup..."
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Deploy application configs
    for folder_path in "$DOTS/config"/*; do
        if [[ -d "$folder_path" ]]; then
            local folder_name
            folder_name=$(basename "$folder_path")
            
            if [[ -d "$CONFIG_DIR/$folder_name" ]]; then
                cp -r "$CONFIG_DIR/$folder_name" "$backup_dir/"
                log "Backed up $folder_name"
            fi
            
            mkdir -p "$CONFIG_DIR/$folder_name"
            cp -a "$folder_path/." "$CONFIG_DIR/$folder_name/"
            ok "Deployed $folder_name"
        fi
    done

    # Deploy scripts to ~/.local/bin
    title "Script Deployment"
    mkdir -p "$LOCAL_BIN"
    for script in "$DOTS/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            local script_name
            script_name=$(basename "$script")
            cp "$script" "$LOCAL_BIN/"
            chmod +x "$LOCAL_BIN/$script_name"
            ok "Installed $script_name to $LOCAL_BIN"
        fi
    done

    # Create 'hyde' command symlink
    if [[ -f "$LOCAL_BIN/hyde-shell.sh" ]]; then
        ln -sf "$LOCAL_BIN/hyde-shell.sh" "$LOCAL_BIN/hyde"
        ok "Linked 'hyde' command"
    fi

    # Deploy assets
    title "Asset Deployment"
    if [[ -d "$DOTS/assets" ]]; then
        mkdir -p "$CONFIG_DIR/hypr/assets"
        cp -a "$DOTS/assets/." "$CONFIG_DIR/hypr/assets/"
        ok "Deployed assets to $CONFIG_DIR/hypr/assets"

        # Install fonts
        if [[ -d "$DOTS/assets/fonts" ]]; then
            info "Updating font cache..."
            mkdir -p "$HOME/.local/share/fonts"
            cp "$DOTS/assets/fonts"/*.otf "$HOME/.local/share/fonts/" 2>/dev/null || true
            cp "$DOTS/assets/fonts"/*.ttf "$HOME/.local/share/fonts/" 2>/dev/null || true
            fc-cache -f
            ok "Fonts installed successfully."
        fi
    fi
}

main() {
    [[ -t 1 ]] && clear
    echo -e "${LIGHT}${BOLD}HyprMono Installation Framework${RESET}"
    line

    if [[ $EUID -eq 0 ]]; then
        err "Safety Check: Do NOT run as root."
        exit 1
    fi

    # Path enforcement
    if [[ "$NO_MIGRATE" != true && "$DOTS" != "$TARGET_REPO_DIR" ]]; then
        warn "Repository is at $DOTS instead of $TARGET_REPO_DIR"
        if ask "Migrate repository to standard location?" y; then
            mkdir -p "$TARGET_REPO_DIR"
            cp -a "$DOTS/." "$TARGET_REPO_DIR/"
            ok "Migration complete."
            info "Please run: cd $TARGET_REPO_DIR && ./hyde install"
            exit 0
        fi
    fi

    if [[ "$SKIP_PACKAGES" == true ]]; then
        warn "Skipping package dependency checks."
    else
        install_packages
    fi
    
    if ask "Proceed with configuration deployment?" y; then
        install_configs
    fi

    title "Success"
    ok "HyprMono has been successfully deployed."
    echo -e "Next Steps:\n  1. Reboot.\n  2. Select Hyprland.\n  3. Use 'hyde' to manage your setup."
}

parse_args "$@"
main
