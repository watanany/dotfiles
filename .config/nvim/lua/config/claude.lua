local constants = require("constants")

vim.api.nvim_create_autocmd("TabEnter", {
  group = vim.api.nvim_create_augroup("ClaudeCode", { clear = true }),
  callback = function()
    vim.fn.settabvar(vim.fn.tabpagenr(), constants.claude_pending_tabvar, 0)
    vim.cmd("redrawtabline")
  end,
})

