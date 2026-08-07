----------------------------------------------------------------------
-- augroup / autocmd
----------------------------------------------------------------------
-- Yank時にハイライトを行う
vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = "50",
    }
  end,
})

-- 行末の空白を削除する手動実行用コマンド(text や markdown でも使える)
vim.api.nvim_create_user_command("TrimWhitespace", require("utils").trim_whitespace, {})

-- 保存時に行末の空白を削除する(text や markdown ファイルは削除しない)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local ignored_fts = { "text", "markdown" }
    if not vim.tbl_contains(ignored_fts, vim.bo.filetype) then
      require("utils").trim_whitespace()
    end
  end,
})

-- ターミナルを開いた時にinsertモードを開始する
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "",
  command = "startinsert",
})

-- ターミナルを開いた時に行番号を非表示にする
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "",
  command = "setlocal nonumber norelativenumber",
})

-- ターミナルのバッファを離れた時にinsertモードを終了する
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "term://*",
  command = "stopinsert",
})

-- *.digはYAMLとして扱う
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.dig",
  command = "setf yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local success, result = pcall(vim.treesitter.start)
    if success then
      vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end
  end,
})

-- 開発用
-- vim.api.nvim_create_autocmd("DirChanged", {
--   pattern = "",
--   callback = function()
--     print(string.format("[DEBUG-DEBUG-DEBUG] CWD = %s", vim.fn.getcwd()))
--   end,
-- })
