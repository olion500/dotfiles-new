#!/bin/bash
# Install packages via Homebrew using Brewfile

set -e

# Ensure brew is in PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Installing packages..."
brew bundle --global --no-lock

echo "Package installation complete!"
