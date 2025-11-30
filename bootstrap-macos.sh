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
