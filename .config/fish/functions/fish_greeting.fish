# Greeting messageを変更する
# cf. <https://github.com/fish-shell/fish-shell/issues/2346#issuecomment-136361397>
function fish_greeting
    set_color normal
    echo
    set_color red
    echo -n "*"
    set_color normal
    echo -n " "
    set_color yellow
    echo -n "*"
    set_color normal
    echo -n " "
    set_color purple
    echo -n "*"
    set_color normal
    echo -n " "
    set_color cyan
    echo -n "*"
    set_color normal
    echo -n " "
    set_color normal
    echo -n "Hello World"
    set_color normal
    echo -n " "
    set_color red
    echo -n "*"
    set_color normal
    echo -n " "
    set_color yellow
    echo -n "*"
    set_color normal
    echo -n " "
    set_color purple
    echo -n "*"
    set_color normal
    echo -n " "
    set_color cyan
    echo -n "*"
    set_color normal
    echo -n " "
    set_color normal
    echo
    set_color normal
    echo
end
