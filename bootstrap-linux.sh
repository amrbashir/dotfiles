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

symlink_config "$PWD/linux/rofi" "$HOME/.config/" "rofi"
symlink_config "$PWD/linux/paru.conf" "$HOME/.config/paru/" "paru.conf"
symlink_config "$PWD/shared/starship.toml" "$HOME/.config/" "starship.toml"
symlink_config "$PWD/unix/.zshrc" "$HOME/" ".zshrc"
symlink_config "$PWD/unix/.gitconfig" "$HOME/" ".gitconfig"
symlink_config "$PWD/unix/.tmux.conf" "$HOME/" ".tmux.conf"
symlink_config "$PWD/shared/ssh_config" "$HOME/.ssh/" "config"
symlink_config "$PWD/linux/ssh-add-keys.service" "$HOME/.config/systemd/user/" "ssh-add-keys.service"
systemctl --user daemon-reload
systemctl --user enable ssh-add-keys.service

# Extend PATH
echo "export PATH=\"$PWD/unix/scripts:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$PWD/shared/scripts:\$PATH\"" >> "$HOME/.zprofile"