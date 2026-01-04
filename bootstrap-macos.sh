#!/bin/bash

# TODO: add packages installation

# Function to create symlink for config files
# Arguments:
#   $1 - source file path
#   $2 - target directory path
#   $3 - target file or directory name
symlink_config() {
    mkdir -p "$2"
    rm -rf "$2$3"
    ln -sf "$1" "$2$3"
}

symlink_config "$PWD/macos/komorebi.json" "$HOME/.config/komorebi/" "komorebi.json"
symlink_config "$PWD/macos/skhdrc" "$HOME/.config/skhd/" "skhdrc"
symlink_config "$PWD/shared/starship.toml" "$HOME/.config/" "starship.toml"
symlink_config "$PWD/unix/.zshrc" "$HOME/" ".zshrc"
symlink_config "$PWD/unix/.gitconfig" "$HOME/" ".gitconfig"

# Set environment variables
echo "export PATH=\"/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/findutils/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/grep/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gsed/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gawk/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-getopt/libexec/gnubin:$PATH\"" >> "$HOME/.zprofile"

echo "export CARGO_TARGET_DIR=$HOME/.cache/.cargo-target" >> "$HOME/.zshenv"
echo "export SSH_AUTH_SOCK=\"$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock\"" >> "$HOME/.zshenv"