#!/bin/sh

## yay install and package install then delete artifacts
git clone https://aur.archlinux.org/yay.git

cd yay && makepkg -si --needed ; cd ..

yay -Syu $(cat ./packages.txt) --needed --noconfirm --sudoloop

rm -rf ./yay
