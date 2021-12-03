#!/bin/bash

# TODO: automate installing packages

mkdir -p $HOME/.config

mkdir -p $HOME/.config/kitty
rm -f $HOME/.config/kitty/kitty.conf
ln -sf $PWD/linux/kitty.conf $HOME/.config/kitty/kitty.conf

mkdir -p $HOME/.config/sxhkd
rm -f $HOME/.config/sxhkd/sxhkdrc
ln -sf $PWD/linux/sxhkdrc $HOME/.config/sxhkd/sxhkdrc

mkdir -p $HOME/.config/dunst
rm -f $HOME/.config/dunst/dunstrc
ln -sf $PWD/linux/dunstrc $HOME/.config/dunst/dunstrc

mkdir -p $HOME/.config/picom
rm -f $HOME/.config/picom/picom.conf
ln -sf $PWD/linux/picom.conf $HOME/.config/picom/picom.conf

rm -f $HOME/.zshrc
ln -sf $PWD/linux/.zshrc $HOME/.zshrc

rm -rf $HOME/.config/awesome
ln -sf $PWD/linux/awesome $HOME/.config/awesome

mkdir -p $HOME/.config/rofi
rm -rf $HOME/.config/rofi
ln -sf $PWD/linux/rofi $HOME/.config/rofi

mkdir -p $HOME/.config/paru
rm -rf $HOME/.config/paru/paru.conf
ln -sf $PWD/linux/paru.conf $HOME/.config/paru/paru.conf

sudo mkdir -p /etc/lightdm
sudo cp -f $PWD/linux/lightdm.conf /etc/lightdm/
sudo cp -f $PWD/linux/lightdm-webkit2-greeter.conf /etc/lightdm/

mkdir -p $HOME/.config/nvim
rm -f $HOME/.config/nvim/init.vim
ln -sf $PWD/shared/neovim.vim $HOME/.config/nvim/init.vim

rm -f $HOME/.config/starship.toml
ln -sf $PWD/shared/starship.toml $HOME/.config/starship.toml

rm $HOME/.gitconfig
ln -sf $PWD/shared/.gitconfig $HOME/.gitconfig

mkdir -p $HOME/.config/polybar
rm -rf $HOME/.config/polybar
ln -sf $PWD/linux/polybar $HOME/.config/polybar

mkdir -p $HOME/.config/spicetify
rm -f $HOME/.config/spicetify/config-xpui.ini
ln -sf $PWD/linux/spicetify.ini $HOME/.config/spicetify/config-xpui.ini

mkdir -p $HOME/.sheldon
rm -f $HOME/.sheldon/plugins.toml
ln -sf $PWD/linux/sheldon.toml $HOME/.sheldon/plugins.toml

rm -f $HOME/.xprofile
ln -sf $PWD/linux/.xprofile $HOME/.xprofile
