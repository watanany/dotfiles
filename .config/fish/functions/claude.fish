# 社内向けの autoMode 設定は公開 dotfiles に置けないため、dotfiles 外のファイルを --settings で渡す
# (autoMode はプロジェクトの settings からは読まれない)
# cf. <https://code.claude.com/docs/en/auto-mode-config>
function claude --wraps claude
    set -l private_settings ~/.claude/private-settings.json
    if test -f $private_settings
        command claude --settings $private_settings $argv
    else
        command claude $argv
    end
end
