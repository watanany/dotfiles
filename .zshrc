#--------------------------------------------------------------------------------
# Zsh設定ファイル
#--------------------------------------------------------------------------------

# 文字コードの指定
export LANG=ja_JP.UTF-8
case $UID in
    0)
    LANG=C
    ;;
esac

# emacs風のキーバインド
bindkey -e

# プロンプトを設定
autoload colors
colors
#PROMPT="%B%{m%}%n@%m %{m%}%# %{%} "
PROMPT="%B%{$fg[green]%}%n@%m %{$fg[blue]%}%# %{$reset_color%}"    # コピペ用
#PROMPT="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]"    # bash用
RPROMPT="[%~]"
SPROMPT="correct: %R -> %r ? "


autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'


export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTTIMEFORMAT='%F %T '
setopt hist_ignore_dups    # 重複したコマンドリストは無視する
setopt share_history       # コマンド履歴データを共有する

# コマンド入力時にオプションを補完
# オプションはman zshcompsysを参照
autoload -U compinit
compinit -u

# 補完候補一覧をカラー表示する
#（設定してないのでlsと異なる色が表示される）
zstyle ':completion:*' list-colors''

# 補完候補を矢印で選択可能にする
zstyle ':completion:*:default' menu select=1
# 大文字小文字関係なく補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

setopt auto_cd              # cdなしで移動できるようになる
setopt auto_pushd           # cd -[TAB] で移動先を履歴から補完
#setopt correct              # コマンドを間違った時に正しそうなコマンドを提示してくれる
setopt list_packed          # 補完候補を詰めて表示
setopt no_beep              # ビープ音を消す
setopt nolistbeep           # 補完時のビープ音を無効化
setopt complete_aliases     # alias展開後に補完する
# setopt noautoremoveslash    # ファイル名補完時に自動で末尾のスラッシュを削除しないようにする

# Ctrl-P, Ctrl-N でコマンド履歴で補完
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

export FZF_DEFAULT_OPTS='--layout=reverse'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 先行予測機能を有効化
# autoload predict-on
# predict-on

# コアファイルを作らないようにする
limit coredumpsize 0

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export EDITOR=vim
export PAGER=less
export TERM=xterm-256color
# export TERM=xterm-direct
export PATH=~/.emacs.d/bin:~/.git-subcommands:~/.local/bin:$PATH

# aliasの設定
alias mv="mv -i"
alias cp="cp -i"

if test `uname` = "Darwin"; then
    alias ls="ls -F"
else
    alias ls="ls -F --color=auto"
fi

alias grep='grep --colour=auto'
alias j='jobs -l'
alias la='ls -a'
alias ll='ls -l'
alias su='su -l'
alias vimrc='vim ~/.vimrc'
alias curl='curl -sSL'
function cd { builtin cd $@ && ls; }
function em { emacs $@ & }
function en { emacs -nw $@ }

# tmux
function tmux-windows {
  tmux new-window
  tmux new-window
  tmux rename-window -t 0 'server'
  tmux rename-window -t 1 'editor'
  tmux rename-window -t 2 'others'
  tmux select-window -t 0
}

function tmux-panes {
    tmux split-window -hd
    tmux select-pane -R
    tmux split-window -vd
    tmux split-window -vd
    tmux resize-pane -D 5
    tmux select-pane -D
    tmux resize-pane -D 10
}

# auto-fuの設定
# if [ -f ~/.zsh/auto-fu.zsh/auto-fu.zsh ]; then
#     source ~/.zsh/auto-fu.zsh/auto-fu.zsh
#     zle-line-init () {auto-fu-init;}
#     zle -N zle-line-init
#     zstyle ':completion:*' completer _oldlist _complete
#     zle -N zle-keymap-select auto-fu-zle-keymap-select
# fi

# Ruby on Rails
alias be='bundle exec'
alias rails='bundle exec spring rails'
alias rake='bundle exec spring rake'
alias rspec='bundle exec spring rspec'
alias sidekiq='bundle exec sidekiq'

# その他
export KERAS_BACKEND=tensorflow

# brew
case "$(uname -s)_$(uname -p)" in
    "Darwin_arm" )
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
esac

#======================================================================
# 言語ごとのツール設定
#======================================================================
#;;; Gauche
#;; Gauche REPL alias
alias igosh="rlwrap gosh"

#;;; Ruby
#;; rbenv
case "$(uname -s)" in
    "Darwin" )
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
        ;;
esac
export RBENV_ROOT="$HOME/.rbenv"
eval "$(rbenv init -)"

#;;; Python
#;; pyenv
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

#;; poetry
export PATH="$HOME/.poetry/bin:$PATH"

#;;; Node.js
eval "$(nodenv init -)"
export NODE_PATH=$(npm root -g)

#;;; Haskell
#;; ghcup
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

#;; stack's shell auto-completion
# eval "$(stack --bash-completion-script stack)"

#;;; Rust
# source $HOME/.cargo/env

#;;; Java
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

#;;; Golang
export PATH="$HOME/go/bin:$PATH"

#;;; Dart/Flutter
#;; adbなどのコマンドを使えるようにする
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"

#;; Flutter
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$HOME/fvm/default/bin:$PATH"

#;;; Android emulator
export PATH="$HOME/Library/Android/sdk/emulator:$PATH"

#;;; Inkscape command
case "$(uname -s)" in
    "Darwin" )
        export PATH="/Applications/Inkscape.app/Contents/MacOS:$PATH"
        ;;
esac

#;;; GNU tools
case "$(uname -s)" in
    "Darwin" )
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
        export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
        export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
        export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
        export MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"
        export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
        export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
        export MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"
        ;;
esac

#;;; Google Cloud SDK
export PATH="$HOME/.local/google-cloud-sdk/bin:$PATH"
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.local/library-164912-e95e373384ca.json"

#;;; .zshrc.local(実験用設定ファイル)を実行
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

#;;; Hello World
echo "\n\e[31m*\e[m \e[33m*\e[m \e[35m*\e[m \e[36m*\e[m Hello World \e[31m*\e[m \e[33m*\e[m \e[35m*\e[m \e[36m*\e[m\n"

