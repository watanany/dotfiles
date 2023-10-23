if status is-interactive
    switch $(uname -s):$(uname -p)
        case "Darwin:arm"
            eval $(/opt/homebrew/bin/brew shellenv)
    end

    set -gx EDITOR emacsclient
    set -gx FZF_DEFAULT_OPTS "--layout=reverse"

    set -gx PATH "$HOME/.emacs.d/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.git-subcommands" $PATH

    set -gx PATH "$HOME/.anyenv/bin" $PATH

    set -gx RBENV_ROOT "$HOME/.rbenv"
    set -gx PATH "$RBENV_ROOT/shims" $PATH

    set -gx PYENV_ROOT "$HOME/.pyenv"
    set -gx PATH "$PYENV_ROOT/shims" $PATH

    set -gx PATH "$HOME/.rye/shims" $PATH

    set -gx NODENV_ROOT "$HOME/.nodenv"
    set -gx PATH "$NODENV_ROOT/shims" $PATH

    set -gx PATH "$HOME/.poetry/bin" $PATH

    set -gx JENV_ROOT "$HOME/.jenv"
    set -gx PATH "$JENV_ROOT/shims" $PATH

    #;;; Haskell
    #;; ghcup
    set -gx PATH "$HOME/.ghcup/bin" $PATH
    set -gx PATH "$HOME/.cabal/bin" $PATH

    #;;; Golang
    set -gx PATH "$HOME/go/bin" $PATH

    #;;; Rust
    set -gx PATH "$HOME/.cargo/bin" $PATH

    #;;; Dart/Flutter
    #;; Flutter
    set -gx PATH "$HOME/.pub-cache/bin" $PATH
    set -gx PATH "$HOME/fvm/default/bin" $PATH

    #;; adbなどのコマンドを使えるようにする
    switch $(uname)
        case Darwin
            set -gx PATH "$HOME/Library/Android/sdk/platform-tools" $PATH
    end

    #;;; Android emulator
    switch $(uname)
        case Darwin
            set -gx PATH "$HOME/Library/Android/sdk/emulator" $PATH
    end

    #;;; Inkscape command
    switch $(uname)
        case Darwin
            set -gx PATH "/Applications/Inkscape.app/Contents/MacOS" $PATH
    end

    #;;; GNU tools
    switch $(uname)
        case Darwin
            set -gx PATH /opt/homebrew/opt/coreutils/libexec/gnubin $PATH
            set -gx PATH /opt/homebrew/opt/findutils/libexec/gnubin $PATH
            set -gx PATH /opt/homebrew/opt/gnu-sed/libexec/gnubin $PATH
            set -gx PATH /opt/homebrew/opt/gnu-tar/libexec/gnubin $PATH
            set -gx PATH /opt/homebrew/opt/grep/libexec/gnubin $PATH
            set -gx MANPATH /opt/homebrew/opt/coreutils/libexec/gnuman $MANPATH
            set -gx MANPATH /opt/homebrew/opt/findutils/libexec/gnuman $MANPATH
            set -gx MANPATH /opt/homebrew/opt/gnu-sed/libexec/gnuman $MANPATH
            set -gx MANPATH /opt/homebrew/opt/gnu-tar/libexec/gnuman $MANPATH
            set -gx MANPATH /opt/homebrew/opt/grep/libexec/gnuman $MANPATH
    end

    #;;; MySQL
    if test -d /opt/homebrew/opt/mysql-client
        set -gx PATH /opt/homebrew/opt/mysql-client/bin $PATH
    end

    #;;; Google Cloud SDK
    set -gx PATH "$HOME/.local/google-cloud-sdk/bin" $PATH
    if test -f "$HOME/.google-cloud-sdk/path.fish.inc"
        source "$HOME/.google-cloud-sdk/path.fish.inc"
    end

    #;;; Embulk
    set -gx PATH "$HOME/.embulk/bin" $PATH

    #;;; konryu & cotowali
    set -gx PATH "$HOME/.konryu/bin" $PATH

    #;;; direnv
    eval (direnv hook fish)

    #;;; Bun
    set -gx BUN_INSTALL "$HOME/.bun"
    set -gx PATH $BUN_INSTALL/bin $PATH

    #;;; Modular
    set -gx MODULAR_HOME "$HOME/.modular"
    set -gx PATH $MODULAR_HOME/pkg/packages.modular.com_mojo/bin $PATH

    #;;; エイリアス
    alias mv="mv -i"
    alias cp="cp -i"
    alias curl='curl -sSL'

    switch $(uname)
        case Darwin
            alias ls="ls -F"
        case '*'
            alias ls="ls -F --color=auto"
    end

    function cd
        builtin cd $argv && ls
    end

    source $(status dirname)/bind.fish

    source $(anyenv init - | psub)
end

if test -f $(status dirname)/local_config.fish
    source $(status dirname)/local_config.fish
end
