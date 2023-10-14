#!/usr/bin/env bash
set -euo pipefail

sudo apt upgrade
sudo add-apt-repository universe

sudo add-apt-repository ppa:wslutilities/wslu
sudo apt update
sudo apt install -y wslu

sudo apt install -y \
    language-pack-ja language-pack-gnome-ja \
    manpages-ja manpages-ja-dev

sudo apt install -y libfuse2
sudo apt install -y fzf

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish

curl -sSL https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    -o ~/.local/bin/nvim
chmod u+x ~/.local/bin/nvim

sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install -y \
    cmake ripgrep fd-find build-essential libtool-bin \
    direnv \
    fonts-firacode emacs28 emacs28-el

sudo apt install -y nodejs ipython3
