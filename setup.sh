#!/bin/bash

sudo apt update

install_packages_from_list() {
    PACKAGE_LIST_PATH="$1"
    PACKAGES_TO_INSTALL=""

    while IFS= read -r package; do
        PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL $package"
    done < "$PACKAGE_LIST_PATH"

    sudo apt install -y $PACKAGES_TO_INSTALL
}

# install essential apt packages

install_packages_from_list "~/.dotfiles/essential-packages.txt"

# set default terminal and shell

chsh -s $(which zsh)
sudo update-alternatives --config x-terminal-emulator

# set up ssh

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
printf "$(cat ~/.ssh/id_ed25519.pub)\n\ngo to https://github.com/settings/ssh/new and add the public key shown above, then press q to continue" | less

# install dotfiles

cd ~
git clone git@github.com:feelware/.dotfiles.git
cd .dotfiles
stow files

# install vscode

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update && sudo apt install -y code

# tweak gnome settings

gsettings set org.gnome.desktop.interface color-scheme            prefer-dark
gsettings set org.gnome.desktop.interface enable-animations       false
gsettings set org.gnome.desktop.interface clock-show-seconds      true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed  false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash  false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false

# install other utils

curl -fsSL https://bun.sh/install | bash

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install glow -y
