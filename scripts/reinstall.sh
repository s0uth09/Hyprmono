#!/usr/bin/env bash

# H Y P R M O N O - The Reinstaller
# Purpose: Total cleanup and fresh deployment from GitHub.

set -Eeuo pipefail

<<<<<<< HEAD
# --- Configuration ---
CONFIG_DIR="$HOME/.config"
NEW_PATH="$HOME/.local/share/hyprmono"
OLD_PATH="$HOME/Hyprmono"
TARGETS=(hypr kitty wofi rofi fuzzel waybar swaylock swaync dunst fastfetch fish vim wlogout fontconfig xdg-desktop-portal kde-material-you-colors)
=======
# --- Absolute Path Resolution ---
REAL_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(dirname "$REAL_PATH")
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8

# --- Colors ---
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
BOLD="\e[1m"
RESET="\e[0m"

# --- Helpers ---
<<<<<<< HEAD
log() { printf '%b> %s%b\n' "${CYAN}" "$*" "${RESET}"; }
ok() { printf '%b✓%b %s\n' "${GREEN}" "${RESET}" "$*"; }
err() { printf '%b✗%b %s\n' "${RED}" "${RESET}" "$*" >&2; }

confirm() {
    local prompt="$1"

    if [[ ! -t 0 ]]; then
        err "Refusing destructive reinstall without an interactive confirmation."
        exit 1
    fi

    printf '%b?%b %s [y/N] ' "${BOLD}${YELLOW}" "${RESET}" "$prompt"
    read -r -n 1 reply
    printf '\n'

    [[ "$reply" =~ ^[Yy]$ ]] || exit 1
}

main() {
    [[ -t 1 ]] && clear
    printf '%bHyprMono Fresh Reinstallation%b\n' "${BOLD}" "${RESET}"
    printf 'Warning: This will wipe your current configurations and pull a fresh copy from GitHub.\n\n'

    if [[ $EUID -eq 0 ]]; then
        err "Do not run this script as root."
        exit 1
    fi

    if ! command -v git >/dev/null 2>&1; then
        err "git is required for reinstall."
        exit 1
    fi

    confirm "Proceed with total reset?"

    log "Wiping existing configurations..."
    for target in "${TARGETS[@]}"; do
        if [[ -d "$CONFIG_DIR/$target" ]]; then
            rm -rf -- "$CONFIG_DIR/$target"
            ok "Cleared $target"
        fi
    done

    for dir in "$OLD_PATH" "$NEW_PATH"; do
        if [[ -d "$dir" ]]; then
            log "Clearing repository at $dir..."
            rm -rf -- "$dir"
        fi
    done

    log "Deploying fresh repository to $NEW_PATH..."
=======
log() { echo -e "${CYAN}>${RESET} $*"; }
ok() { echo -e "${GREEN}✓${RESET} $*"; }
err() { echo -e "${RED}✗${RESET} $*"; }

confirm() {
    read -p "$(echo -e "${BOLD}${YELLOW}?${RESET} $1 [y/N] ")" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

main() {
    clear
    echo -e "${BOLD}HyprMono Fresh Reinstallation${RESET}"
    echo "Warning: This will wipe your current configurations and pull a fresh copy from GitHub."
    echo
    confirm "Proceed with total reset?"

    # 1. Configuration Wipe
    log "Wiping existing configurations..."
    local CONFIG_DIR="$HOME/.config"
    local TARGETS=(hypr kitty wofi rofi fuzzel waybar swaylock swaync dunst fastfetch fish vim wlogout fontconfig xdg-desktop-portal kde-material-you-colors)
    
    for t in "${TARGETS[@]}"; do
        if [[ -d "$CONFIG_DIR/$t" ]]; then
            rm -rf "$CONFIG_DIR/$t"
            ok "Cleared $t"
        fi
    done

    # 2. Repository Migration/Cleanup
    local OLD_PATH="$HOME/Hyprmono"
    local NEW_PATH="$HOME/.local/share/hyprmono"
    
    for dir in "$OLD_PATH" "$NEW_PATH"; do
        if [[ -d "$dir" ]]; then
            log "Clearing repository at $dir..."
            rm -rf "$dir"
        fi
    done

    # 3. Fresh Clone
    log "Deploying fresh repository to ~/.local/share/hyprmono..."
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8
    mkdir -p "$HOME/.local/share"
    git clone https://github.com/s0uth09/Hyprmono.git "$NEW_PATH"
    ok "Deployment successful."

<<<<<<< HEAD
    log "Initializing Framework..."
    cd "$NEW_PATH"
    bash scripts/install.sh --no-migrate
=======
    # 4. Trigger Installer
    log "Initializing Framework..."
    cd "$NEW_PATH"
    bash scripts/install.sh
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8
}

main "$@"
