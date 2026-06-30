#!/usr/bin/env bash
# Launch the first available command from the provided list.
# Usage: launch_first_available.sh 'cmd1 --args' 'cmd2' ...
for cmd in "$@"; do
    [[ -z "$cmd" ]] && continue
    eval "command -v ${cmd%% *}" >/dev/null 2>&1 || continue
    eval "$cmd" &
    exit 0
done
echo "launch_first_available: no suitable command found in: $*" >&2
exit 1
