#********************************************************************************
# Zsh設定ファイル Linux用
#********************************************************************************

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
export HISTSIZE=10000
export SAVEHIST=10000
export HISTTIMEFORMAT='%F %T '
setopt hist_ignore_dups    # 重複したコマンドリストは無視する
setopt share_history       # コマンド履歴データを共有する

# コマンド入力時にオプションを補完
autoload -U compinit
compinit

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
export PATH=~/.emacs.d/bin:~/.git-subcommands:~/.local/bin:$PATH

export KERAS_BACKEND=tensorflow

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
function cd() { builtin cd $@ && ls; }
function em() { emacs $@ & }
function en() { emacs -nw $@ }

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

pretty_json() {
    python -c 'import sys, json; j=json.loads(sys.stdin.read()); print(json.dumps(j, indent=4, ensure_ascii=False))'
}

# Ruby on Rails
alias be='bundle exec'
alias rails='bundle exec spring rails'
alias rake='bundle exec spring rake'
alias rspec='bundle exec spring rspec'
alias sidekiq='bundle exec sidekiq'

alias git-vimdiff='git difftool --tool=vimdiff --no-prompt'

# auto-fuの設定
# if [ -f ~/.zsh/auto-fu.zsh/auto-fu.zsh ]; then
#     source ~/.zsh/auto-fu.zsh/auto-fu.zsh
#     zle-line-init () {auto-fu-init;}
#     zle -N zle-line-init
#     zstyle ':completion:*' completer _oldlist _complete
#     zle -N zle-keymap-select auto-fu-zle-keymap-select
# fi

# .zshrc.local(実験用設定ファイル)を実行
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Hello World
echo "\n\e[31m*\e[m \e[33m*\e[m \e[35m*\e[m \e[36m*\e[m Hello World \e[31m*\e[m \e[33m*\e[m \e[35m*\e[m \e[36m*\e[m\n"
