#!/usr/bin/env bash
# Minimal GPU info script for Waybar (generic fallback)
if command -v nvidia-smi &> /dev/null; then
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}')
<<<<<<< HEAD
elif [[ -r /sys/class/drm/card0/device/gpu_busy_percent ]]; then
    gpu_usage=$(< /sys/class/drm/card0/device/gpu_busy_percent)
=======
elif [ -d /sys/class/drm/card0/device/gpu_busy_percent ]; then
    gpu_usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent)
>>>>>>> 97fdd80dc8c22ddfef81c0be6df0d5570bf819e8
else
    gpu_usage=0
fi
printf '{"text": "%.0f", "percentage": %.0f}\n' "$gpu_usage" "$gpu_usage"
