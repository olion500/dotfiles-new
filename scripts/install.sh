#!/bin/sh
set -e

# ===========================================
# Dotfiles Installer
# ===========================================
# Usage:
#   curl -fsLS https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/scripts/install.sh | sh
# ===========================================

GITHUB_USERNAME="${GITHUB_USERNAME:-YOUR_USERNAME}"
CHEZMOI_BIN="$HOME/.local/bin/chezmoi"

echo "==> Installing dotfiles..."

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Darwin) echo "==> Detected macOS" ;;
    Linux)  echo "==> Detected Linux" ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

# Install chezmoi if not present
if [ ! -f "$CHEZMOI_BIN" ] && ! command -v chezmoi >/dev/null 2>&1; then
    echo "==> Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Use installed chezmoi
if [ -f "$CHEZMOI_BIN" ]; then
    CHEZMOI="$CHEZMOI_BIN"
else
    CHEZMOI="chezmoi"
fi

# Initialize and apply dotfiles
echo "==> Initializing dotfiles from github.com/$GITHUB_USERNAME/dotfiles..."
"$CHEZMOI" init --apply "$GITHUB_USERNAME"

echo ""
echo "==> Done!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: exec zsh"
echo "  2. Switch profile: use-work / use-personal"
echo ""
