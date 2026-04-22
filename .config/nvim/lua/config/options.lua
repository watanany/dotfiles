-- Vimスクリプトで使用されるエンコード
vim.scriptencoding = "utf-8"
-- エディタ内部で使用されるエンコード
vim.o.encoding = "utf-8"
-- 現在のバッファのファイル内容のエンコード
vim.o.fileencoding = "utf-8"
-- 行番号を表示する
vim.o.number = true
-- スクロールする時に下が見えるようにする
vim.o.scrolloff = 5
-- .swapファイルを作らない
vim.o.swapfile = false
-- 不可視文字を表示
vim.o.list = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  extends = "»",
  precedes = "«",
  nbsp = "%",
  eol = "$",
}
-- 小文字の検索でも大文字も見つかるようにする
vim.o.ignorecase = true
-- ただし大文字も含めた検索の場合はその通りに検索する
vim.o.smartcase = true
-- ステータスラインを常に表示する
vim.o.laststatus = 2
-- コマンドラインの行数を設定する
vim.o.cmdheight = 1
-- カーソル移動の動作を変更
vim.o.whichwrap = "b,s,h,l,<,>,[,]"
-- ファイルを閉じてもundoできるようにする
vim.opt.undofile = true
-- クリップボードを設定する
vim.opt.clipboard:append("unnamedplus")
-- 行番号表示部分にサインを表示するようにする
vim.o.signcolumn = "number"
-- 折り畳みさせないようにする
vim.o.foldenable = false
-- インデントをTabではなくスペース2つで揃える
-- タブを画面で表示する際の幅(ts)
vim.o.tabstop = 2
-- タブを挿入する際、半角スペースに変換(et)
vim.o.expandtab = true
-- インデント時に使用されるスペースの数(sw)
vim.o.shiftwidth = 2
-- タブ入力時その数値分だけ半角スペースを挿入する(sts)
vim.o.softtabstop = 2


