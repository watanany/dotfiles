local M = {}

--- lazyのインストールを行い、パスを設定する
function M.setup_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end

  vim.opt.rtp:prepend(lazypath)
end

--- notjedi/nvim-rooter.luaのローカル関数get_rootで引数にパスを指定できるようにしたもの
function M.get_root(path, opts)
  local patterns = opts and opts.patterns or { ".git", ".hg", ".svn" }

  local result = vim.fs.find(patterns, {
    upward = true,
    path = path,
  })

  local root = #result ~= 0 and vim.fs.dirname(result[1]) or nil
  return root
end

return M
