#!/bin/bash

# Inspired by:
# - https://github.com/denoland/deno_install/blob/master/install.sh
#   Copyright 2019 the Deno authors. All rights reserved. MIT license.
# - https://github.com/superfly/flyctl/blob/master/installers/install.sh
# - https://github.com/airplanedev/cli/releases/latest/download/install.sh

# Install the BotifyMe command line tool

# Replace with your GitHub username and repository
USER="botifyme"
REPO="cli"
BOTIFYME_INSTALL_DIR="$HOME/.botifyme"
BOTIFYME_BIN_DIR="$BOTIFYME_INSTALL_DIR/bin"

# Determine system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ASSET_ARCH="amd64"
        ;;
    aarch64)
        ASSET_ARCH="arm64"
        ;;
    arm64)
        ASSET_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

KERNEL_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')

# Fetch the latest release
RELEASE_INFO=$(curl -s https://api.github.com/repos/$USER/$REPO/releases/latest)

# Extract the download URL for the right asset
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep "browser_download_url.*$ASSET_ARCH" | grep $KERNEL_NAME | cut -d '"' -f 4 | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Failed to find a download URL for architecture: $ASSET_ARCH"
    exit 1
fi

# Create the bin directory, if it doesn't exist
if [ ! -d "$BOTIFYME_BIN_DIR" ]; then
    mkdir -p "$BOTIFYME_BIN_DIR"
fi

# Download the asset
# Download the asset
if command -v curl > /dev/null; then
    curl -L $DOWNLOAD_URL -o "$BOTIFYME_BIN_DIR/botifyme" --silent
elif command -v wget > /dev/null; then
    wget $DOWNLOAD_URL -O "$BOTIFYME_BIN_DIR/botifyme" -q
else
    echo "Error: 'curl' or 'wget' is required but not installed."
    exit 1
fi

chmod +x $BOTIFYME_BIN_DIR/botifyme

echo "✅ The BotifyMe CLI was installed successfully to $BOTIFYME_BIN_DIR/botifyme"

if command -v botifyme >/dev/null; then
    echo "🚀 Run 'botifyme --help' to get started."
else
    case $SHELL in
    /bin/zsh) shell_profile=".zshrc" ;;
    *) shell_profile=".bash_profile" ;;
    esac
    echo "✋ Manually add the following to your \$HOME/$shell_profile (or similar):"
    echo "    export PATH=\"${BOTIFYME_BIN_DIR}:\$PATH\""
    echo ""
    echo "Then, run 'airplane --help' to get started."
fi
