#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_VERSION="3.1"
readonly PROJECT="HyprMono"

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOGFILE="$DOTS/install.log"

DRY_RUN=false


RESET="\e[0m"
BLACK="\e[30m"
WHITE="\e[97m"
GRAY="\e[38;5;245m"
LIGHT="\e[38;5;255m"
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
BOLD="\e[1m"
DIM="\e[2m"

WIDTH=$(tput cols 2>/dev/null || echo 80)


log() { printf "[%s] %s\n" "$(date '+%H:%M:%S')" "$*" >> "$LOGFILE"; }
line() { printf "${GRAY}"; printf '─%.0s' $(seq 1 "$WIDTH"); printf "${RESET}\n"; }
title() { echo; echo -e "${BOLD}${LIGHT}$*${RESET}"; line; }
ok() { echo -e "${GREEN}✓${RESET} $*"; log "[ OK ] $*"; }
warn() { echo -e "${YELLOW}!${RESET} $*"; log "[WARN] $*"; }
err() { echo -e "${RED}✗${RESET} $*"; log "[FAIL] $*"; }
info() { echo -e "${CYAN}>${RESET} $*"; log "[INFO] $*"; }


has() { command -v "$1" >/dev/null 2>&1; }

ask() {
    local prompt="$1"
    local default="${2:-n}"
    local response

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]"
    else
        prompt="$prompt [y/N]"
    fi

    printf "${BOLD}${YELLOW}?${RESET} %s " "$prompt"
    read -r response

    [[ -z "$response" ]] && response="$default"

    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

run() {
    if [[ "$DRY_RUN" == true ]]; then
        info "Dry-run: $*"
        return 0
    fi
    "$@"
}

PACMAN_PACKAGES=(
    hyprland hyprlock hyprpaper hypridle waybar kitty wofi rofi fuzzel
    xdg-desktop-portal-hyprland xdg-user-dirs polkit-kde-agent
    ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    nm-applet brightnessctl playerctl wireplumber pipewire-pulse
    swaynotificationcenter dunst wlogout swaylock-effects
    fish fastfetch
)

install_packages() {
    title "Installing packages"
    
    if ! has pacman; then
        err "Pacman not found. This script is for Arch-based systems."
        exit 1
    fi

    local missing=()
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        pacman -Qi "$pkg" &>/dev/null || missing+=("$pkg")
    done

    if (( ${#missing[@]} > 0 )); then
        warn "Missing packages: ${missing[*]}"
        if ask "Install missing packages?" y; then
            run sudo pacman -S --needed --noconfirm "${missing[@]}"
        fi
    else
        ok "All packages are already installed."
    fi
}



install_all_configs() {
    title "Installing configurations"

    log "Backing up existing configs..."
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Dynamically find all folders in $DOTS/config/
    if [[ ! -d "$DOTS/config" ]]; then
        err "Config directory not found in repository!"
        return 1
    fi

    cd "$DOTS/config"
    local config_folders=(*)
    cd "$DOTS"

    for folder in "${config_folders[@]}"; do
        if [[ -d "$DOTS/config/$folder" ]]; then
            # Skip hidden folders or special ones if any
            [[ "$folder" == "." || "$folder" == ".." ]] && continue
            
            if [[ -d "$CONFIG_DIR/$folder" ]]; then
                cp -r "$CONFIG_DIR/$folder" "$backup_dir/"
                log "Backed up $folder"
            fi
            
            mkdir -p "$CONFIG_DIR/$folder"
            cp -r "$DOTS/config/$folder/"* "$CONFIG_DIR/$folder/"
            ok "Installed $folder configuration"
        fi
    done

    # Install scripts
    title "Installing scripts"
    mkdir -p "$LOCAL_BIN"
    if [[ -d "$DOTS/scripts" ]]; then
        # Find all shell scripts in scripts directory
        for script in "$DOTS/scripts"/*.sh; do
            if [[ -f "$script" ]]; then
                local script_name=$(basename "$script")
                cp "$script" "$LOCAL_BIN/"
                chmod +x "$LOCAL_BIN/$script_name"
                ok "Installed $script_name to $LOCAL_BIN"
            fi
        done
    fi

    # Install assets (wallpapers, sounds, fonts)
    title "Installing assets"
    if [[ -d "$DOTS/assets" ]]; then
        mkdir -p "$CONFIG_DIR/hypr/assets"
        cp -r "$DOTS/assets/"* "$CONFIG_DIR/hypr/assets/"
        ok "Installed assets to $CONFIG_DIR/hypr/assets"

        # Special handling for fonts
        if [[ -d "$DOTS/assets/fonts" ]]; then
            info "Installing custom fonts..."
            mkdir -p "$HOME/.local/share/fonts"
            cp "$DOTS/assets/fonts"/*.otf "$HOME/.local/share/fonts/" 2>/dev/null || true
            cp "$DOTS/assets/fonts"/*.ttf "$HOME/.local/share/fonts/" 2>/dev/null || true
            fc-cache -f
            ok "Fonts installed and cache updated"
        fi
    fi
}



banner() {
    clear
    echo -e "${LIGHT}${BOLD}HyprMono Installation Script v${SCRIPT_VERSION}${RESET}"
    line
}

main() {
    banner
    
    if [[ $EUID -eq 0 ]]; then
        err "Do NOT run this script as root."
        exit 1
    fi

    sudo -v || { err "Sudo authentication failed"; exit 1; }

    install_packages
    
    if ask "Install all configurations and scripts?" y; then
        install_all_configs
    fi

    title "Installation Finished"
    echo "Next steps:"
    echo "  1. Reboot your system."
    echo "  2. Select Hyprland session at login."
    echo
    ok "Enjoy your new setup!"
}

# Simple argument parsing
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

main "$@"
