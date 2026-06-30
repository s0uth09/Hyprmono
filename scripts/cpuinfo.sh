#!/usr/bin/env bash
# Minimal CPU info script for Waybar
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
printf '{"text": "%.0f", "percentage": %.0f}\n' "$cpu_usage" "$cpu_usage"
