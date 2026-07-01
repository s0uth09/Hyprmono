#!/usr/bin/env bash
# keybinds_hint.sh — display a keybind cheatsheet in a wofi/fuzzel popup

BINDS=$(cat <<'EOF'
  ──────────────────── Apps ────────────────────
  SUPER + Return          Terminal
  SUPER + E               File Manager
  SUPER + B               Browser
  SUPER + R               App Launcher (wofi)
  SUPER + M               Exit / Shutdown

  ─────────────────── Windows ──────────────────
  ALT + F4                Close window
  SUPER + V               Toggle float
  SUPER + P               Toggle pseudo
  SUPER + J               Toggle split

  ──────────────────── Focus ───────────────────
  SUPER + ←               Focus left
  SUPER + →               Focus right
  SUPER + ↑               Focus up
  SUPER + ↓               Focus down

  ────────────────── Workspaces ────────────────
  SUPER + [1-9, 0]        Switch to workspace
  SUPER + SHIFT + [1-9,0] Move window to workspace

  ──────────────── Special Workspace ───────────
  SUPER + S               Toggle special (magic)
  SUPER + SHIFT + S       Move to special (magic)

  ──────────────────── Mouse ───────────────────
  SUPER + Scroll Down     Workspace forward
  SUPER + Scroll Up       Workspace back
  SUPER + LMB             Drag window
  SUPER + RMB             Resize window

  ──────────────────── Media ───────────────────
  XF86AudioRaiseVolume    Volume +5%
  XF86AudioLowerVolume    Volume -5%
  XF86AudioMute           Mute toggle
  XF86AudioMicMute        Mic mute toggle
  XF86MonBrightnessUp     Brightness +5%
  XF86MonBrightnessDown   Brightness -5%
  XF86AudioNext           Next track
  XF86AudioPrev           Previous track
  XF86AudioPlay/Pause     Play / Pause
EOF
)

if command -v wofi &>/dev/null; then
    echo "$BINDS" | wofi \
        --dmenu \
        --prompt "Keybinds" \
        --width 560 \
        --height 620 \
        --cache-file /dev/null \
        --no-actions \
        --define=matching=fuzzy
elif command -v fuzzel &>/dev/null; then
    echo "$BINDS" | fuzzel \
        --dmenu \
        --prompt "Keybinds > " \
        --width 60 \
        --lines 28
else
    notify-send "keybinds_hint" "Neither wofi nor fuzzel found."
fi