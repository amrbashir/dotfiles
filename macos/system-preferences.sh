#!/bin/bash
set -eo pipefail

# Dark appearance
defaults write -g AppleInterfaceStyle -string Dark

# Disable natural scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Control+Q for Close and Close Window in the File and Window menus
defaults write -g NSUserKeyEquivalents -dict-add \
    $'\033File\033Close' '^q' \
    $'\033File\033Close Window' '^q' \
    $'\033Window\033Close' '^q' \
    $'\033Window\033Close Window' '^q'

# Disable clicking the wallpaper to reveal the desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Dock
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 64

echo "macOS preferences restored. Log out and back in to apply them."
