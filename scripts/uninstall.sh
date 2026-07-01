#!/usr/bin/env bash

# HyprMono Uninstaller
# Version: 1.1

set -Eeuo pipefail

# --- Configuration ---
CONFIG_DIR="$HOME/.config"
TARGETS=(hypr kitty wofi rofi fuzzel waybar swaylock swaync dunst fastfetch fish vim wlogout fontconfig xdg-desktop-portal kde-material-you-colors)
BACKUP_PREFIX=".config-backup-"

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

# --- Functions ---
confirm() {
    read -p "$(echo -e "${BOLD}${YELLOW}?${RESET} $1 [y/N] ")" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

remove_configs() {
    log "Removing HyprMono configurations..."
    for t in "${TARGETS[@]}"; do
        if [[ -d "$CONFIG_DIR/$t" ]]; then
            rm -rf "$CONFIG_DIR/$t"
            ok "Removed $CONFIG_DIR/$t"
        fi
    done
}

restore_latest_backup() {
    log "Searching for latest backup..."
    # Find directories starting with the backup prefix, sorted by name (date) descending
    local latest_backup=$(ls -d "$HOME"/${BACKUP_PREFIX}* 2>/dev/null | sort -r | head -n 1 || true)

    if [[ -n "$latest_backup" ]]; then
        warn "Found backup: $latest_backup"
        confirm "Restore this backup?"
        
        for t in "${TARGETS[@]}"; do
            if [[ -d "$latest_backup/$t" ]]; then
                cp -r "$latest_backup/$t" "$CONFIG_DIR/"
                ok "Restored $t from backup"
            fi
        done
    else
        warn "No backups found to restore."
    fi
}

# --- Main ---
main() {
    echo -e "${BOLD}HyprMono Uninstaller${RESET}"
    echo "This will remove HyprMono configurations from your system."
    echo
    
    confirm "Are you sure you want to proceed?"
    
    remove_configs
    echo
    restore_latest_backup
    
    echo
    ok "Uninstallation complete."
    log "Note: System packages installed by HyprMono were not removed."
}

main "$@"
