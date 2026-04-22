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

-- 保存時に行末の空白を削除する
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "",
  callback = function()
    -- textやmarkdownファイルは削除しない
    local ignored_fts = { "text", "markdown" }
    local ignore_flag = false

    for _, v in ipairs(ignored_fts) do
      if vim.bo.filetype == v then
        ignore_flag = true
        break
      end
    end

    if not ignore_flag then
      vim.cmd [[ :%s/\s\+$//e ]]
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
