#!/usr/bin/env bash
# Minimal GPU info script for Waybar (generic fallback)
if command -v nvidia-smi &> /dev/null; then
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}')
elif [[ -r /sys/class/drm/card0/device/gpu_busy_percent ]]; then
    gpu_usage=$(< /sys/class/drm/card0/device/gpu_busy_percent)
else
    gpu_usage=0
fi
printf '{"text": "%.0f", "percentage": %.0f}\n' "$gpu_usage" "$gpu_usage"
