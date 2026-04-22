if status is-interactive
    #;;; !$
    source $(status dirname)/bind.fish

    if type -q nvim
        set -gx EDITOR nvim
    else
        set -gx EDITOR vim
    end

    set -gx PATH "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.git-subcommands" $PATH

    #;;; エイリアス
    alias mv="mv -i"
    alias cp="cp -i"
    alias curl='curl -sSL'
    alias ls="ls -F --color=auto"
    alias fennel="rlwrap fennel"

    function cd
        builtin cd $argv && ls
    end

    #;;; brew
    switch $(uname -s):$(uname -p)
        case "Darwin:arm"
            eval $(/opt/homebrew/bin/brew shellenv)
    end

    #;;; emacs
    if type -q emacs
        set -gx PATH "$HOME/.emacs.d/bin" $PATH
    end

    #;;; fzf
    if type -q fzf
        set -gx FZF_DEFAULT_OPTS "--layout=reverse"
        fzf --fish | source
    end

    #;;; zoxide
    if type -q zoxide
        zoxide init fish | source
    end

    #;;; direnv
    if type -q direnv
        direnv hook fish | source
    end

    #;;; uv
    if type -q uv
        uv generate-shell-completion fish | source
    end

    #;;; mise
    if type -q mise
        source $(mise activate fish | psub)
    end

    #;;; Haskell
    #;; ghcup
    set -gx PATH "$HOME/.ghcup/bin" $PATH
    set -gx PATH "$HOME/.cabal/bin" $PATH

    #;;; Golang
    set -gx PATH "$HOME/go/bin" $PATH

    #;;; Rust
    set -gx PATH "$HOME/.cargo/bin" $PATH

    #;;; Bun
    set -gx BUN_INSTALL "$HOME/.bun"
    set -gx PATH "$BUN_INSTALL/bin" $PATH

    #;;; Lean 4
    set -gx PATH "$HOME/.elan/bin" $PATH

    #;;; F#
    set -gx PATH "$HOME/.dotnet/tools" $PATH

    #;;; Ocaml
    if test -r "$HOME/.opam/opam-init/init.fish"
        source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null
    end

    #;;; Dart/Flutter
    #;; Flutter
    set -gx PATH "$HOME/.pub-cache/bin" $PATH
    set -gx PATH "$HOME/fvm/default/bin" $PATH

    #;; adbなどのコマンドを使えるようにする
    switch $(uname)
        case Darwin
            if test -d "$HOME/Library/Android/sdk/platform-tools"
                set -gx PATH "$HOME/Library/Android/sdk/platform-tools" $PATH
            end
    end

    #;;; Android emulator
    switch $(uname)
        case Darwin
            if test -d "$HOME/Library/Android/sdk/emulator"
                set -gx PATH "$HOME/Library/Android/sdk/emulator" $PATH
            end
    end

    #;;; Inkscape command
    switch $(uname)
        case Darwin
            if test -d "/Applications/Inkscape.app/Contents/MacOS"
                set -gx PATH "/Applications/Inkscape.app/Contents/MacOS" $PATH
            end
    end

    #;;; MySQL
    if test -d /opt/homebrew/opt/mysql-client
        set -gx PATH /opt/homebrew/opt/mysql-client/bin $PATH
    end

    #;;; Google Cloud SDK
    if test -d "$HOME/.local/google-cloud-sdk/bin"
        set -gx PATH "$HOME/.local/google-cloud-sdk/bin" $PATH
    end

    if test -f "$HOME/.google-cloud-sdk/path.fish.inc"
        source "$HOME/.google-cloud-sdk/path.fish.inc"
    end

    #;;; Rancher Desktop
    set -gx PATH "$HOME/.rd/bin" $PATH
end

if test -f $(status dirname)/local_config.fish
    source $(status dirname)/local_config.fish
end
