#!/usr/bin/env bash

# HyprMono Reinstaller
# This script will remove existing configurations, download a fresh copy of the repository, and reinstall.

set -Eeuo pipefail

# --- Colors ---
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
BOLD="\e[1m"
RESET="\e[0m"

# --- Helpers ---
log() { echo -e "${CYAN}>${RESET} $*"; }
ok() { echo -e "${GREEN}✓${RESET} $*"; }
warn() { echo -e "${YELLOW}!${RESET} $*"; }
err() { echo -e "${RED}✗${RESET} $*"; }

confirm() {
    read -p "$(echo -e "${BOLD}${YELLOW}?${RESET} $1 [y/N] ")" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

main() {
    echo -e "${BOLD}HyprMono Reinstaller${RESET}"
    echo "This will completely remove your current HyprMono configuration, clone a fresh copy from GitHub, and reinstall it."
    echo
    confirm "Are you sure you want to proceed? Any local changes will be lost."

    # Step 1: Remove existing configs
    log "Removing existing configurations..."
    local CONFIG_DIR="$HOME/.config"
    local TARGETS=(hypr kitty wofi rofi fuzzel waybar swaylock swaync dunst fastfetch fish vim wlogout fontconfig xdg-desktop-portal kde-material-you-colors)
    
    for t in "${TARGETS[@]}"; do
        if [[ -d "$CONFIG_DIR/$t" ]]; then
            rm -rf "$CONFIG_DIR/$t"
            ok "Removed $CONFIG_DIR/$t"
        fi
    done

    # Step 2: Clean up old repo if it exists
    local REPO_DIR="$HOME/Hyprmono"
    if [[ -d "$REPO_DIR" ]]; then
        log "Removing old repository directory..."
        rm -rf "$REPO_DIR"
        ok "Removed $REPO_DIR"
    fi

    # Step 3: Clone fresh repo
    log "Cloning fresh repository from GitHub..."
    cd "$HOME"
    git clone https://github.com/s0uth09/Hyprmono.git
    ok "Repository cloned successfully"

    # Step 4: Run the installer
    log "Starting installation..."
    cd "$REPO_DIR"
    chmod +x install.sh
    bash install.sh
}

main "$@"
