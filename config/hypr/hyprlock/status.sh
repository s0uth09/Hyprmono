#!/usr/bin/env bash
set -euo pipefail

battery_dir=""
for candidate in /sys/class/power_supply/*BAT*; do
  if [[ -r "$candidate/status" && -r "$candidate/capacity" ]]; then
    battery_dir="$candidate"
    break
  fi
done

if [[ -n "$battery_dir" ]]; then
  status=$(< "$battery_dir/status")
  capacity=$(< "$battery_dir/capacity")

  if [[ "$status" == "Charging" ]]; then
    printf '(+) '
  fi

  printf '%s%%' "$capacity"

  if [[ "$status" != "Charging" ]]; then
    printf ' remaining'
  fi
fi

printf '\n'
