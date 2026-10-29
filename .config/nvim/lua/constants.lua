-- ファイル間で共有される定数。他モジュールに依存しない純データのみを置く
local M = {}

-- Lean の Unicode 略語(\vdash → ⊢)を有効にする filetype
-- 使う側: plugins.lua / blink_sources/lean_abbrev.lua
M.lean_abbrev_filetypes = {
  "lean",
  "markdown",
  "text",
  "norg",
}

return M
