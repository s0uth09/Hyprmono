#!/usr/bin/env bash

# HyprMono Uninstaller
# Version: 1.1

set -Eeuo pipefail

# --- Configuration ---
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
TARGETS=(hypr kitty wofi rofi fuzzel waybar swaylock swaync dunst fastfetch fish vim wlogout fontconfig xdg-desktop-portal kde-material-you-colors)
INSTALLED_SCRIPTS=(cpuinfo.sh fuzzel-emojis.sh gpuinfo.sh hyde hyde-shell.sh install.sh launch_first_available.sh reinstall.sh uninstall.sh)
BACKUP_PREFIX=".config-backup-"

# --- Colors ---
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
BOLD="\e[1m"
RESET="\e[0m"

# --- Helpers ---
log() { printf '%b> %s%b\n' "${CYAN}" "$*" "${RESET}"; }
ok() { printf '%b✓%b %s\n' "${GREEN}" "${RESET}" "$*"; }
warn() { printf '%b!%b %s\n' "${YELLOW}" "${RESET}" "$*"; }
err() { printf '%b✗%b %s\n' "${RED}" "${RESET}" "$*" >&2; }

confirm() {
    local prompt="$1"

    if [[ ! -t 0 ]]; then
        err "Refusing destructive uninstall without an interactive confirmation."
        exit 1
    fi

    printf '%b?%b %s [y/N] ' "${BOLD}${YELLOW}" "${RESET}" "$prompt"
    read -r -n 1 reply
    printf '\n'

    [[ "$reply" =~ ^[Yy]$ ]] || exit 1
}

remove_configs() {
    log "Removing HyprMono configurations..."
    for target in "${TARGETS[@]}"; do
        if [[ -d "$CONFIG_DIR/$target" ]]; then
            rm -rf -- "$CONFIG_DIR/$target"
            ok "Removed $CONFIG_DIR/$target"
        fi
    done
}

remove_installed_scripts() {
    log "Removing installed HyprMono scripts..."
    for script in "${INSTALLED_SCRIPTS[@]}"; do
        if [[ -e "$LOCAL_BIN/$script" || -L "$LOCAL_BIN/$script" ]]; then
            rm -f -- "$LOCAL_BIN/$script"
            ok "Removed $LOCAL_BIN/$script"
        fi
    done
}

restore_latest_backup() {
    log "Searching for latest backup..."

    local latest_backup
    latest_backup=$(find "$HOME" -maxdepth 1 -type d -name "${BACKUP_PREFIX}*" -printf '%f\n' 2>/dev/null | sort -r | head -n 1 || true)

    if [[ -n "$latest_backup" ]]; then
        latest_backup="$HOME/$latest_backup"
        warn "Found backup: $latest_backup"
        confirm "Restore this backup?"

        for target in "${TARGETS[@]}"; do
            if [[ -d "$latest_backup/$target" ]]; then
                cp -a "$latest_backup/$target" "$CONFIG_DIR/"
                ok "Restored $target from backup"
            fi
        done
    else
        warn "No backups found to restore."
    fi
}

main() {
    printf '%bHyprMono Uninstaller%b\n' "${BOLD}" "${RESET}"
    printf 'This will remove HyprMono configurations from your system.\n\n'

    if [[ $EUID -eq 0 ]]; then
        err "Do not run this script as root."
        exit 1
    fi

    confirm "Are you sure you want to proceed?"

    remove_configs
    remove_installed_scripts
    printf '\n'
    restore_latest_backup

    printf '\n'
    ok "Uninstallation complete."
    log "Note: System packages installed by HyprMono were not removed."
}

main "$@"
