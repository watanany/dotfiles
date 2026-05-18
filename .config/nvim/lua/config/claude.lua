vim.api.nvim_create_autocmd("TabEnter", {
  group = vim.api.nvim_create_augroup("ClaudeCode", { clear = true }),
  callback = function()
    vim.fn.settabvar(vim.fn.tabpagenr(), "claude_pending", 0)
    vim.cmd("redrawtabline")
  end,
})

-- Claude Code の Stop フックから呼ばれる。
-- terminal buffer 名で claude を探し、そのタブ番号を通知に含める。
function _G.claude_notify_done()
  local tabnr
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("term://") and name:match("claude") then
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
  vim.fn.settabvar(tabnr, "claude_pending", 1)
  vim.cmd("redrawtabline")
  vim.notify(
    "応答完了\nTab " .. tabnr .. "  →  SPC <Tab>" .. tabnr,
    vim.log.levels.INFO,
    { title = "Claude Code" }
  )
end
