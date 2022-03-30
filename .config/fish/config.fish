if status is-interactive
    # Commands to run in interactive sessions can go here
    export FZF_DEFAULT_OPTS='--layout=reverse'

    set -gx PATH "$HOME/.emacs.d/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
end

if test -f "$(status dirname)/local_config.fish"
    source "$(status dirname)/local_config.fish"
end
