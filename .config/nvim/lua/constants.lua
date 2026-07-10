-- ファイル間で共有される定数。他モジュールに依存しない純データのみを置く
local M = {}

-- Claude Code の起動コマンド
-- kocmd (plugins.lua) が terminal を開くのに使い、
-- config/claude.lua が terminal buffer 名 (term://...:claude) のマッチにも使う
M.claude_cmd = "claude"

-- Claude Code の応答完了マークを受け渡す tab variable 名
-- 書く側: config/claude.lua / 読む側: bufferline の tabline (plugins.lua)
M.claude_pending_tabvar = "claude_pending"

return M
