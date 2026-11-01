#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1

# TODO: add packages installation

# Function to create symlink for config files
# Arguments:
#   $1 - source file path
#   $2 - target directory path
#   $3 - target file or directory name
#   --chmod MODE - target directory permissions (optional, after $3)
symlink_config() {
    mkdir -p "$2"
    if [[ "${4:-}" == --chmod ]]; then
        chmod "$5" "$2"
    fi
    rm -rf "$2$3"
    ln -sf "$1" "$2$3"
}

symlink_config "$SCRIPT_DIR/linux/rofi" "$HOME/.config/" "rofi"
symlink_config "$SCRIPT_DIR/linux/paru.conf" "$HOME/.config/paru/" "paru.conf"
symlink_config "$SCRIPT_DIR/shared/starship.toml" "$HOME/.config/" "starship.toml"
symlink_config "$SCRIPT_DIR/unix/.zshrc" "$HOME/" ".zshrc"
symlink_config "$SCRIPT_DIR/unix/.gitconfig" "$HOME/" ".gitconfig"
symlink_config "$SCRIPT_DIR/unix/.tmux.conf" "$HOME/" ".tmux.conf"
symlink_config "$SCRIPT_DIR/shared/ssh_config" "$HOME/.ssh/" "config" --chmod 700
symlink_config "$SCRIPT_DIR/linux/ssh-add-keys.service" "$HOME/.config/systemd/user/" "ssh-add-keys.service"

systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.socket
systemctl --user enable ssh-add-keys.service
systemctl --user restart ssh-add-keys.service

# Extend PATH
echo "export PATH=\"$SCRIPT_DIR/unix/scripts:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$SCRIPT_DIR/shared/scripts:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$HOME/.zprofile"

cat << 'EOF' >> "$HOME/.zprofile"
if [[ "$OSTYPE" == linux* && -z "$SSH_AUTH_SOCK" && -z "$SSH_CONNECTION" ]]; then
    SSH_AUTH_SOCK="$(systemctl --user show ssh-agent.socket --property=Listen --value)"
    export SSH_AUTH_SOCK="${SSH_AUTH_SOCK%" (Stream)"}"
fi
EOF
