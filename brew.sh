#!/usr/bin/env bash
set -euo pipefail

brew install \
    cmake pcre git wget tree rg fd exa git-delta tmux tig \
    binutils findutils diffutils coreutils moreutils \
    grep gzip gnu-tar gnu-sed gnu-time gnu-getopt \
    watch rlwrap \
    jq yq \
    pyenv rbenv nodenv jenv tfenv goenv \
    llvm@12 ghcup elm leiningen \
    dhall dhall-json \
    graphviz comby act \
    awscli slack-cli \
    gh ghq direnv \
    terraform terraformer \
    pandoc hyperfine \
    mermaid-cli lua-language-server

brew install fzf && $(brew --prefix)/opt/fzf/install

brew tap d12frosted/emacs-plus
brew install emacs-plus
brew services start d12frosted/emacs-plus/emacs-plus@28

brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# TODO:
# brew caskでCLIツール以外のインストールの管理をしたい
# macのシステム機能拡張やセキュリティの設定などは結局手動でやらなければならないかどうかが気になる
# App Storeでのみ配布しているアプリは無理そう？
#
# App Storeからのインストールしたアプリ
# - Craft
# - Bitwarden
# - LINE
# - Magnet
# - Spark
# - The Unarchiver
# - Things
# - TweetDeck
# - Xcode
# - Marked 2 - Markdown Preview
# - OneTab
# - Vimari
# - Dark Reader

brew install --cask karabiner-elements
brew install --cask iterm2
brew install --cask google-chrome
brew install --cask keyboardcleantool
brew install --cask appcleaner
brew install --cask docker
brew install --cask visual-studio-code
brew install --cask deepl
brew install --cask tableplus
brew install --cask discord
brew install --cask slack
brew install --cask zoom
brew install --cask steam
brew install --cask virtualbox
brew install --cask vagrant
brew install --cask bathyscaphe
brew install --cask brave-browser
brew install --cask dash
brew install --cask proxyman
brew install --cask parallels

brew tap homebrew/cask-versions
brew install --cask temurin8
