#!/bin/bash

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
    fnm \
    fzf \
    gawk \
    gh \
    gnu-getopt \
    gnu-indent \
    gnu-sed \
    gnu-tar \
    gnutls \
    grep \
    jackielii/tap/skhd-zig \
    lgug2z/tap/komorebi-for-mac \
    neovim \
    ninja \
    opencode \
    starship \
    tailscale \
    tmux \
    zoxide \
    bitwarden-cli \
    sccache

# Install casks
brew install --cask \
    1password-cli \
    alt-tab \
    bitwarden \
    claude-code \
    codex \
    discord \
    ghostty \
    jordanbaird-ice@beta \
    komorebi-switcher \
    mailspring \
    openmtp \
    raycast \
    stats \
    swift-shift \
    visual-studio-code \
    zen-browser \
    zulip

xcode-select --install

# Easy Ethernet Icon (no Homebrew cask available)
curl -L -o /tmp/Easy-Ethernet-Icon.zip "https://github.com/felixblome/easy-ethernet-icon/releases/download/v1.2/Easy-Ethernet-Icon.zip"
unzip -o /tmp/Easy-Ethernet-Icon.zip -d /tmp
cp -r "/tmp/Easy-Ethernet-Icon/Easy Ethernet Icon.app" /Applications/
xattr -dr com.apple.quarantine "/Applications/Easy Ethernet Icon.app"
rm -rf /tmp/Easy-Ethernet-Icon /tmp/Easy-Ethernet-Icon.zip

# Install rustup and Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Start services
sudo brew services start tailscale
skhd --start-service
komorebic enable-autostart

# Symlink config files
symlink_config "$PWD/macos/komorebi.json" "$HOME/.config/komorebi/" "komorebi.json"
symlink_config "$PWD/macos/skhdrc" "$HOME/.config/skhd/" "skhdrc"
symlink_config "$PWD/shared/starship.toml" "$HOME/.config/" "starship.toml"
symlink_config "$PWD/unix/.zshrc" "$HOME/" ".zshrc"
symlink_config "$PWD/unix/.gitconfig" "$HOME/" ".gitconfig"
symlink_config "$PWD/unix/.tmux.conf" "$HOME/" ".tmux.conf"
symlink_config "$PWD/shared/ssh_config" "$HOME/.ssh/" "config"

# Extend PATH
echo "export PATH=\"/opt/homebrew/opt/coreutils/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/coreutils/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/findutils/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/grep/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-tar/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gsed/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gawk/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-indent/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"/opt/homebrew/opt/gnu-getopt/libexec/gnubin:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$PWD/unix/scripts:\$PATH\"" >> "$HOME/.zprofile"
echo "export PATH=\"$PWD/shared/scripts:\$PATH\"" >> "$HOME/.zprofile"

# Set environment variables
