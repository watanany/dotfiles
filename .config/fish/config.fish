if status is-interactive
    set -gx FZF_DEFAULT_OPTS "--layout=reverse"

    set -gx PATH "$HOME/.emacs.d/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.git-subcommands" $PATH
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
    switch (uname)
        case Darwin
            set -gx PATH "$HOME/Library/Android/sdk/platform-tools" $PATH
    end

    #;;; Android emulator
    switch (uname)
        case Darwin
            set -gx PATH "$HOME/Library/Android/sdk/emulator" $PATH
    end

    #;;; Inkscape command
    switch (uname)
        case Darwin
            set -gx PATH "/Applications/Inkscape.app/Contents/MacOS" $PATH
    end

    #;;; GNU tools
    switch (uname)
        case Darwin
            set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
            set -gx PATH /usr/local/opt/findutils/libexec/gnubin $PATH
            set -gx PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH
            set -gx PATH /usr/local/opt/gnu-tar/libexec/gnubin $PATH
            set -gx PATH /usr/local/opt/grep/libexec/gnubin $PATH
            set -gx MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH
            set -gx MANPATH /usr/local/opt/findutils/libexec/gnuman $MANPATH
            set -gx MANPATH /usr/local/opt/gnu-sed/libexec/gnuman $MANPATH
            set -gx MANPATH /usr/local/opt/gnu-tar/libexec/gnuman $MANPATH
            set -gx MANPATH /usr/local/opt/grep/libexec/gnuman $MANPATH
    end

    #;;; Google Cloud SDK
    set -gx PATH "$HOME/.local/google-cloud-sdk/bin" $PATH
    set -gx GOOGLE_APPLICATION_CREDENTIALS "$HOME/.local/library-164912-e95e373384ca.json"
end

if test -f "$(status dirname)/local_config.fish"
    source "$(status dirname)/local_config.fish"
end
