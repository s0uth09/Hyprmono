#!/usr/bin/env bash

# H Y D E   S H E L L - The Definitive CLI
# Centralized entry point for the HyprMono environment.

set -Eeuo pipefail

# --- Absolute Path Resolution ---
REAL_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(dirname "$REAL_PATH")
REPO_DIR=$(cd "$SCRIPTS_DIR/.." && pwd)

# --- Colors ---
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
MAGENTA="\e[38;5;213m"
BOLD="\e[1m"
RESET="\e[0m"

# --- Helpers ---
log() { echo -e "${CYAN}hyde >${RESET} $*"; }
err() { echo -e "${RED}hyde error >${RESET} $*" >&2; }

show_help() {
    echo -e "${BOLD}${MAGENTA}H Y D E   S H E L L${RESET} - HyprMono Management"
    echo
    echo -e "${BOLD}Usage:${RESET} hyde [command]"
    echo
    echo -e "${BOLD}Commands:${RESET}"
    echo -e "  install     Execute the professional installer"
    echo -e "  reinstall   Wipe and perform a fresh install from GitHub"
    echo -e "  uninstall   Completely remove all configurations"
    echo -e "  update      Pull latest repository changes and sync"
    echo -e "  audit       Verify system dependencies"
    echo -e "  help        Display this help interface"
    echo
}

case "${1:-help}" in
    install)
        log "Initializing Installer..."
        bash "$SCRIPTS_DIR/install.sh"
        ;;
    reinstall)
        log "Initializing Reinstaller..."
        bash "$SCRIPTS_DIR/reinstall.sh"
        ;;
    uninstall)
        log "Initializing Uninstaller..."
        bash "$SCRIPTS_DIR/uninstall.sh"
        ;;
    update)
        log "Syncing Repository..."
        if [[ -d "$REPO_DIR/.git" ]]; then
            cd "$REPO_DIR"
            git pull origin master
            log "Syncing Configurations..."
            bash "$SCRIPTS_DIR/install.sh" --skip-pkgs
        else
            err "Update failed: Not a git repository."
        fi
        ;;
    audit)
        log "Running System Audit..."
        missing=()
        for bin in hyprland waybar kitty wofi dunst; do
            if ! command -v "$bin" &> /dev/null; then
                missing+=("$bin")
            fi
        done
        if [ ${#missing[@]} -eq 0 ]; then
            log "${GREEN}Audit successful: Core components present.${RESET}"
        else
            err "Audit failed: Missing components: ${missing[*]}"
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        err "Invalid command: $1"
        show_help
        exit 1
        ;;
esac
