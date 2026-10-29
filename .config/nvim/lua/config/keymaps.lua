----------------------------------------------------------------------
-- キーバインド
----------------------------------------------------------------------
-- w!! でスーパーユーザーとして保存(sudoが使える環境限定)
-- FIXME: 「:\w」でwhich-keyで候補が表示されてしまう
-- vim.keymap.set("c", "w!!", "!sudo tee % > /dev/null")

-- 入力モード中に素早くJJと入力した場合はESCとみなす
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- ESCを二回押すことでハイライトを消す
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })
-- 検索後にジャンプした際に検索単語を画面中央に持ってくる
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })
vim.keymap.set("n", "*", "*zz", { noremap = true, silent = true })
vim.keymap.set("n", "#", "#zz", { noremap = true, silent = true })
vim.keymap.set("n", "g*", "g*zz", { noremap = true, silent = true })
vim.keymap.set("n", "g#", "g#zz", { noremap = true, silent = true })
-- j, k, ↑, ↓での移動を加速する
vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", { silent = true })
vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", { silent = true })
vim.keymap.set("n", "<DOWN>", "<Plug>(accelerated_jk_gj)", { silent = true })
vim.keymap.set("n", "<UP>", "<Plug>(accelerated_jk_gk)", { silent = true })

-- /{pattern}の入力中は「/」をタイプすると自動で「\/」が入力されるようになる
vim.keymap.set("c", "/", function()
  return (vim.fn.getcmdtype() == "/") and "\\/" or "/"
end, { noremap = true, expr = true })

-- ?{pattern}の入力中は「?」をタイプすると自動で「\?」が入力されるようになる
vim.keymap.set("c", "?", function()
  return (vim.fn.getcmdtype() == "?") and "\\?" or "?"
end, { noremap = true, expr = true })

-- ターミナルで<Esc>か<C-[>を押した時にノーマルモードに戻る
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })
-- ターミナル上でvimを開いたときに不便なのでコメントアウト。代わりにjjをマッピングする。
-- vim.keymap.set("t", "jj", "<C-\\><C-n>", { noremap = true, silent = true })

----------------------------------------------------------------------
-- Emacs風のキーバインドを使用できるようにする
----------------------------------------------------------------------

vim.keymap.set("i", "<C-p>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-n>", "<Down>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true, silent = true })
vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true })
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
vim.keymap.set("i", "<C-a>", "<Home>", { noremap = true, silent = true })
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true })
vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
vim.keymap.set("i", "<C-d>", "<Del>", { noremap = true, silent = true })
vim.keymap.set("c", "<C-d>", "<Del>", { noremap = true })

-- Ctrl-k: カーソル位置から行末まで削除
-- `k`レジスタを使用する
local REG = "k"

vim.keymap.set("i", "<C-k>", function()
  -- unpackは非推奨で移行中
  -- TODO: neovimの使用するLuaのバージョンが5.2になったらtable.unpackを使うように変更する
  local unpack = table.unpack or unpack
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))

  local line = vim.api.nvim_get_current_line()
  local end_col = #line

  if col >= end_col then
    -- カーソルが行末にある場合は、改行をkレジスタに保存して次の行と結合
    vim.fn.setreg(REG, "\n", "c")
    vim.api.nvim_command("normal! J")
  else
    -- カーソル位置から行末までをkレジスタに保存して削除
    vim.fn.setreg(REG, line:sub(col + 1), "c")
    vim.api.nvim_set_current_line(line:sub(1, col))
  end
end, { noremap = true, silent = true })

vim.keymap.set("c", "<C-k>", function()
  -- カーソル位置から末尾までをkレジスタに保存して削除
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  vim.fn.setreg(REG, line:sub(pos), "c")
  vim.fn.setcmdline(line:sub(1, pos - 1), pos)
end, { noremap = true })

-- Ctrl-yで貼り付け
vim.keymap.set("i", "<C-y>", ("<C-r><C-o>%s"):format(REG), { noremap = true, silent = true })
vim.keymap.set("c", "<C-y>", ("<C-r>%s"):format(REG), { noremap = true })

-- ターミナルを開く
vim.keymap.set("n", "<Leader>oT", function() vim.cmd("term") end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>oC", function() require("claude-term").open() end, { noremap = true, silent = true })

-- Claude Code の会話は <Leader>a にまとめる。小文字は今のプロジェクト、大文字は全プロジェクト
-- 今のプロジェクトは、今のバッファの git root(terminal などでは cwd から探す)
-- この Neovim のバッファで動いている claude を出し、選んだもののウィンドウへ移る
vim.keymap.set("n", "<Leader>ab", function() require("claude-term").select({ open = true }) end, { noremap = true, silent = true })
-- 画面に出ていない、裏で動いている claude を出し、選んだものにつなぎ直す(:ClaudeAttach と同じ)
-- ab は画面に出ているものだけの一覧なので、混ぜずに分ける
vim.keymap.set("n", "<Leader>ad", function() require("claude-term").select({ detached = true }) end, { noremap = true, silent = true })
-- 会話の一覧から選んで resume する
vim.keymap.set("n", "<Leader>ac", function()
  require("claude-term").select({ root = vim.fs.root(0, ".git") or vim.fn.getcwd() })
end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>aC", function() require("claude-term").select() end, { noremap = true, silent = true })
-- 会話の中身を live grep して resume する。先頭に ? を付けて Enter を押すと、残りの文で AI 検索に切り替わる
vim.keymap.set("n", "<Leader>as", function()
  require("claude-history").search({ root = vim.fs.root(0, ".git") or vim.fn.getcwd() })
end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>aS", function() require("claude-history").search() end, { noremap = true, silent = true })
-- 比べる範囲(例: 59174430..HEAD)を入力して hunk diff を開く。空のまま Enter なら作業ツリーとの差分
vim.keymap.set("n", "<Leader>oH", function()
  vim.ui.input({ prompt = "hunk diff " }, function(target)
    if target == nil then return end
    vim.cmd("term hunk diff " .. target)
  end)
end, { noremap = true, silent = true })

-- 各種設定のトグル
vim.keymap.set("n", "<Leader>tl", function() vim.wo.list = not vim.wo.list end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tn", function() vim.wo.number = not vim.wo.number end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tw", function() vim.wo.wrap = not vim.wo.wrap end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tp", function() vim.o.paste = not vim.o.paste end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tb", function() vim.cmd("GitBlameToggle") end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tB", function() vim.cmd("BlameToggle") end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tmt", function() vim.cmd("TableModeToggle") end, { noremap = true, silent = true })

-- タブ関連
-- 新タブを開く際、キー入力時点のCWDを引き継ぐ
vim.keymap.set("n", "<Leader><Tab>n", function()
  local cwd = vim.fn.getcwd()
  vim.cmd("tablast | tabnew")
  vim.cmd("tcd " .. vim.fn.fnameescape(cwd))
end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Tab>d", ":tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Tab>[", ":tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Tab>]", ":tabnext<CR>", { noremap = true, silent = true })

for i = 1, 9 do
  local key = string.format("<Leader><Tab>%d", i)
  local cmd = string.format(":tabnext %d<CR>", i)
  vim.keymap.set("n", key, cmd, { noremap = true, silent = true })
end

-- messagesをバッファに表示する
vim.keymap.set("n", "<Leader>bM", function()
  require("bmessages").toggle({ split_type = "split" })
end, { noremap = true, silent = true })

-- ファイルパスをクリップボードにコピー(絶対パス)
vim.keymap.set("n", "<Leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied path" })
end, { noremap = true, silent = true })

-- 相対パス:行番号をクリップボードにコピー
vim.keymap.set("n", "<Leader>cl", function()
  local ref = "@" .. vim.fn.expand("%:.") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", ref)
  vim.notify(
    ref,
    vim.log.levels.INFO,
    { title = "Copied ref" }
  )
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "nx",
    false
  )

end, { noremap = true, silent = true })

vim.keymap.set("v", "<Leader>cl", function()
  local l1 = vim.fn.line("v")
  local l2 = vim.fn.line(".")
  local s, e = math.min(l1, l2), math.max(l1, l2)
  local ref = "@" .. vim.fn.expand("%:.") .. ":" .. s .. "-" .. e
  vim.fn.setreg("+", ref)
  vim.notify(
    ref,
    vim.log.levels.INFO,
    { title = "Copied ref" }
  )
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "nx",
    false
  )
end, { noremap = true, silent = true })

-- Terminal modeで<C-;>で<Esc>が伝わるようにする
vim.keymap.set('t', '<C-;>', '<Esc>', { noremap = true })


