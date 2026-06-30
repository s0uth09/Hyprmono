#!/usr/bin/env bash
set -euo pipefail

if ! command -v hyprctl >/dev/null 2>&1; then
    echo ""
    exit 0
fi

main_kb_caps=$(hyprctl devices 2>/dev/null | awk '/main: yes/ { main=1; next } main && /capsLock/ { print $2; exit }' || true)

if [[ "$main_kb_caps" == "yes" ]]; then
    echo "Caps Lock active"
else
    echo ""
fi
