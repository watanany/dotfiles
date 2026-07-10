local constants = require("constants")

vim.api.nvim_create_autocmd("TabEnter", {
  group = vim.api.nvim_create_augroup("ClaudeCode", { clear = true }),
  callback = function()
    vim.fn.settabvar(vim.fn.tabpagenr(), constants.claude_pending_tabvar, 0)
    vim.cmd("redrawtabline")
  end,
})

-- Claude Code の Stop フックから呼ばれる。
-- cwd で terminal buffer を絞り込んで、そのタブ番号を通知に含める。
-- 同一 cwd に複数 Claude タブがある場合は最初にヒットしたものを使う。
function _G.claude_notify_done(cwd)
  local tabnr
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("term://") and name:match(constants.claude_cmd)
        and (not cwd or cwd == "" or name:find(cwd, 1, true)) then
      local wins = vim.fn.win_findbuf(buf)
      if #wins > 0 then
        tabnr = vim.api.nvim_tabpage_get_number(
          vim.api.nvim_win_get_tabpage(wins[1])
        )
        break
      end
    end
  end
  tabnr = tabnr or vim.fn.tabpagenr()
  vim.fn.settabvar(tabnr, constants.claude_pending_tabvar, 1)
  vim.cmd("redrawtabline")
  vim.notify(
    "応答完了\nTab " .. tabnr .. "  →  SPC <Tab>" .. tabnr,
    vim.log.levels.INFO,
    { title = "Claude Code" }
  )
end
