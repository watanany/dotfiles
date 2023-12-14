-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/watanabe.s/.cache/nvim/packer_hererocks/2.1.1700008891/share/lua/5.1/?.lua;/Users/watanabe.s/.cache/nvim/packer_hererocks/2.1.1700008891/share/lua/5.1/?/init.lua;/Users/watanabe.s/.cache/nvim/packer_hererocks/2.1.1700008891/lib/luarocks/rocks-5.1/?.lua;/Users/watanabe.s/.cache/nvim/packer_hererocks/2.1.1700008891/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/watanabe.s/.cache/nvim/packer_hererocks/2.1.1700008891/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["accelerated-jk.nvim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/accelerated-jk.nvim",
    url = "https://github.com/rainbowhxch/accelerated-jk.nvim"
  },
  ["auto-session"] = {
    config = { "\27LJ\2\n{\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\31auto_session_suppress_dirs\1\2\0\0\a~/\1\0\1\14log_level\nerror\nsetup\17auto-session\frequire\0" },
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["clever-f.vim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/clever-f.vim",
    url = "https://github.com/rhysd/clever-f.vim"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["fern.vim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/fern.vim",
    url = "https://github.com/lambdalisue/fern.vim"
  },
  fzf = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  rainbow_csv = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/rainbow_csv",
    url = "https://github.com/mechatroner/rainbow_csv"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-recent-files"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17recent_files\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/telescope-recent-files",
    url = "https://github.com/smartpde/telescope-recent-files"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\nF\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tsize\3\20\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["vim-hy"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/vim-hy",
    url = "https://github.com/hylang/vim-hy"
  },
  ["vim-hybrid"] = {
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/vim-hybrid",
    url = "https://github.com/w0ng/vim-hybrid"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n\b\0\0\4\0\t\0\0186\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1,\1=\1\3\0006\0\4\0'\2\5\0B\0\2\0029\1\6\0004\3\0\0B\1\2\0019\1\a\0005\3\b\0B\1\2\1K\0\1\0\1\0\29\14<space>sp/ãã¡ã¤ã«åã®æå­åãæ¤ç´¢ãã\14<space>wl\5\14<space>ff#ãã¡ã¤ã«åã§æ¤ç´¢ãã\14<space>fb&ãããã¡ä¸è¦§ãè¡¨ç¤ºãã\14<space>fh\29ãã«ããè¡¨ç¤ºãã\14<space>pp ãã­ã¸ã§ã¯ããéã\agd å®ç¾©ã«ã¸ã£ã³ããã\n<C-k>\5\14<space>fr/æè¿éãããã¡ã¤ã«ã§æ¤ç´¢ãã\14<space>ot&ã¿ã¼ããã«ããã°ã«ãã\14<space>oT\29ã¿ã¼ããã«ãéã\6K\5\a]d ä¸ã¤å¾ã®è¨ºæ­ã«é²ã\14<space>gg\20Neogitãéã\a[d ä¸ã¤åã®è¨ºæ­ã«æ»ã\agD å®£è¨ã«ã¸ã£ã³ããã\r<space>e&ã¿ã¼ããã«ããã°ã«ãã\r<space>q\5\agi å®è£ã«ã¸ã£ã³ããã\14<space>wa\5\14<space>wr\5\14<space>ft#ãã¡ã¤ã«ããªã¼ãéã\r<space>D#åå®ç¾©ã«ã¸ã£ã³ããã\r<space>F;ãããã¡åã®ã³ã¼ãããã©ã¼ããããã\agr\5\14<space>ca\5\14<space>rn\29å¤æ°åãå¤æ´ãã\14<space>pf#ãã¡ã¤ã«åã§æ¤ç´¢ãã\14<space>fs/ãã¡ã¤ã«åã®æå­åãæ¤ç´¢ãã\rregister\nsetup\14which-key\frequire\15timeoutlen\ftimeout\6o\bvim\0" },
    loaded = true,
    path = "/Users/watanabe.s/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\nF\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tsize\3\20\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0", "config", "nvim-surround")
time([[Config for nvim-surround]], false)
-- Config for: telescope-recent-files
time([[Config for telescope-recent-files]], true)
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17recent_files\19load_extension\14telescope\frequire\0", "config", "telescope-recent-files")
time([[Config for telescope-recent-files]], false)
-- Config for: auto-session
time([[Config for auto-session]], true)
try_loadstring("\27LJ\2\n{\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\31auto_session_suppress_dirs\1\2\0\0\a~/\1\0\1\14log_level\nerror\nsetup\17auto-session\frequire\0", "config", "auto-session")
time([[Config for auto-session]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n\b\0\0\4\0\t\0\0186\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1,\1=\1\3\0006\0\4\0'\2\5\0B\0\2\0029\1\6\0004\3\0\0B\1\2\0019\1\a\0005\3\b\0B\1\2\1K\0\1\0\1\0\29\14<space>sp/ãã¡ã¤ã«åã®æå­åãæ¤ç´¢ãã\14<space>wl\5\14<space>ff#ãã¡ã¤ã«åã§æ¤ç´¢ãã\14<space>fb&ãããã¡ä¸è¦§ãè¡¨ç¤ºãã\14<space>fh\29ãã«ããè¡¨ç¤ºãã\14<space>pp ãã­ã¸ã§ã¯ããéã\agd å®ç¾©ã«ã¸ã£ã³ããã\n<C-k>\5\14<space>fr/æè¿éãããã¡ã¤ã«ã§æ¤ç´¢ãã\14<space>ot&ã¿ã¼ããã«ããã°ã«ãã\14<space>oT\29ã¿ã¼ããã«ãéã\6K\5\a]d ä¸ã¤å¾ã®è¨ºæ­ã«é²ã\14<space>gg\20Neogitãéã\a[d ä¸ã¤åã®è¨ºæ­ã«æ»ã\agD å®£è¨ã«ã¸ã£ã³ããã\r<space>e&ã¿ã¼ããã«ããã°ã«ãã\r<space>q\5\agi å®è£ã«ã¸ã£ã³ããã\14<space>wa\5\14<space>wr\5\14<space>ft#ãã¡ã¤ã«ããªã¼ãéã\r<space>D#åå®ç¾©ã«ã¸ã£ã³ããã\r<space>F;ãããã¡åã®ã³ã¼ãããã©ã¼ããããã\agr\5\14<space>ca\5\14<space>rn\29å¤æ°åãå¤æ´ãã\14<space>pf#ãã¡ã¤ã«åã§æ¤ç´¢ãã\14<space>fs/ãã¡ã¤ã«åã®æå­åãæ¤ç´¢ãã\rregister\nsetup\14which-key\frequire\15timeoutlen\ftimeout\6o\bvim\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
