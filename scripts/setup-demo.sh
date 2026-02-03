#!/bin/bash
# setup-demo.sh - HOLFY27-8805 Example Custom Script
# Version 1.0 - January 2026
# Author - Burke Azbill and HOL Core Team
# This script can be called from lsfunctions using run_repo_script()

echo "=== HOLFY27-8805 Demo Setup Script ==="
echo "Timestamp: $(date)"
echo ""

# Example: Configure a demo application
echo "Configuring demo application..."

# Access lab configuration
CONFIG_INI="/tmp/config.ini"
if [ -f "$CONFIG_INI" ]; then
    LAB_SKU=$(grep vPod_SKU "$CONFIG_INI" | cut -f2 -d= | xargs)
    echo "Lab SKU: $LAB_SKU"
fi

# Example: Set up demo files
DEMO_DIR="/home/holuser/demo"
mkdir -p "$DEMO_DIR"

cat > "$DEMO_DIR/welcome.txt" <<EOF
Welcome to $LAB_SKU!

This is a VCF Single Site demonstration lab.

Getting Started:
1. Open Firefox and navigate to the vCenter
2. Login with administrator@vsphere.local
3. Explore the VCF environment

For assistance, see the README on your desktop.
EOF

echo "Demo setup complete!"
echo "Created: $DEMO_DIR/welcome.txt"
