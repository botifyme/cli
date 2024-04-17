#!/bin/bash

# Install the BotifyMe command line tool

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

# Determine file extension for Windows
if [ "$KERNEL_NAME" = "windows" ]; then
    FILE_EXT=".exe"
else
    FILE_EXT=""
fi

# Construct the download URL
DOWNLOAD_URL="https://storage.botifyme.dev/cli/latest/botifyme-$KERNEL_NAME-$ASSET_ARCH$FILE_EXT"

# Create the bin directory, if it doesn't exist
if [ ! -d "$BOTIFYME_BIN_DIR" ]; then
    mkdir -p "$BOTIFYME_BIN_DIR"
fi

# Download the asset
if command -v curl > /dev/null; then
    curl -L "$DOWNLOAD_URL" -o "$BOTIFYME_BIN_DIR/botifyme$FILE_EXT" --silent --show-error
elif command -v wget > /dev/null; then
    wget "$DOWNLOAD_URL" -O "$BOTIFYME_BIN_DIR/botifyme$FILE_EXT" -q --show-progress
else
    echo "Error: 'curl' or 'wget' is required but not installed."
    exit 1
fi

chmod +x "$BOTIFYME_BIN_DIR/botifyme$FILE_EXT"

echo "✓ BotifyMe installed successfully."
echo "Please add $BOTIFYME_BIN_DIR to your PATH to use it from anywhere."
echo "For example, you can add the line below to your .bashrc or .bash_profile:"
echo 'export PATH=$PATH:'"$BOTIFYME_BIN_DIR"

