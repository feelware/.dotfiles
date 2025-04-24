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

gsettings set org.gnome.desktop.interface color-scheme             prefer-dark
gsettings set org.gnome.desktop.interface enable-animations        false
gsettings set org.gnome.desktop.interface clock-show-seconds       true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed   false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash   false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts  false
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false

# install wine staging (9.21)

sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
sudo apt update && sudo apt install --install-recommends -y winehq-staging=9.21~noble-1 wine-staging=9.21~noble-1 wine-staging-amd64=9.21~noble-1 wine-staging-i386:i386=9.21~noble-1
sudo apt-mark hold winehq-staging wine-staging wine-staging-amd64 wine-staging-i386:i386

# install yabridge

YABRIDGE_VERSION=$(curl -s "https://api.github.com/repos/robbert-vdh/yabridge/tags" | jq -r '.[0].name')
wget -O - "https://github.com/robbert-vdh/yabridge/releases/latest/download/yabridge-${YABRIDGE_VERSION}.tar.gz" | tar -xz
mv yabridge ~/.local/share/

# install bespoke-synth

echo 'deb http://download.opensuse.org/repositories/home:/bespokesynth/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/home:bespokesynth.list
curl -fsSL https://download.opensuse.org/repositories/home:bespokesynth/xUbuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_bespokesynth.gpg > /dev/null
sudo apt update
sudo apt install bespokesynth

# install and configure other utils

cd ~

curl -fsSL https://bun.sh/install | bash

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install glow -y

sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install --noninteractive flathub dev.vencord.Vesktop

sudo snap install obsidian --classic

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

bash <(curl -sSL https://spotx-official.github.io/run.sh)
