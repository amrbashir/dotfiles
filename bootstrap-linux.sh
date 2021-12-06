#!/bin/bash

# TODO: add packages installation

configs=(
    # file -- targetDir -- targetFileOrFolder
    "$PWD/linux/kitty.conf" "$HOME/.config/kitty/" "kitty.conf"
    "$PWD/linux/sxhkdrc" "$HOME/.config/sxhkd/" "sxhkdrc"
    "$PWD/linux/dunstrc" "$HOME/.config/dunst/" "dunstrc"
    "$PWD/linux/picom.conf" "$HOME/.config/picom/" "picom.conf"
    "$PWD/linux/.zshrc" "$HOME/" ".zshrc"
    "$PWD/linux/awesome" "$HOME/.config/" "awesome"
    "$PWD/linux/rofi" "$HOME/.config/" "rofi"
    "$PWD/linux/paru.conf" "$HOME/.config/paru/" "paru.conf"
    "$PWD/shared/neovim.vim" "$HOME/.config/nvim/" "init.vim"
    "$PWD/shared/starship.toml" "$HOME/.config/" "starship.toml"
    "$PWD/shared/.gitconfig" "$HOME/" ".gitconfig"
    "$PWD/linux/polybar" "$HOME/.config/" "polybar"
    "$PWD/linux/spicetify.ini" "$HOME/.config/spicetify/" "config-xpui.ini"
    "$PWD/linux/sheldon.toml" "$HOME/.sheldon/" "plugins.toml"
    "$PWD/linux/.xprofile" "$HOME/" ".xprofile"
)
for ((i = 0 ; i < ${#configs[*]} ; i+=3)); do
    file="${configs[$i]}"
    targetDir="${configs[$(($i+1))]}"
    targetFileOrDir="${configs[$(($i+2))]}"
    target="$targetDir$targetFileOrDir"

    mkdir -p $targetDir
    rm -rf $target
    ln -sf $file $target
done

# lightdm starts from root and have no idea about $HOME so we copy the files instead of symlinking
sudo cp -f $PWD/linux/lightdm.conf /etc/lightdm/
sudo cp -f $PWD/linux/lightdm-webkit2-greeter.conf /etc/lightdm/
