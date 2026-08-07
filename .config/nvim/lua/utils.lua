local M = {}

-- 行末の空白を削除する(カーソル位置を保持)
function M.trim_whitespace()
  local view = vim.fn.winsaveview()
  vim.cmd [[ %s/\s\+$//e ]]
  vim.fn.winrestview(view)
end

return M
