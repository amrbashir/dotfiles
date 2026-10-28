#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1

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

# Install Command Line Tools before Homebrew
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    echo "Finish installing Command Line Tools, then rerun this script."
    exit 1
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add taps
brew tap amrbashir/tap
brew tap jackielii/tap
brew tap lgug2z/tap

# Install formulae
brew install \
    bat \
    clang-format \
    cmake \
    coreutils \
    create-dmg \
    eza \
    fd \
    findutils \
    mise \
    fzf \
    gawk \
    gh \
    gnu-getopt \
    gnu-indent \
    gnu-sed \
    gnu-tar \
    gnutls \
    grep \
    hunk \
    jackielii/tap/skhd-zig \
    lgug2z/tap/komorebi-for-mac \
    neovim \
    ninja \
    starship \
    tailscale \
    taplo \
    tmux \
    zoxide \
    bitwarden-cli \
    kunobi-ninja/kunobi/kache

# Install casks
brew install --cask \
    1password-cli \
    alt-tab \
    bitwarden \
    discord \
    disktree \
    font-fira-code \
    font-fira-code-nerd-font \
    ghostty \
    komorebi-switcher \
    mailspring \
    openmtp \
    vicinae \
    stats \
    swift-shift \
    visual-studio-code \
    zen \
    zulip

# Install rustup and Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Configure Cargo caching and the kache login service
kache init --yes --no-shell

# Symlink config files
symlink_config "$SCRIPT_DIR/macos/komorebi.json" "$HOME/.config/komorebi/" "komorebi.json"
symlink_config "$SCRIPT_DIR/macos/skhdrc" "$HOME/.config/skhd/" "skhdrc"
symlink_config "$SCRIPT_DIR/macos/ghostty.conf" "$HOME/Library/Application Support/com.mitchellh.ghostty/" "config.ghostty"
symlink_config "$SCRIPT_DIR/shared/starship.toml" "$HOME/.config/" "starship.toml"
symlink_config "$SCRIPT_DIR/unix/.zshrc" "$HOME/" ".zshrc"
symlink_config "$SCRIPT_DIR/unix/.gitconfig" "$HOME/" ".gitconfig"
symlink_config "$SCRIPT_DIR/unix/.tmux.conf" "$HOME/" ".tmux.conf"
symlink_config "$SCRIPT_DIR/shared/ssh_config" "$HOME/.ssh/" "config"
symlink_config "$SCRIPT_DIR/macos/com.user.ssh-add-keys.plist" "$HOME/Library/LaunchAgents/" "com.user.ssh-add-keys.plist"

# Native app preferences must go through defaults, not symlinked plist files.
bash "$SCRIPT_DIR/macos/app-preferences.sh" || exit 1
bash "$SCRIPT_DIR/macos/system-preferences.sh"

# Start apps at login
osascript "$SCRIPT_DIR/macos/login-items.applescript"

# Start services
sudo /opt/homebrew/opt/tailscale/bin/tailscaled install-system-daemon
skhd --start-service
komorebic enable-autostart

# Extend PATH
echo "export PATH=\"/opt/homebrew/opt/coreutils/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/findutils/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/grep/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-tar/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gsed/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gawk/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-indent/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-getopt/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$SCRIPT_DIR/unix/scripts:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$SCRIPT_DIR/shared/scripts:\$PATH\"" >> "$HOME/.zprofile"

# Set environment variables
