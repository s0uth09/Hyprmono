#!/usr/bin/env bash
set -euo pipefail
DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY=false; [[ "${1:-}" == "--dry-run" ]] && DRY=true

# ── colours ──────────────────────────────────────────────────────────
R='\e[0m'; BOLD='\e[1m'; DIM='\e[2m'
FG='\e[38;5;253m'; ACC='\e[38;5;251m'; HI='\e[38;5;255m'
DFG='\e[38;5;241m'
GRN='\e[38;5;114m'; YEL='\e[38;5;222m'
RED='\e[38;5;203m'; CYN='\e[38;5;116m'

W=$(tput cols 2>/dev/null || echo 72)
hr()    { printf "${DFG}"; printf '─%.0s' $(seq 1 "$W"); printf "${R}\n"; }
ctr() {
    local s="$*"
    local len=${#s}
    local p=0

    if (( len < W )); then
        p=$(( (W - len) / 2 ))
    fi

    printf "%*s%b\n" "$p" "" "$s"
}
ok()    { echo -e "  ${GRN}✓${R}  $*"; }
info()  { echo -e "  ${CYN}·${R}  $*"; }
warn()  { echo -e "  ${YEL}⚠${R}  $*"; }
err()   { echo -e "  ${RED}✗${R}  $*"; }
title() { echo; echo -e "  ${BOLD}${ACC}$*${R}"; hr; }
dryp()  { $DRY && echo -e "  ${DIM}[dry]  $*${R}"; }

ask() {
    local p="$1" d="${2:-y}" yn="[Y/n]"
    [[ "$d" == n ]] && yn="[y/N]"
    echo -en "  ${HI}?${R}  $p ${DIM}$yn${R}  " >&2
    read -r a; a="${a:-$d}"; [[ "${a,,}" == y* ]]
}

cmd_ok() { command -v "$1" &>/dev/null; }

# Symlink src → dst, backing up any existing non-symlink file
safe_link() {
    local src="$1" dst="$2"
    if $DRY; then dryp "ln -sf  $(basename "$src")  →  $dst"; return; fi
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mv "$dst" "${dst}.bak.$(date +%s)"
        warn "backed up  $(basename "$dst")"
    fi
    ln -sf "$src" "$dst" && ok "$(basename "$dst")"
}

# Copy only if target doesn't already exist (for user-owned files like wallpaper)
safe_copy_once() {
    local src="$1" dst="$2"
    if $DRY; then dryp "cp (once)  $src  →  $dst"; return; fi
    if [[ -e "$dst" ]]; then info "kept existing  $dst"; return; fi
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst" && ok "$(basename "$dst")"
}

mark_x() { $DRY || chmod +x "$@" 2>/dev/null || true; }

# ── banner ────────────────────────────────────────────────────────────
clear; echo -e "${FG}"
ctr "${BOLD}${HI}╔══════════════════════════════════════╗"
ctr "${BOLD}${HI}║          H Y P R   M O N O           ║"
ctr "${BOLD}${HI}╚══════════════════════════════════════╝ ${R}"; echo
$DRY && { ctr "${YEL}${BOLD}⚡  DRY-RUN — nothing will be written  ⚡${R}"; echo; }
hr

# ── dependency check ──────────────────────────────────────────────────
title "Checking dependencies"
REQUIRED=(hyprland hyprpaper hypridle hyprlock kitty wofi)
OPTIONAL=(rofi fuzzel nm-applet playerctl brightnessctl wpctl fc-cache)
MISSING=()

for d in "${REQUIRED[@]}"; do
    cmd_ok "$d" && ok "${BOLD}$d${R}" || { err "${BOLD}$d${R}  ${DIM}(required)${R}"; MISSING+=("$d"); }
done
echo
for d in "${OPTIONAL[@]}"; do
    cmd_ok "$d" && ok "${DIM}$d  (optional)${R}" \
                || warn "${DIM}$d  (optional)${R}"
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    echo; warn "Missing required: ${MISSING[*]}"
    if cmd_ok pacman && ask "Install missing via pacman?" n; then
        $DRY || sudo pacman -S --needed "${MISSING[@]}"
    else
        ask "Continue without them?" n || { echo; exit 1; }
    fi
fi

# ── component selector ────────────────────────────────────────────────
title "Select components"
declare -A INST
declare -a MENU=(
    "hyprland"   "Core config — binds, rules, animations, env…"
    "hyprlock"   "Lock screen + idle daemon"
    "hyprpaper"  "Wallpaper daemon config + default wallpaper"
    "wofi"       "App launcher (wofi)"
    "rofi"       "App launcher (rofi)"
    "kitty"      "Terminal emulator"
    "fuzzel"     "Fuzzel launcher + emoji picker"
    "fonts"      "Fontconfig rules"
    "xdg"        "XDG desktop portal"
    "scripts"    "Helper scripts → ~/.local/bin"
)

for (( i=0; i<${#MENU[@]}; i+=2 )); do
    k="${MENU[$i]}" d="${MENU[$i+1]}"
    if ask "Install ${BOLD}$k${R}  ${DIM}($d)${R}?" y; then
        INST[$k]=1; info "${ACC}$k${R} queued"
    else
        INST[$k]=0; warn "$k skipped"
    fi
done

QUEUE=()
for k in "${!INST[@]}"; do [[ "${INST[$k]}" == 1 ]] && QUEUE+=("$k"); done
IFS=$'\n' QUEUE=($(sort <<<"${QUEUE[*]}")); unset IFS

echo; hr
echo -e "\n  ${BOLD}Will install:${R}  ${ACC}${QUEUE[*]}${R}\n"
ask "Proceed?" y || { echo; exit 1; }

# ── install functions ─────────────────────────────────────────────────
# All source paths use $DOTS/config/* which mirrors ~/.config/* exactly.
C="$HOME/.config"   # target root
S="$DOTS/config"    # source root

do_hyprland() {
    title "Hyprland"
    # Entry point
    safe_link "$S/hypr/hyprland.lua" "$C/hypr/hyprland.lua"
    # Modules
    for f in "$S/hypr/hyprland/"*.lua; do
        safe_link "$f" "$C/hypr/hyprland/$(basename "$f")"
    done
    # Lib + services (hyprland.lua requires these)
    safe_link "$S/hypr/lib/init.lua"               "$C/hypr/lib/init.lua"
    safe_link "$S/hypr/services/init.lua"          "$C/hypr/services/init.lua"
    safe_link "$S/hypr/services/custom_config.lua" "$C/hypr/services/custom_config.lua"
    # User custom stubs — created once, never overwritten
    local cu="$C/hypr/custom"
    for stub in env execs general keybinds rules variables; do
        local f="$cu/${stub}.lua"
if [[ ! -f "$f" ]]; then
   $DRY || {
       mkdir -p "$cu"
       echo "-- ${stub}.lua - personal overrides (never overwritten)" > "$f"
   }
   ok "stub  $f"
else
    info "kept  $cu/${stub}.lua"
fi
done 
}
do_hyprlock() {
    title "Hyprlock + Hypridle"
    for f in "$S/hypr/hyprlock/"*; do
        safe_link "$f" "$C/hypr/hyprlock/$(basename "$f")"
    done
    mark_x "$C/hypr/hyprlock/status.sh" "$C/hypr/hyprlock/caps-lock-check.sh"
    ok "scripts marked executable"
    # Symlink to where the daemons look by default
    safe_link "$C/hypr/hyprlock/hyprlock.conf" "$C/hypr/hyprlock.conf"
    safe_link "$C/hypr/hyprlock/hypridle.conf" "$C/hypr/hypridle.conf"
}

do_hyprpaper() {
    title "Hyprpaper"
    safe_link "$S/hypr/hyprpaper/hyprpaper.conf" "$C/hypr/hyprpaper/hyprpaper.conf"
    safe_copy_once "$S/hypr/hyprpaper/wallpaper.jpg" "$C/hypr/hyprpaper/wallpaper.jpg"
}
    # ── 2. System packages ─────────────────────────────────────────
    if cmd_ok pacman; then
        local PACMAN_DEPS=(
            pipewire playerctl dart-sass power-profiles-daemon networkmanager
            brightnessctl pkgconf wf-recorder kitty python pacman-contrib
            gtk3 cairo gtk-layer-shell libgirepository noto-fonts-emoji
            gobject-introspection gobject-introspection-runtime python-pip
            libnotify cliphist satty nvtop
        fi
        )
        local MISSING_PKG=()
        for p in "${PACMAN_DEPS[@]}"; do
            pacman -Q "$p" &>/dev/null || MISSING_PKG+=("$p")
        done
        if [[ ${#MISSING_PKG[@]} -gt 0 ]]; then
            warn "Missing pacman packages: ${MISSING_PKG[*]}"
            if ask "Install them via pacman?" y; then
                $DRY || sudo pacman -S --needed "${MISSING_PKG[@]}"
            fi
        else
            ok "Pacman dependencies satisfied"
        fi

do_wofi() {
    title "Wofi"
    safe_link "$S/wofi/config"    "$C/wofi/config"
    safe_link "$S/wofi/style.css" "$C/wofi/style.css"
    safe_link "$S/wofi/colours"   "$C/wofi/colours"
}

do_rofi() {
    title "Rofi"
    safe_link "$S/rofi/config.rasi" "$C/rofi/config.rasi"
}

do_kitty() {
    title "Kitty"
    safe_link "$S/kitty/kitty.conf"          "$C/kitty/kitty.conf"
    safe_link "$S/kitty/kitty-colours.conf"  "$C/kitty/kitty-colours.conf"
}

do_fuzzel() {
    title "Fuzzel"
    safe_link "$S/fuzzel/fuzzel.ini"       "$C/fuzzel/fuzzel.ini"
    safe_link "$S/fuzzel/fuzzel-theme.ini" "$C/fuzzel/fuzzel-theme.ini"
    mkdir -p "$HOME/.local/bin"
    safe_link "$DOTS/scripts/fuzzel-emojis.sh" "$HOME/.local/bin/fuzzel-emojis"
    mark_x "$HOME/.local/bin/fuzzel-emojis"
}

do_fonts() {
    title "Fontconfig"
    safe_link "$S/fontconfig/fonts.conf" "$C/fontconfig/fonts.conf"
    if cmd_ok fc-cache; then
        $DRY || fc-cache -f && ok "font cache rebuilt"
    else warn "fc-cache not found — run manually"; fi
}

do_xdg() {
    title "XDG desktop portal"
    safe_link "$S/xdg-desktop-portal/hyprland-portals.conf" \
              "$C/xdg-desktop-portal/hyprland-portals.conf"
    if [[ -f "$S/kde-material-you-colors/config.conf" ]] && cmd_ok kde-material-you-colors; then
        safe_link "$S/kde-material-you-colors/config.conf" \
                  "$C/kde-material-you-colors/config.conf"
    fi
}

do_scripts() {
    title "Scripts"
    mkdir -p "$HOME/.local/bin"
    safe_link "$DOTS/scripts/launch_first_available.sh" \
              "$HOME/.local/bin/launch_first_available.sh"
    mark_x "$HOME/.local/bin/launch_first_available.sh"
}

# ── run ───────────────────────────────────────────────────────────────
DONE=0; TOTAL=${#QUEUE[@]}
for c in "${QUEUE[@]}"; do
    case "$c" in
        hyprland)  do_hyprland  ;;
        hyprlock)  do_hyprlock  ;;
        hyprpaper) do_hyprpaper ;;
        tsumiki)   do_tsumiki   ;;
        wofi)      do_wofi      ;;
        rofi)      do_rofi      ;;
        kitty)     do_kitty     ;;
        fuzzel)    do_fuzzel    ;;
        fonts)     do_fonts     ;;
        xdg)       do_xdg       ;;
        scripts)   do_scripts   ;;
    esac
    DONE=$(( DONE + 1 ))
    F=$(( DONE * 28 / TOTAL )); E=$(( 28 - F ))
    BAR=""; for (( x=0;x<F;x++ )); do BAR+="█"; done
               for (( x=0;x<E;x++ )); do BAR+="░"; done
    echo -e "  ${ACC}[${HI}${BAR}${ACC}]${R}  ${DIM}$DONE/$TOTAL${R}  ${GRN}$c${R}"
done

# ── done ──────────────────────────────────────────────────────────────
hr; echo
ctr "${BOLD}${GRN}✦  Done  ✦${R}"; echo
echo -e "  ${ACC}→${R}  Log out and back into Hyprland to apply"
echo -e "  ${ACC}→${R}  Personal overrides:  ${BOLD}~/.config/hypr/custom/*.lua${R}"
echo -e "  ${ACC}→${R}  Wallpaper:           ${BOLD}~/.config/hypr/hyprpaper/wallpaper.jpg${R}"
echo -e "  ${ACC}→${R}  Restart Tsumiki:     ${BOLD}pkill tsumiki; ~/.config/tsumiki/init.sh -start${R}"
echo -e "  ${ACC}→${R}  Existing files saved as  ${BOLD}*.bak.<timestamp>${R}"
echo