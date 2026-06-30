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

    # Step 2: Clean up old repo if it exists (check both old and new paths)
    local OLD_REPO_DIR="$HOME/Hyprmono"
    local NEW_REPO_DIR="$HOME/.local/share/hyprmono"
    
    for dir in "$OLD_REPO_DIR" "$NEW_REPO_DIR"; do
        if [[ -d "$dir" ]]; then
            log "Removing repository at $dir..."
            rm -rf "$dir"
            ok "Removed $dir"
        fi
    done

    # Step 3: Clone fresh repo to the new standard path
    log "Cloning fresh repository to ~/.local/share/hyprmono..."
    mkdir -p "$HOME/.local/share"
    cd "$HOME/.local/share"
    git clone https://github.com/s0uth09/Hyprmono.git hyprmono
    ok "Repository cloned successfully"

    # Step 4: Run the installer from the new path
    log "Starting installation..."
    cd "$NEW_REPO_DIR"
    bash scripts/install.sh
}

main "$@"
