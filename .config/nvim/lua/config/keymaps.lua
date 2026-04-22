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
-- Shift + 矢印でウィンドウサイズを変更
vim.keymap.set("n", "<S-Left>", "<C-w><", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", "<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Up>", "<C-w>-", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>", "<C-w>+", { noremap = true, silent = true })
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

-- Emacsのキーバインドを使用できるようにする

vim.keymap.set("i", "<C-p>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-n>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Home>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-d>", "<Del>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", function()
  -- unpackは非推奨で移行中
  -- TODO: neovimの使用するLuaのバージョンが5.2になったらtable.unpackを使うように変更する
  local unpack = table.unpack or unpack

  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  if col >= #line then
    vim.api.nvim_command("normal! J")
  else

  end
end, { noremap = true, silent = true })

vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true })
vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
vim.keymap.set("c", "<C-d>", "<Del>", { noremap = true })

vim.keymap.set("c", "<C-k>", function()
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  vim.fn.setcmdline(line:sub(1, pos - 1), pos)
end, { noremap = true })

-- ターミナルを開く
vim.keymap.set("n", "<Leader>oT", function() vim.cmd("term") end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>oC", function() vim.cmd("term claude") end, { noremap = true, silent = true })

-- 各種設定のトグル
vim.keymap.set("n", "<Leader>tl", function() vim.wo.list = not vim.wo.list end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tn", function() vim.wo.number = not vim.wo.number end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tw", function() vim.wo.wrap = not vim.wo.wrap end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tp", function() vim.o.paste = not vim.o.paste end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tb", function() vim.cmd("GitBlameToggle") end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tB", function() vim.cmd("BlameToggle") end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tmt", function() vim.cmd("TableModeToggle") end, { noremap = true, silent = true })

-- 通知履歴
vim.keymap.set("n", "<Leader>n", ":Telescope notify<CR>", { noremap = true, silent = true })

-- タブ関連
vim.keymap.set("n", "<Leader><Tab>n", ":tablast | tabnew<CR>", { noremap = true, silent = true })
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

-- ファイルパスをクリップボードにコピー（絶対パス）
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

