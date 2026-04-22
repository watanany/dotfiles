require("config/keymaps0")
require("config/lazy")
require("config/options")
require("config/autocmds")
require("config/keymaps")
require("config/lsps")

----------------------------------------------------------------------
-- Telescope
----------------------------------------------------------------------
local function find_files(params)
  params = params or {}
  params["hidden"] = true
  require("telescope.builtin").find_files(params)
end

local function git_files(params)
  params = params or {}
  params["hidden"] = true
  require("telescope.builtin").git_files(params)
end

local function live_grep_files(params)
  params = params or {}
  params["hidden"] = true
  require("telescope.builtin").live_grep(params)
end

local function find_dotfiles(params)
  params = params or {}
  params["cwd"] = "~/dotfiles"
  require("telescope.builtin").find_files({ cwd = "~/dotfiles", hidden = true })
end

local function find_project_files(params)
  params = params or {}
  params["hidden"] = true
  params["cwd"] =  vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" })
  require("telescope.builtin").find_files(params)
end

local function live_grep_project_files(params)
  params = params or {}
  params["hidden"] = true
  params["cwd"] = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" })
  require("telescope.builtin").live_grep(params)
end

vim.keymap.set("n", "<Leader>ff", find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>pf", find_project_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fp", find_dotfiles, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fs", live_grep_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>sp", live_grep_project_files, { noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<Leader>fb",
  function() require("telescope.builtin").buffers() end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<Leader>bB", function() require("telescope.builtin").buffers() end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<Leader>bl",
  function() require("telescope.builtin").buffers() end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<Leader>fh",
  function() require("telescope.builtin").help_tags() end,
  { noremap = true, silent = true }
)

vim.keymap.set("n", "<Leader>fd",
  function() find_files({ cwd = vim.fn.expand("%:h") }) end,
  { noremap = true, silent = true }
)
vim.keymap.set("n", "<Leader>sd",
  function() live_grep_files({ cwd = vim.fn.expand("%:h") }) end,
  { noremap = true, silent = true }
)


----------------------------------------------------------------------
-- which-key
----------------------------------------------------------------------
-- local which_key_table = {
--   { "<Leader>ot", desc = "ターミナルをトグルする" },
--   { "<Leader>oT", "ターミナルを開く" },
--
--   { "<Leader>tl", desc = "不可視文字を表示をトグルする" },
--   { "<Leader>tn", desc = "行番号の表示をトグルする" },
--   { "<Leader>tw", desc = "折り返しをトグルする" },
--   { "<Leader>tp", desc = "ペーストモードをトグルする" },
--   { "<Leader>tb", desc = "GitBlameToggle" },
--   { "<Leader>tB", desc = "BlameToggle" },
--   { "<Leader>tmt", desc = "markdownのテーブルモードをトグルする" },
--
--   { "<Leader><Tab>n", desc = "タブを作成する" },
--   { "<Leader><Tab>d", desc = "タブを削除する" },
--   { "<Leader><Tab>[", desc = "タブを一つ前に移動する" },
--   { "<Leader><Tab>]", desc = "タブを一つ後に移動する" },
--
--   { "<Leader>bM", desc = "messagesをバッファに表示する" },
--   { "<Leader>ft", desc = "ファイルツリーを開く" },
--   { "<Leader>pp", desc = "プロジェクトを開く" },
--   { "<Leader>pf", desc = "ファイル名で検索する" },
--   { "<Leader>ff", desc = "ファイル名で検索する" },
--   { "<Leader>fp", desc = "dotfilesを検索する" },
--   { "<Leader>fr", desc = "最近開いたファイルで検索する" },
--   { "<Leader>fR", desc = "最近開いたファイルで検索する(workspace=CWD)" },
--   { "<Leader>fs", desc = "ファイル内の文字列を検索する" },
--   { "<Leader>sp", desc = "ファイル内の文字列を検索する" },
--   { "<Leader>fb", desc = "バッファ一覧を表示する" },
--   { "<Leader>bB", desc = "バッファ一覧を表示する" },
--   { "<Leader>bl", desc = "バッファ一覧を表示する" },
--   { "<Leader>fh", desc = "ヘルプを表示する" },
--   { "<Leader>fd", desc = "ファイル名で検索する(cwd=%:h)" },
--   { "<Leader>sd", desc = "ファイル内の文字列を検索する(cwd=%:h)" },
--
--   { "[d", desc = "一つ前の診断に戻る" },
--   { "]d", desc = "一つ後の診断に進む" },
--   { "<Leader>q", desc = "フローティングウィンドウにカーソルの下にあるシンボルに関する情報を表示します。2回呼び出すと、フローティング ウィンドウにジャンプします。" },
--   { "gD", desc = "宣言にジャンプする" },
--   { "gd", desc = "定義にジャンプする" },
--   { "K", desc = "ホバーを表示する" },
--   { "gi", desc = "実装にジャンプする" },
--   { "<C-k>", desc = "シグネチャヘルプを表示する" },
--   { "<Leader>wa", desc = "ワークスペースにフォルダを追加する" },
--   { "<Leader>wr", desc = "ワークスペースからフォルダを削除する" },
--   { "<Leader>wl", desc = "ワークスペースのフォルダを表示する" },
--   { "<Leader>D", "型定義にジャンプする" },
--   { "<Leader>rn", desc = "変数名を変更する" },
--   { "<Leader>ca", desc = "現在のカーソル位置で利用可能なコードアクションを選択する" },
--   { "gr", desc = "リファレンス一覧を表示する" },
--   { "<Leader>F", desc = "バッファ内のコードをフォーマットする" },
-- }
--
-- for i = 1, 9 do
--   local key = string.format("<Leader><Tab>%d", i)
--   local desc = string.format("タブ[%d]に移動する", i)
--   table.insert(which_key_table, { key, desc = desc })
-- end
--
-- require("which-key").add(which_key_table)

