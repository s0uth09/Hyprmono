#!/usr/bin/env bash
# Launch the first available command from the provided list.
# Usage: launch_first_available.sh 'cmd1 --args' 'cmd2' ...
set -euo pipefail

if (( $# == 0 )); then
    set -- 'foot' 'kitty -1' 'alacritty' 'wezterm' 'konsole' 'kgx' 'uxterm' 'xterm'
fi

for cmd in "$@"; do
    [[ -n "$cmd" ]] || continue

    binary=${cmd%%[[:space:]]*}
    if command -v "$binary" >/dev/null 2>&1; then
        bash -lc "$cmd" &
        exit 0
    fi
done

printf 'launch_first_available: no suitable command found in: %s\n' "$*" >&2
exit 1
