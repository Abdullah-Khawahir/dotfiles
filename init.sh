#!/bin/sh
hasprg(){
    command -v $1 >/dev/null
}
contains(){
    grep -q "$1" "$2"
}

##############################################################################
##############################################################################
stow . --adopt
rm ~/init.sh

if ! contains "source my.zsh" ~/.zshrc; then
    echo "source my.zsh" >> ~/.zshrc
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

## yay install and package install then delete artifacts
if [ ! -d ./yay ]; then
    git clone https://aur.archlinux.org/yay.git
fi

if ! hasprg yay; then 
    echo "Installing yay ..."
    cd yay ; makepkg -si --needed ; cd ..

    if [[ -d ./yay ]]; then
        rm -rf ./yay
    fi
fi
yay -Syu $(cat ./packages.txt) --needed --noconfirm --sudoloop

if  hasprg fzf ; then
    fzf --zsh > ~/.fzf-integration.sh
    if ! contains "source ~/.fzf-integration.sh" ~/.zshrc ; then
        echo "appending fzf-zsh integration"
        echo "source ~/.fzf-integration.sh" >> ~/.zshrc 
    fi
fi

