#!/bin/bash

# TODO: add packages installation

declare -a configs=(
    # file -- targetDir -- targetFileOrFolder
    "$PWD/linux/kitty.conf" "$HOME/.config/kitty/" "kitty.conf"
    "$PWD/linux/.zshrc" "$HOME/" ".zshrc"
    "$PWD/linux/rofi" "$HOME/.config/" "rofi"
    "$PWD/linux/paru.conf" "$HOME/.config/paru/" "paru.conf"
    "$PWD/shared/starship.toml" "$HOME/.config/" "starship.toml"
    "$PWD/linux/.gitconfig" "$HOME/" ".gitconfig"
    "$PWD/linux/sheldon.toml" "$HOME/.sheldon/" "plugins.toml"
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
