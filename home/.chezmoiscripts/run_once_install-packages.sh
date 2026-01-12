#!/bin/bash
# Install common packages via Homebrew (macOS and Linux)

set -e

# Ensure brew is in PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Installing packages via Homebrew..."

# All packages in one command
brew install --quiet \
    starship \
    zoxide \
    fzf \
    eza \
    bat \
    fd \
    ripgrep \
    mise \
    neovim \
    lazygit \
    gdu \
    bottom \
    tree-sitter

# Nerd Fonts
# Note: After installation, set "Hack Nerd Font" in your terminal app
brew install --cask --quiet font-hack-nerd-font 2>/dev/null || true

echo "Package installation complete!"
