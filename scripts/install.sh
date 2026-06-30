#!/usr/bin/env bash

# H Y P R M O N O - Installation Script
# Professional installer for the HyprMono environment.

set -Eeuo pipefail

readonly SCRIPT_VERSION="3.2"
readonly PROJECT="HyprMono"
readonly GITHUB_REPO="https://github.com/s0uth09/Hyprmono.git"

# --- Paths ---
# Since install.sh is now in scripts/, DOTS should be the parent directory
DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOGFILE="$DOTS/install.log"

# --- Repository Placement ---
# We want the repository to live in ~/.local/share/hyprmono
TARGET_REPO_DIR="$HOME/.local/share/hyprmono"

DRY_RUN=false

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

# --- Packages ---
PACMAN_PACKAGES=(
    hyprland hyprlock hyprpaper hypridle waybar kitty wofi rofi-wayland fuzzel
    xdg-desktop-portal-hyprland xdg-user-dirs polkit-kde-agent
    ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    network-manager-applet brightnessctl playerctl wireplumber pipewire-pulse
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
            sudo pacman -S --needed --noconfirm "${missing[@]}"
        fi
    else
        ok "All packages are already installed."
    fi
}

# --- Config Installation ---
install_all_configs() {
    title "Installing configurations"

    if [[ ! -d "$DOTS/config" ]]; then
        err "Config directory not found at: $DOTS/config"
        exit 1
    fi

    log "Backing up existing configs..."
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Iterate through folders in repo's config directory
    for folder_path in "$DOTS/config"/*; do
        if [[ -d "$folder_path" ]]; then
            local folder_name=$(basename "$folder_path")
            
            # Backup if exists
            if [[ -d "$CONFIG_DIR/$folder_name" ]]; then
                cp -r "$CONFIG_DIR/$folder_name" "$backup_dir/"
                log "Backed up $folder_name"
            fi
            
            # Install new config
            mkdir -p "$CONFIG_DIR/$folder_name"
            cp -r "$folder_path/"* "$CONFIG_DIR/$folder_name/"
            ok "Installed $folder_name configuration"
        fi
    done

    # Install scripts
    title "Installing scripts"
    mkdir -p "$LOCAL_BIN"
    for script in "$DOTS/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            local script_name=$(basename "$script")
            cp "$script" "$LOCAL_BIN/"
            chmod +x "$LOCAL_BIN/$script_name"
            ok "Installed $script_name to $LOCAL_BIN"
        fi
    done

    # Create the 'hyde' symlink for the main CLI
    if [[ -f "$LOCAL_BIN/hyde-shell.sh" ]]; then
        ln -sf "$LOCAL_BIN/hyde-shell.sh" "$LOCAL_BIN/hyde"
        ok "Created 'hyde' command in $LOCAL_BIN"
    fi

    # Install assets
    title "Installing assets"
    if [[ -d "$DOTS/assets" ]]; then
        mkdir -p "$CONFIG_DIR/hypr/assets"
        cp -r "$DOTS/assets/"* "$CONFIG_DIR/hypr/assets/"
        ok "Installed assets to $CONFIG_DIR/hypr/assets"

        # Fonts
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

# --- GitHub Integration ---
sync_repo() {
    title "Syncing with GitHub"
    if [[ -d "$DOTS/.git" ]]; then
        info "Local repository detected. Pulling latest changes..."
        cd "$DOTS"
        git pull origin master
        ok "Repository synced."
    else
        warn "Not a git repository. Skipping sync."
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

    # Ensure repository is in the correct location (~/.local/share/hyprmono)
    if [[ "$DOTS" != "$TARGET_REPO_DIR" ]]; then
        info "Moving repository to $TARGET_REPO_DIR..."
        mkdir -p "$HOME/.local/share"
        # If the target exists, we might want to back it up or just merge
        if [[ -d "$TARGET_REPO_DIR" && "$DOTS" != "$TARGET_REPO_DIR" ]]; then
            warn "Target directory $TARGET_REPO_DIR already exists."
        fi
        
        # We don't move 'DOTS' while running from it, but we can copy and advise
        cp -r "$DOTS" "$TARGET_REPO_DIR"
        ok "Repository copied to $TARGET_REPO_DIR"
        info "Please run the installer from the new location: cd $TARGET_REPO_DIR && bash scripts/install.sh"
        # If we are in the middle of an install, we continue but warn
    fi

    if ask "Sync with GitHub repository before installing?" y; then
        sync_repo
    fi

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
if [[ "${1:-}" == "--skip-pkgs" ]]; then
    # Helper for fast updates
    main_fast() {
        banner
        install_all_configs
        ok "Fast update complete!"
    }
    main_fast
    exit 0
fi

main "$@"
