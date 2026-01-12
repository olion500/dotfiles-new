#!/bin/bash
# Install packages via Homebrew using Brewfile

set -e

# Ensure brew is in PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Installing common packages..."
brew bundle --file="$HOME/.Brewfile" --no-lock

# macOS only packages
if [[ "$OSTYPE" == "darwin"* ]] && [[ -f "$HOME/.Brewfile.mac" ]]; then
    echo "Installing macOS packages..."
    brew bundle --file="$HOME/.Brewfile.mac" --no-lock
fi

echo "Package installation complete!"
