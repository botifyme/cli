#!/bin/bash

# Install the BotifyMe command line tool

#!/bin/bash

# Function to determine system architecture
determine_architecture() {
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
}

# Function to determine kernel name and file extension for Windows
determine_kernel_and_extension() {
    KERNEL_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [ "$KERNEL_NAME" = "windows" ]; then
        FILE_EXT=".exe"
    else
        FILE_EXT=""
    fi
}

# Function to construct the download URLs
construct_download_urls() {
    DOWNLOAD_URL="https://storage.botifyme.dev/cli/latest/botifyme-$KERNEL_NAME-$ASSET_ARCH$FILE_EXT"
    GIT_REMOTE_HELPER_DOWNLOAD_URL="https://storage.botifyme.dev/cli/latest/git-remote-botifyme-$KERNEL_NAME-$ASSET_ARCH$FILE_EXT"
}

# Function to create the bin directory
create_bin_directory() {
    if [ ! -d "$BOTIFYME_BIN_DIR" ]; then
        mkdir -p "$BOTIFYME_BIN_DIR"
    fi
}

# Function to download the asset
download_asset() {
    if command -v curl > /dev/null; then
        curl -L "$1" -o "$2" --silent --show-error
    elif command -v wget > /dev/null; then
        wget "$1" -O "$2" -q --show-progress
    else
        echo "Error: 'curl' or 'wget' is required but not installed."
        exit 1
    fi
    chmod +x "$2"
}

# Function to add the bin directory to PATH
add_to_path() {
    case $SHELL in
        */bash)
            echo 'export PATH=$PATH:'"$BOTIFYME_BIN_DIR" >> "$HOME/.bashrc"
            echo "✓ Added to .bashrc"
            ;;
        */zsh)
            echo 'export PATH=$PATH:'"$BOTIFYME_BIN_DIR" >> "$HOME/.zshrc"
            echo "✓ Added to .zshrc"
            ;;
        */fish)
            echo 'set -gx PATH $PATH '"$BOTIFYME_BIN_DIR" >> "$HOME/.config/fish/config.fish"
            echo "✓ Added to fish config"
            ;;
        *)
            echo "✓ Shell not recognized. Add $BOTIFYME_BIN_DIR to your PATH manually."
            ;;
    esac
}

# Main script execution
main() {
    BOTIFYME_INSTALL_DIR="$HOME/.botifyme"
    BOTIFYME_BIN_DIR="$BOTIFYME_INSTALL_DIR/bin"
    
    determine_architecture
    determine_kernel_and_extension
    construct_download_urls
    create_bin_directory
    download_asset "$DOWNLOAD_URL" "$BOTIFYME_BIN_DIR/botifyme$FILE_EXT"
    download_asset "$GIT_REMOTE_HELPER_DOWNLOAD_URL" "$BOTIFYME_BIN_DIR/git-remote-botifyme$FILE_EXT"
    
    echo "✓ BotifyMe cli installed successfully."
    echo "Adding $BOTIFYME_BIN_DIR to your PATH..."
    add_to_path
    echo "Please restart your terminal or run 'source ~/.bashrc', 'source ~/.zshrc', or 'source ~/.config/fish/config.fish' to apply the changes."
}

# Execute the main function
main

