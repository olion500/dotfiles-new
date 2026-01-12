#!/bin/bash
# Install Homebrew (works on macOS and Linux)

set -e

# Linux: install dependencies first
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing Homebrew dependencies..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential procps curl file git unzip
fi

if command -v brew &> /dev/null; then
    echo "Homebrew is already installed"
    exit 0
fi

echo "Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH for this session
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Homebrew installed successfully!"
