#!/bin/bash
GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
echo "{\"text\": \"$GPU_UTIL%\", \"tooltip\": \"GPU Utilization: $GPU_UTIL%\"}"