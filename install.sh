#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_VERSION="2.0"
readonly PROJECT="HyprMono"

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOGFILE="$DOTS/install.log"

DRY_RUN=false

###############################################################################
# Colours
###############################################################################

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

###############################################################################
# Logging
###############################################################################

log() {
    printf "[%s] %s\n" \
        "$(date '+%H:%M:%S')" \
        "$*" >> "$LOGFILE"
}

###############################################################################
# Printing
###############################################################################

line() {
    printf "${GRAY}"
    printf '─%.0s' $(seq 1 "$WIDTH")
    printf "${RESET}\n"
}

title() {
    echo
    echo -e "${BOLD}${LIGHT}$*${RESET}"
    line
}

ok() {
    echo -e "${GREEN}✓${RESET} $*"
    log "[ OK ] $*"
}

warn() {
    echo -e "${YELLOW}!${RESET} $*"
    log "[WARN] $*"
}

err() {
    echo -e "${RED}✗${RESET} $*"
    log "[FAIL] $*"
}

info() {
    echo -e "${CYAN}>${RESET} $*"
    log "[INFO] $*"
}

# FIX (Bug 2): removed duplicate log()/error() definitions that appeared later
# in the file and silently overwrote the real implementations above.

###############################################################################
# Banner
###############################################################################

banner() {
    clear
    echo -e "$LIGHT"
    cat <<'EOF'

██╗  ██╗██╗   ██╗██████╗ ██████╗ ███╗   ███╗ ██████╗ ███╗   ██╗ ██████╗
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗████╗ ████║██╔═══██╗████╗  ██║██╔═══██╗
███████║ ╚████╔╝ ██████╔╝██████╔╝██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║
██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║
██║  ██║   ██║   ██║     ██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║╚██████╔╝
╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝

EOF
    echo -e "${GRAY}Installer v${SCRIPT_VERSION}${RESET}"
    [[ "$DRY_RUN" == true ]] && echo -e "${YELLOW}DRY RUN ENABLED${RESET}"
    line
}

###############################################################################
# Cleanup
###############################################################################

cleanup() {
    tput sgr0
}

trap cleanup EXIT

###############################################################################
# Error handler
###############################################################################

on_error() {
    err "Installation failed."
    err "Line: $1"
    exit 1
}

trap 'on_error $LINENO' ERR

###############################################################################
# Command Exists
###############################################################################

has() {
    command -v "$1" >/dev/null 2>&1
}

###############################################################################
# Ask
###############################################################################

ask() {
    local prompt="$1"
    local default="${2:-y}"
    local answer

    if [[ "$default" == "y" ]]; then
        printf "%b?%b %s [Y/n]: " "$CYAN" "$RESET" "$prompt"
    else
        printf "%b?%b %s [y/N]: " "$CYAN" "$RESET" "$prompt"
    fi

    read -r answer
    answer="${answer:-$default}"
    [[ "${answer,,}" =~ ^y ]]
}

###############################################################################
# Dry Run
###############################################################################

run() {
    if $DRY_RUN; then
        info "[dry-run] $*"
    else
        "$@"
    fi
}

###############################################################################
# Backup
###############################################################################

backup() {
    local target="$1"
    [[ -e "$target" ]] || return
    [[ -L "$target" ]] && return

    local backup
    backup="${target}.bak.$(date +%s)"
    mv "$target" "$backup"
    ok "Backup created"
}

###############################################################################
# Symlink
###############################################################################

link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"
    backup "$dst"
    run ln -sf "$src" "$dst"
    ok "$(basename "$dst")"
}

###############################################################################
# Copy Once
###############################################################################

copy_once() {
    local src="$1"
    local dst="$2"

    [[ -f "$src" ]] || {
        warn "Missing $(basename "$src")"
        return
    }

    if [[ -f "$dst" ]]; then
        info "Keeping existing $(basename "$dst")"
        return
    fi

    mkdir -p "$(dirname "$dst")"
    run cp "$src" "$dst"
}

###############################################################################
# Repository Validation
###############################################################################

validate_repo() {
    title "Validating repository"

    local required=("config" "scripts")
    local missing=()

    for dir in "${required[@]}"; do
        [[ ! -d "$DOTS/$dir" ]] && missing+=("$dir")
    done

    if (( ${#missing[@]} > 0 )); then
        err "Repository structure is invalid."
        printf "Missing:\n"
        for m in "${missing[@]}"; do
            printf "  • %s\n" "$m"
        done
        exit 1
    fi

    ok "Repository structure verified"
}

###############################################################################
# Package Manager Detection
###############################################################################

PKG_MANAGER=""
AUR_HELPER=""

detect_package_manager() {
    title "Detecting package manager"

    if has pacman; then
        PKG_MANAGER="pacman"
        ok "Detected pacman"
    else
        err "Unsupported distribution."
        exit 1
    fi

    for helper in yay paru; do
        if has "$helper"; then
            AUR_HELPER="$helper"
            ok "Detected AUR helper: $helper"
            break
        fi
    done

    [[ -z "$AUR_HELPER" ]] && warn "No AUR helper detected."
}

###############################################################################
# Dependencies
###############################################################################

PACMAN_PACKAGES=(
    hyprland
    hyprpaper
    hypridle
    hyprlock

    kitty
    wofi
    rofi
    fuzzel

    pipewire
    wireplumber
    networkmanager

    brightnessctl
    playerctl
    cliphist
    wl-clipboard

    grim
    slurp
    swappy

    jq
    imagemagick

    noto-fonts
    noto-fonts-emoji

    ttf-jetbrains-mono-nerd

    xdg-desktop-portal-hyprland
)

AUR_PACKAGES=(
    satty
)

###############################################################################
# Install Packages
###############################################################################

install_packages() {
    title "Checking dependencies"

    local missing=()

    for pkg in "${PACMAN_PACKAGES[@]}"; do
        pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
    done

    if (( ${#missing[@]} == 0 )); then
        ok "All pacman packages already installed"
    else
        warn "Missing packages:"
        printf "  %s\n" "${missing[@]}"
        if ask "Install them now?" y; then
            run sudo pacman -S --needed "${missing[@]}"
        fi
    fi

    if [[ -n "$AUR_HELPER" ]]; then
        local aur_missing=()

        for pkg in "${AUR_PACKAGES[@]}"; do
            pacman -Q "$pkg" &>/dev/null || aur_missing+=("$pkg")
        done

        if (( ${#aur_missing[@]} > 0 )); then
            warn "Missing AUR packages:"
            printf "  %s\n" "${aur_missing[@]}"
            if ask "Install AUR packages?" y; then
                run "$AUR_HELPER" -S --needed "${aur_missing[@]}"
            fi
        fi
    fi
}

###############################################################################
# Component Menu
###############################################################################

# FIX (Bug 7): use a single consistent associative array for COMPONENTS;
# install_loop previously redeclared it as an indexed array, clobbering it.
declare -A COMPONENTS

MENU=(
    hyprland  "Core Hyprland configuration"
    hyprlock  "Lock screen"
    hyprpaper "Wallpaper"
    kitty     "Kitty terminal"
    wofi      "Application launcher"
    rofi      "Alternative launcher"
    fuzzel    "Launcher + emoji picker"
    fonts     "Font configuration"
    xdg       "XDG portals"
    scripts   "Utility scripts"
)

###############################################################################
# Component Selection
###############################################################################

select_components() {
    title "Component selection"

    for ((i=0; i<${#MENU[@]}; i+=2)); do
        local key="${MENU[$i]}"
        local desc="${MENU[$((i+1))]}"

        if ask "$key — $desc" y; then
            COMPONENTS["$key"]=1
            ok "$key selected"
        else
            COMPONENTS["$key"]=0
            info "$key skipped"
        fi
    done
}

###############################################################################
# Build Queue
###############################################################################

QUEUE=()

build_queue() {
    QUEUE=()

    for component in "${!COMPONENTS[@]}"; do
        [[ "${COMPONENTS[$component]}" == 1 ]] && QUEUE+=("$component")
    done

    if (( ${#QUEUE[@]} == 0 )); then
        err "Nothing selected."
        exit 1
    fi
}

###############################################################################
# Progress Bar
###############################################################################

CURRENT_STEP=0
TOTAL_STEPS=1

progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))

    local width=30
    local filled=$((CURRENT_STEP * width / TOTAL_STEPS))
    local empty=$((width - filled))

    printf "\n["
    for ((i=0; i<filled; i++)); do printf "█"; done
    for ((i=0; i<empty;  i++)); do printf "░"; done
    printf "] %d/%d\n\n" "$CURRENT_STEP" "$TOTAL_STEPS"
}

###############################################################################
# Component installers
# FIX (Bug 8): all sudo pacman calls now go through run() so dry-run is respected.
###############################################################################

install_hyprland() {
    log "Installing Hyprland..."

    if has hyprctl; then
        log "Hyprland already installed"
        return 0
    fi

    run sudo pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland polkit-kde-agent

    mkdir -p ~/.config/hypr

    cat > ~/.config/hypr/hyprland.conf <<EOF
# Basic Hyprland config
monitor=,preferred,auto,1
exec-once = waybar &
exec-once = nm-applet &
exec-once = polkit-kde-authentication-agent-1

input {
    kb_layout = pl
    follow_mouse = 1
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
}
EOF
    log "Hyprland installed"
}

install_hyprlock() {
    log "Installing Hyprlock..."

    run sudo pacman -S --noconfirm hyprlock

    mkdir -p ~/.config/hypr

    cat > ~/.config/hypr/hyprlock.conf <<EOF
general {
    disable_loading_bar = false
}

background {
    blur_passes = 3
}

input-field {
    size = 200, 50
    position = 0, -80
}
EOF
    log "Hyprlock configured"
}

install_hyprpaper() {
    log "Installing Hyprpaper..."

    run sudo pacman -S --noconfirm hyprpaper

    mkdir -p ~/.config/hypr
    mkdir -p ~/wallpapers

    cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = ~/wallpapers/default.jpg
wallpaper = ,~/wallpapers/default.jpg
EOF
    log "Hyprpaper installed"
}

install_kitty() {
    log "Installing Kitty terminal..."

    run sudo pacman -S --noconfirm kitty

    mkdir -p ~/.config/kitty

    cat > ~/.config/kitty/kitty.conf <<EOF
font_family FiraCode Nerd Font
font_size 12
background_opacity 0.9
enable_audio_bell no
EOF
    log "Kitty installed"
}

install_wofi() {
    log "Installing Wofi..."

    run sudo pacman -S --noconfirm wofi

    mkdir -p ~/.config/wofi

    cat > ~/.config/wofi/config <<EOF
show=drun
prompt=Search...
width=600
height=400
EOF
    log "Wofi installed"
}

install_rofi() {
    log "Installing Rofi..."

    run sudo pacman -S --noconfirm rofi

    mkdir -p ~/.config/rofi

    cat > ~/.config/rofi/config.rasi <<EOF
configuration {
    modi: "drun,run";
    show-icons: true;
}
EOF
    log "Rofi installed"
}

install_fuzzel() {
    log "Installing Fuzzel..."

    run sudo pacman -S --noconfirm fuzzel

    mkdir -p ~/.config/fuzzel

    cat > ~/.config/fuzzel/fuzzel.ini <<EOF
[main]
font=FiraCode:size=12
width=40
EOF
    log "Fuzzel installed"
}

install_fonts() {
    log "Installing fonts..."

    run sudo pacman -S --noconfirm \
        ttf-firacode-nerd \
        ttf-jetbrains-mono-nerd \
        noto-fonts \
        noto-fonts-emoji

    log "Fonts installed"
}

install_xdg() {
    log "Configuring XDG user dirs..."

    run sudo pacman -S --noconfirm xdg-user-dirs
    run xdg-user-dirs-update

    log "XDG configured"
}

install_scripts() {
    log "Installing helper scripts..."

    mkdir -p ~/.local/bin

    cat > ~/.local/bin/lock.sh <<EOF
#!/bin/bash
hyprlock
EOF
    chmod +x ~/.local/bin/lock.sh

    cat > ~/.local/bin/reload-hypr.sh <<EOF
#!/bin/bash
hyprctl reload
EOF
    chmod +x ~/.local/bin/reload-hypr.sh

    log "Scripts installed"
}

install_component() {
    case "$1" in
        hyprland)  install_hyprland  ;;
        hyprlock)  install_hyprlock  ;;
        hyprpaper) install_hyprpaper ;;
        kitty)     install_kitty     ;;
        wofi)      install_wofi      ;;
        rofi)      install_rofi      ;;
        fuzzel)    install_fuzzel    ;;
        fonts)     install_fonts     ;;
        xdg)       install_xdg       ;;
        scripts)   install_scripts   ;;
        all)
            install_hyprland; install_hyprlock; install_hyprpaper
            install_kitty; install_wofi; install_rofi; install_fuzzel
            install_fonts; install_xdg; install_scripts
            ;;
        *)
            err "Unknown component: $1"
            exit 1
            ;;
    esac
}

###############################################################################
# Install Loop
# FIX (Bug 4): now respects the QUEUE built from user selections instead of
# unconditionally installing every component.
###############################################################################

install_loop() {
    for c in "${QUEUE[@]}"; do
        log "Installing $c..."
        install_component "$c"
        progress   # FIX (Bug 5): progress() was defined but never called
    done
    log "All components installed successfully"
}

###############################################################################
# System Check
###############################################################################

check_system() {
    log "Running system checks..."

    if ! has pacman; then
        err "This installer is designed for Arch-based systems only."
        exit 1
    fi

    if [[ $EUID -eq 0 ]]; then
        err "Do NOT run this script as root."
        exit 1
    fi

    sudo -v || {
        err "Sudo authentication failed"
        exit 1
    }

    log "System checks passed"
}

###############################################################################
# Backup Configs
###############################################################################

backup_configs() {
    log "Backing up existing configs..."

    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    local targets=(hypr kitty wofi rofi fuzzel)

    for t in "${targets[@]}"; do
        if [[ -d "$HOME/.config/$t" ]]; then
            cp -r "$HOME/.config/$t" "$backup_dir/"
            log "Backed up $t"
        fi
    done

    log "Backup stored in $backup_dir"
}

###############################################################################
# Final Message
###############################################################################

final_message() {
    echo ""
    echo "======================================="
    echo "  INSTALLATION FINISHED SUCCESSFULLY   "
    echo "======================================="
    echo ""
    echo "Next steps:"
    echo "  1. Reboot system"
    echo "  2. Select Hyprland session"
    echo "  3. Run hyprctl reload if needed"
    echo ""
}

###############################################################################
# Main
###############################################################################

main() {
    check_system
    backup_configs
    validate_repo
    detect_package_manager
    install_packages
    select_components
    build_queue

    TOTAL_STEPS=${#QUEUE[@]}

    title "Ready to install"
    printf "\nSelected components:\n\n"
    for item in "${QUEUE[@]}"; do
        printf "  • %s\n" "$item"
    done
    echo

    ask "Continue installation?" y || exit 0

    log "Starting installation..."
    install_loop
    log "Installation complete!"

    # FIX (Bug 6): final_message now only prints after a real install, not after
    # --list or --help.
    final_message
}

###############################################################################
# Argument Parsing
# FIX (Bug 1): all top-level calls removed; entry point is parse_args only.
# FIX (Bug 3): --dry-run is stripped before the remaining args are dispatched.
###############################################################################

parse_args() {
    # Consume --dry-run early so it doesn't reach the case statement.
    if [[ "${1:-}" == "--dry-run" ]]; then
        DRY_RUN=true
        shift
    fi

    banner

    if [[ $# -eq 0 ]]; then
        main
        return
    fi

    case "$1" in
        --all)
            main
            ;;
        --component)
            if [[ -z "${2:-}" ]]; then
                err "Missing component name"
                exit 1
            fi
            check_system
            install_component "$2"
            final_message
            ;;
        --list)
            echo "Available components:"
            echo "  hyprland  hyprlock  hyprpaper  kitty"
            echo "  wofi      rofi      fuzzel     fonts"
            echo "  xdg       scripts"
            ;;
        --help)
            echo "Usage:"
            echo "  ./install.sh                        # interactive full install"
            echo "  ./install.sh --all                  # full install, no prompts"
            echo "  ./install.sh --component <name>     # install one component"
            echo "  ./install.sh --list                 # list available components"
            echo "  ./install.sh --dry-run [flags]      # simulate without changes"
            ;;
        *)
            err "Unknown flag: $1"
            exit 1
            ;;
    esac
}

parse_args "$@"