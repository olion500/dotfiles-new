#!/bin/bash
# Install packages via Homebrew using Brewfile

set -e

# Ensure brew is in PATH (chezmoi runs scripts in separate processes)
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Verify brew is available
if ! command -v brew &> /dev/null; then
    echo "Error: brew not found in PATH"
    exit 1
fi

BREWFILE="$HOME/.Brewfile"

# Check if Brewfile exists
if [[ ! -f "$BREWFILE" ]]; then
    echo "Warning: $BREWFILE not found, skipping package installation"
    exit 0
fi

echo ""
echo "==> Installing Homebrew packages..."

# Count total packages
TOTAL=$(grep -cE '^brew|^cask' "$BREWFILE" 2>/dev/null || echo "0")
echo "    Packages in Brewfile: $TOTAL"
echo ""

# Install packages
brew bundle --global

echo ""
echo "==> Package installation complete!"
echo ""
