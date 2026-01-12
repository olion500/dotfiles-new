#!/bin/bash
# Setup AstroNvim

set -e

NVIM_CONFIG="$HOME/.config/nvim"

# Check if AstroNvim is already installed
if [ -f "$NVIM_CONFIG/lua/astronvim/init.lua" ] || [ -f "$NVIM_CONFIG/.astronvim" ]; then
    echo "AstroNvim is already installed, skipping..."
    exit 0
fi

# Backup existing config if it exists and is not empty
if [ -d "$NVIM_CONFIG" ] && [ "$(ls -A $NVIM_CONFIG 2>/dev/null)" ]; then
    echo "Backing up existing nvim config..."
    mv "$NVIM_CONFIG" "$NVIM_CONFIG.backup.$(date +%Y%m%d%H%M%S)"
fi

# Clone AstroNvim template
echo "Installing AstroNvim..."
git clone --depth 1 https://github.com/AstroNvim/template "$NVIM_CONFIG"
rm -rf "$NVIM_CONFIG/.git"

# Create marker file to indicate AstroNvim is installed
touch "$NVIM_CONFIG/.astronvim"

echo "AstroNvim installed successfully!"
echo "Run 'nvim' to complete the setup and install plugins."
