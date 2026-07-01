#!/usr/bin/env bash

# H Y P R M O N O - The Definitive Installer
# Version: 4.3 (Path & Package Fix)
# Purpose: Robust, path-aware installation for the HyprMono environment.

set -Eeuo pipefail

# --- Absolute Path Resolution ---
# This ensures the script knows the directory where it is located,
# and can also derive the repository root relative to that path.
REAL_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(dirname "$REAL_PATH")
DOTS="$SCRIPTS_DIR"
REPO_ROOT=$(cd "$SCRIPTS_DIR/.." && pwd)

# --- Configuration ---
readonly PROJECT="HyprMono"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOGFILE="$REPO_ROOT/install.log"
TARGET_REPO_DIR="$HOME/.local/share/Hyprmono"

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
    [[ "$default" == "y" ]] && prompt="$prompt [Y/n]" || prompt="$prompt [y/N]"
    printf "${BOLD}${YELLOW}?${RESET} %s " "$prompt"
    read -r response
    [[ -z "$response" ]] && response="$default"
    [[ "$response" =~ ^[Yy]$ ]]
}

# --- Package Management ---
# Using official Arch package names
PACMAN_PACKAGES=(
    hyprland hyprlock hypridle waybar kitty wofi rofi fuzzel
    xdg-desktop-portal-hyprland xdg-user-dirs polkit-kde-agent
    ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    network-manager-applet brightnessctl playerctl wireplumber pipewire-pulse
    swaync dunst wlogout swaylock
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
            sudo pacman -S --needed --noconfirm "${missing[@]}" || {
                err "Pacman failed to install some packages."
                info "If you need AUR packages like 'swaylock-effects' or 'rofi-wayland', please use an AUR helper (yay/paru)."
            }
        fi
    else
        ok "All dependencies met."
    fi
}

# --- Core Installation ---
install_configs() {
    title "Configuration Deployment"

    # Ensure we look in the right place: ~/.local/share/hyprmono/config
    # If the user is running the script from the repo, $REPO_ROOT/config is the source.
    local source_config="$REPO_ROOT/config"

    if [[ ! -d "$source_config" ]]; then
        err "Critical Failure: Config directory not found at $source_config"
        exit 1
    fi

    log "Starting backup..."
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Deploy application configs
    for folder_path in "$source_config"/*; do
        if [[ -d "$folder_path" ]]; then
            local folder_name=$(basename "$folder_path")
            
            if [[ -d "$CONFIG_DIR/$folder_name" ]]; then
                cp -r "$CONFIG_DIR/$folder_name" "$backup_dir/"
                log "Backed up $folder_name"
            fi
            
            mkdir -p "$CONFIG_DIR/$folder_name"
            cp -r "$folder_path/"* "$CONFIG_DIR/$folder_name/"
            ok "Deployed $folder_name"
        fi
    done

    # Deploy scripts to ~/.local/bin
    title "Script Deployment"
    mkdir -p "$LOCAL_BIN"
    for script in "$REPO_ROOT/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            local script_name=$(basename "$script")
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
    if [[ -d "$REPO_ROOT/assets" ]]; then
        mkdir -p "$CONFIG_DIR/hypr/assets"
        cp -r "$REPO_ROOT/assets/"* "$CONFIG_DIR/hypr/assets/"
        ok "Deployed assets to $CONFIG_DIR/hypr/assets"

        # Install fonts
        if [[ -d "$REPO_ROOT/assets/fonts" ]]; then
            info "Updating font cache..."
            mkdir -p "$HOME/.local/share/fonts"
            cp "$REPO_ROOT/assets/fonts"/*.otf "$HOME/.local/share/fonts/" 2>/dev/null || true
            cp "$REPO_ROOT/assets/fonts"/*.ttf "$HOME/.local/share/fonts/" 2>/dev/null || true
            fc-cache -f
            ok "Fonts installed successfully."
        fi
    fi
}

main() {
    clear
    echo -e "${LIGHT}${BOLD}HyprMono Installation Framework${RESET}"
    line

    if [[ $EUID -eq 0 ]]; then
        err "Safety Check: Do NOT run as root."
        exit 1
    fi

    sudo -v || { err "Sudo authentication failed."; exit 1; }

    # Path enforcement
    if [[ "$REPO_ROOT" != "$TARGET_REPO_DIR" ]]; then
        warn "Repository is at $REPO_ROOT instead of $TARGET_REPO_DIR"
        if ask "Migrate repository to standard location ($TARGET_REPO_DIR)?" y; then
            mkdir -p "$TARGET_REPO_DIR"
            cp -r "$REPO_ROOT/"* "$TARGET_REPO_DIR/"
            ok "Migration complete."
            info "Please run: cd $TARGET_REPO_DIR && ./scripts/install.sh"
            exit 0
        fi
    fi

    install_packages
    
    if ask "Proceed with configuration deployment?" y; then
        install_configs
    fi

    title "Success"
    ok "HyprMono has been successfully deployed."
    echo -e "Next Steps:\n  1. Reboot.\n  2. Select Hyprland.\n  3. Use 'hyde' to manage your setup."
}

main "$@"
