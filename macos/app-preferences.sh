#!/bin/bash
set -euo pipefail

# com.pablopunk.Swift-Shift
# Shortcut data encodes Command (modifierFlagsRawValue = 1048576).
defaults write com.pablopunk.Swift-Shift requireMouseClick -bool true
defaults write com.pablopunk.Swift-Shift Move_mouseButton -string Left
defaults write com.pablopunk.Swift-Shift Resize_mouseButton -string Right
defaults write com.pablopunk.Swift-Shift Move_keyboardShortcut -data 7b226d6f646966696572466c61677352617756616c7565223a313034383537367d
defaults write com.pablopunk.Swift-Shift Resize_keyboardShortcut -data 7b226d6f646966696572466c61677352617756616c7565223a313034383537367d
defaults write com.pablopunk.Swift-Shift focusOnApp -bool false
defaults write com.pablopunk.Swift-Shift useQuadrants -bool true
defaults write com.pablopunk.Swift-Shift showMenuBarIcon -bool true

# eu.exelban.Stats
defaults write eu.exelban.Stats CPU_state -bool false
defaults write eu.exelban.Stats RAM_state -bool false
defaults write eu.exelban.Stats Disk_state -bool false
defaults write eu.exelban.Stats Battery_state -bool false
defaults write eu.exelban.Stats Network_widget -string speed
defaults write eu.exelban.Stats Network_reader -string interface
defaults write eu.exelban.Stats Network_base -string byte
defaults write eu.exelban.Stats Network_speed_mode -string oneRow
defaults write eu.exelban.Stats Network_speed_icon -string arrows
defaults write eu.exelban.Stats Network_speed_iconAlignment -string left
defaults write eu.exelban.Stats Network_speed_value -bool true
defaults write eu.exelban.Stats Network_speed_valueAlignment -string center
defaults write eu.exelban.Stats Network_speed_monochrome -bool false
defaults write eu.exelban.Stats Network_speed_downloadColor -string white
defaults write eu.exelban.Stats Network_speed_uploadColor -string white
defaults write eu.exelban.Stats Network_speed_displayValue -string io
defaults write eu.exelban.Stats Network_state_position -int 3
defaults write eu.exelban.Stats Network_speed_position -int 0
defaults write eu.exelban.Stats Network_label_position -int 1
defaults write eu.exelban.Stats Network_networkChart_position -int 2
defaults write eu.exelban.Stats Network_text_position -int 4

# com.lwouis.alt-tab-macos
defaults write com.lwouis.alt-tab-macos appearanceSize -string 1
defaults write com.lwouis.alt-tab-macos menubarIcon -string 4
defaults write com.lwouis.alt-tab-macos previewFocusedWindow -string false

echo "Preferences restored."
