-- インデントをTabではなくスペース2つで揃える
-- タブを画面で表示する際の幅(ts)
vim.opt_local.tabstop = 4
-- タブを挿入する際、半角スペースに変換(et)
vim.opt_local.expandtab = true
-- インデント時に使用されるスペースの数(sw)
vim.opt_local.shiftwidth = 4
-- タブ入力時その数値分だけ半角スペースを挿入する(sts)
vim.opt_local.softtabstop = 4

local ht = require('haskell-tools')
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr, }
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
-- Evaluate all code snippets
vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
-- Toggle a GHCi repl for the current package
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set('n', '<leader>rf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
