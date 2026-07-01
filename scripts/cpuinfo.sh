#!/usr/bin/env bash
# Minimal CPU info script for Waybar
set -euo pipefail

cpu_usage=$(awk 'NR==1 { idle=$5; total=0; for (i=2; i<=NF; i++) total += $i; if (total > 0) printf "%.0f", 100 * (total - idle) / total; else print 0 }' /proc/stat 2>/dev/null || printf 0)
printf '{"text": "%s", "percentage": %s}\n' "$cpu_usage" "$cpu_usage"
