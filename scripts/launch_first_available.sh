#!/usr/bin/env bash

# launch_first_available.sh
# Iterates through a list of commands and launches the first one that exists.

for cmd in "$@"; do
    [[ -z "$cmd" ]] && continue
    # Extract the command name (first word) to check if it exists
    cmd_name=$(echo "$cmd" | awk '{print $1}')
    if command -v "$cmd_name" >/dev/null 2>&1; then
        eval "$cmd" &
        exit 0
    fi
done

echo "Error: None of the specified commands were found: $*"
exit 1
