#!/usr/bin/env bash

# H Y D E   S H E L L - Hyprmono Development & Resource Assistant
# Centralized CLI for managing the Hyprmono environment.

set -Eeuo pipefail

# --- Colors ---
RED="\e[38;5;203m"
GREEN="\e[38;5;114m"
YELLOW="\e[38;5;222m"
CYAN="\e[38;5;117m"
MAGENTA="\e[38;5;213m"
BOLD="\e[1m"
RESET="\e[0m"

# --- Config ---
# The script might be called via a symlink or directly.
# We want to find the real path of the script to locate the repository.
REAL_PATH=$(readlink -f "${BASH_SOURCE[0]}")
REPO_DIR="$(cd "$(dirname "$REAL_PATH")/.." && pwd)"
SCRIPTS_DIR="$REPO_DIR/scripts"

# --- Helpers ---
log() { echo -e "${CYAN}hyde >${RESET} $*"; }
err() { echo -e "${RED}hyde error >${RESET} $*" >&2; }

show_help() {
    echo -e "${BOLD}${MAGENTA}H Y D E   S H E L L${RESET} - Hyprmono CLI"
    echo
    echo -e "${BOLD}Usage:${RESET} hyde [command] [options]"
    echo
    echo -e "${BOLD}Commands:${RESET}"
    echo -e "  install     Run the main installation script"
    echo -e "  reinstall   Completely wipe and reinstall from GitHub"
    echo -e "  uninstall   Remove all Hyprmono configurations"
    echo -e "  update      Pull latest changes and sync configs"
    echo -e "  audit       Perform a system check for Hyprmono dependencies"
    echo -e "  help        Show this help message"
    echo
}

case "${1:-help}" in
    install)
        log "Launching installer..."
        bash "$SCRIPTS_DIR/install.sh"
        ;;
    reinstall)
        log "Launching reinstaller..."
        bash "$SCRIPTS_DIR/reinstall.sh"
        ;;
    uninstall)
        log "Launching uninstaller..."
        bash "$SCRIPTS_DIR/uninstall.sh"
        ;;
    update)
        log "Updating Hyprmono..."
        if [[ -d "$REPO_DIR/.git" ]]; then
            cd "$REPO_DIR"
            git pull origin master
            log "Syncing configurations..."
            bash "$SCRIPTS_DIR/install.sh" --skip-pkgs
        else
            err "Not a git repository. Cannot update via git."
        fi
        ;;
    audit)
        log "Auditing system..."
        missing=()
        # Check for core binaries
        for pkg in hyprland waybar kitty wofi dunst; do
            if ! command -v "$pkg" &> /dev/null; then
                missing+=("$pkg")
            fi
        done
        if [ ${#missing[@]} -eq 0 ]; then
            log "${GREEN}System audit passed.${RESET}"
        else
            err "Missing core packages: ${missing[*]}"
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        err "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
