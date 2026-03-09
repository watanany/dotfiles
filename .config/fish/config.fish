if status is-interactive
    switch $(uname -s):$(uname -p)
        case "Darwin:arm"
            eval $(/opt/homebrew/bin/brew shellenv)
    end

    set -gx EDITOR nvim
    set -gx FZF_DEFAULT_OPTS "--layout=reverse"

    set -gx PATH "$HOME/.emacs.d/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.git-subcommands" $PATH

    if type -q uv
        uv generate-shell-completion fish | source
    end

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

    #;;; F#
    set -gx PATH "$HOME/.dotnet/tools" $PATH

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
    if type -q direnv
        direnv hook fish | source
    end

    #;;; Bun
    set -gx BUN_INSTALL "$HOME/.bun"
    set -gx PATH $BUN_INSTALL/bin $PATH

    #;;; Modular
    set -gx MODULAR_HOME "$HOME/.modular"
    set -gx PATH $MODULAR_HOME/pkg/packages.modular.com_mojo/bin $PATH

    #;;; Lean 4
    set -gx PATH $HOME/.elan/bin $PATH

    #;;; エイリアス
    alias mv="mv -i"
    alias cp="cp -i"
    alias curl='curl -sSL'
    alias ls="ls -F --color=auto"

    function cd
        builtin cd $argv && ls
    end

    source $(status dirname)/bind.fish

    #;;; fzf
    if type -q fzf
        fzf --fish | source
    end

    # BEGIN opam configuration
    # This is useful if you're using opam as it adds:
    #   - the correct directories to the PATH
    #   - auto-completion for the opam binary
    # This section can be safely removed at any time if needed.
    if test -r "$HOME/.opam/opam-init/init.fish"
        source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null
    end
    # END opam configuration

    alias fennel="rlwrap fennel"

    set -gx PATH "$HOME/.claude/local" $PATH
end

if test -f $(status dirname)/local_config.fish
    source $(status dirname)/local_config.fish
end


