-- lazyのインストールを行い、パスを設定する
local function setup_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
end

setup_lazy()

-- NOTE: lazyをロードする前に設定する必要がある
-- <Leader>キーを設定
vim.g.mapleader = " "
-- <LocalLeader>キーを設定
vim.g.maplocalleader = ","

-- プラグインをロードする
require("lazy").setup("plugins", {
  dev = {
    path = "~/sanctum/projects",
  },
})

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


----------------------------------------------------------------------
-- キーバインド
----------------------------------------------------------------------
-- w!! でスーパーユーザーとして保存(sudoが使える環境限定)
-- FIXME: 「:\w」でwhich-keyで候補が表示されてしまう
-- vim.keymap.set("c", "w!!", "!sudo tee % > /dev/null")

-- 入力モード中に素早くJJと入力した場合はESCとみなす
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- ESCを二回押すことでハイライトを消す
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })
-- Shift + 矢印でウィンドウサイズを変更
vim.keymap.set("n", "<S-Left>", "<C-w><", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", "<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Up>", "<C-w>-", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>", "<C-w>+", { noremap = true, silent = true })
-- 検索後にジャンプした際に検索単語を画面中央に持ってくる
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })
vim.keymap.set("n", "*", "*zz", { noremap = true, silent = true })
vim.keymap.set("n", "#", "#zz", { noremap = true, silent = true })
vim.keymap.set("n", "g*", "g*zz", { noremap = true, silent = true })
vim.keymap.set("n", "g#", "g#zz", { noremap = true, silent = true })
-- j, k, ↑, ↓での移動を加速する
vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", { silent = true })
vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", { silent = true })
vim.keymap.set("n", "<DOWN>", "<Plug>(accelerated_jk_gj)", { silent = true })
vim.keymap.set("n", "<UP>", "<Plug>(accelerated_jk_gk)", { silent = true })

-- /{pattern}の入力中は「/」をタイプすると自動で「\/」が入力されるようになる
vim.keymap.set("c", "/", function()
  return (vim.fn.getcmdtype() == "/") and "\\/" or "/"
end, { noremap = true, expr = true })

-- ?{pattern}の入力中は「?」をタイプすると自動で「\?」が入力されるようになる
vim.keymap.set("c", "?", function()
  return (vim.fn.getcmdtype() == "?") and "\\?" or "?"
end, { noremap = true, expr = true })

-- ターミナルで<Esc>か<C-[>を押した時にノーマルモードに戻る
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Emacsのキーバインドを使用できるようにする

-- 現在のカーソル位置から行末までを削除する関数
local function kill_line()
  -- unpackは非推奨で移行中
  -- TODO: neovimの使用するLuaのバージョンが5.2になったらtable.unpackを使うように変更する
  local unpack = table.unpack or unpack
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))

  local line = vim.api.nvim_get_current_line()
  local end_col = #line

  if col >= end_col then
    -- カーソルが行末にある場合は、次の行と結合
    vim.api.nvim_command("normal! J")
  else
    -- カーソル位置から行末までを削除
    local new_line = line:sub(1, col)
    vim.api.nvim_set_current_line(new_line)
  end
end

vim.keymap.set("i", "<C-p>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-n>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Home>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-e>", "<End>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-d>", "<Del>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", kill_line, { noremap = true, silent = true })

vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true })
vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
vim.keymap.set("c", "<C-d>", "<Del>", { noremap = true })
-- TODO: kill_line for command mode

-- ターミナルを開く
vim.keymap.set("n", "<Leader>ot", (function() vim.cmd("TabToggleTerm!") end), { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>oT", (function() print('debug'); vim.cmd("term") end), { noremap = true, silent = true })

-- lazygit
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new {
  cmd = "lazygit",
  hidden = true,
  direction = "float",
}

local function lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set("n", "<Leader>oG", lazygit_toggle, { noremap = true, silent = true })


-- 各種設定のトグル
vim.keymap.set("n", "Tl", (function() vim.wo.list = not vim.wo.list end), { noremap = true, silent = true })
vim.keymap.set("n", "Tn", (function() vim.wo.number = not vim.wo.number end), { noremap = true, silent = true })
vim.keymap.set("n", "Tw", (function() vim.wo.wrap = not vim.wo.wrap end), { noremap = true, silent = true })
vim.keymap.set("n", "Tp", (function() vim.o.paste = not vim.o.paste end), { noremap = true, silent = true })

-- タブ関連
vim.keymap.set("n", "<Leader><Tab>n", ":tablast | tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Tab>d", ":tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Tab>[", ":tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader><Tab>]", ":tabnext<CR>", { noremap = true, silent = true })

for i = 1, 9 do
  local key = string.format("<Leader><Tab>%d", i)
  local cmd = string.format(":tabnext %d<CR>", i)
  vim.keymap.set("n", key, cmd, { noremap = true, silent = true })
end

-- messagesをバッファに表示する
vim.keymap.set("n", "<Leader>bM", function()
  require("bmessages").toggle({ split_type = "split" })
end, { noremap = true, silent = true })


----------------------------------------------------------------------
-- Telescope
----------------------------------------------------------------------
-- Fernのキーバインドを設定する
vim.keymap.set("n", "<Leader>ft", ":Fern . -drawer<CR>", { noremap = true, silent = true })

-- Telescopeの設定を行う
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")
local telescope_project_actions = require("telescope._extensions.project.actions")
local rooter = require("nvim-rooter")
local hidden_files = true

telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        { path = "~/dotfiles", max_depth = 1 },
        { path = "~/sanctum/org", max_depth = 1 },
        { path = "~/sanctum/projects", max_depth = 2 },
      },
      order_by = "asc",
      hidden_files = hidden_files,
      cd_scope = { "tab" },
    },
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
  defaults = {
    mappings = {
      i = {
        -- 最初のESCでTelescopeを閉じる
        -- cf. <https://www.reddit.com/r/neovim/comments/pzxw8h/telescope_quit_on_first_single_esc/>
        ["<Esc>"] = telescope_actions.close,

        ["<C-h>"] = "which_key",
        ["<C-;>"] = telescope_actions.close,
        ["<C-q>"] = telescope_actions.close,
      },
    },
  },
}

telescope.load_extension("project")
telescope.load_extension("fzf")

local function find_files(params)
  params = params or {}
  params["hidden"] = true
  telescope_builtin.find_files(params)
end

local function git_files(params)
  params = params or {}
  params["hidden"] = true
  telescope_builtin.git_files(params)
end

local function live_grep_files(params)
  params = params or {}
  params["hidden"] = true
  telescope_builtin.live_grep(params)
end

local function find_dotfiles()
  telescope_builtin.find_files({ cwd = "~/dotfiles", hidden = true })
end

local function find_project_files(params)
  params = params or {}
  params["hidden"] = true
  params["cwd"] = rooter.get_root()
  telescope_builtin.find_files(params)
end

local function live_grep_project_files(params)
  params = params or {}
  params["hidden"] = true
  params["cwd"] = rooter.get_root()
  telescope_builtin.live_grep(params)
end

vim.keymap.set("n", "<Leader>ff", find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>pf", find_project_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fp", find_dotfiles, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fs", live_grep_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>sp", live_grep_project_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fb", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>bB", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>bl", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fh", telescope_builtin.help_tags, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>pp", telescope.extensions.project.project, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>pP", telescope.extensions.projects.projects, { noremap = true, silent = true })
-- vim.keymap.set("n", "<Leader>fr", telescope.extensions.recent_files.pick, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fr", ":Telescope frecency<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fR", ":Telescope frecency workspace=CWD<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<Leader>fd",
  function() find_files({ cwd = vim.fn.expand("%:h") }) end,
  { noremap = true, silent = true }
)
vim.keymap.set("n", "<Leader>sd",
  function() live_grep_files({ cwd = vim.fn.expand("%:h") }) end,
  { noremap = true, silent = true }
)


----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
local lspconfig = require("lspconfig")

lspconfig["lua_ls"].setup {
  -- "folke/neodev.nvim"
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

lspconfig["pyright"].setup {
  settings = {
    python = {
      venvPath = ".",
      pythonPath = ".venv/bin/python",
      analysis = {
        extraPaths = { "." },
      },
    },
  },
}

lspconfig["ruby_lsp"].setup {}

lspconfig["ts_ls"].setup {
  filetypes = {
    -- "javascript",
    -- "javascriptreact",
    -- "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
}

lspconfig["gopls"].setup {}

lspconfig["terraformls"].setup {}

lspconfig["hie"].setup {}

lspconfig["purescriptls"].setup {
  settings = {
    purescript = {
      addSpagoSources = true -- e.g. any purescript language-server config here
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

lspconfig["rust_analyzer"].setup {
  settings = {
    ["rust-analyzer"] = {}
  }
}

lspconfig["fsautocomplete"].setup {}

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<Leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<Leader>F", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


----------------------------------------------------------------------
-- nvim-cmp
----------------------------------------------------------------------
local cmp = require("cmp")

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-q>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "copilot" },
    { name = "command" },
    { name = "calc" },
    { name = "nvim_lua" },
  },
  formatting = {
    format = require("lspkind").cmp_format {
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
      show_labelDetails = true,
    },
  },
}

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})


----------------------------------------------------------------------
-- nvim-treesitter
----------------------------------------------------------------------
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query",
    "json", "yaml", "toml", "bash", "fish",
    "markdown", "markdown_inline",
    "sql",
    "python", "ruby", "go", "haskell", "rust",
    "typescript",
    "dockerfile", "hcl", "terraform",
    "dhall",
  },

  modules = {},
  sync_install = false,
  auto_install = false,
  ignore_install = {},

  highlight = {
    enable = true,
    -- disable = { "markdown" },
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  -- RRethy/nvim-treesitter-endwise
  endwise = {
    enable = true,
  },

  -- nvim-treesitter/nvim-treesitter-textobjects
  -- <https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-select>
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- textobjects.scmで定義されているキャプチャグループを使える
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",

        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },

      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v',  -- charwise
        ['@function.outer'] = 'V',   -- linewise
        ['@class.outer'] = '<c-v>',  -- blockwise
      },
    },
  },
}


----------------------------------------------------------------------
-- augroup / autocmd
----------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Yank時にハイライトを行う
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = "50",
    }
  end,
})

-- 保存時に行末の空白を削除する
autocmd("BufWritePre", {
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
autocmd("TermOpen", {
  pattern = "",
  command = "startinsert",
})

-- ターミナルを開いた時に行番号を非表示にする
autocmd("TermOpen", {
  pattern = "",
  command = "setlocal nonumber norelativenumber",
})

-- ターミナルのバッファを離れた時にinsertモードを終了する
autocmd("BufLeave", {
  pattern = "term://*",
  command = "stopinsert",
})

-- *.digはYAMLとして扱う
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.dig",
  command = "setf yaml",
})

-- 開発用
-- autocmd("DirChanged", {
--   pattern = "",
--   callback = function()
--     print(string.format("[DEBUG-DEBUG-DEBUG] CWD = %s", vim.fn.getcwd()))
--   end,
-- })


----------------------------------------------------------------------
-- which-key
----------------------------------------------------------------------
-- local which_key_table = {
--   { "<Leader>ot", desc = "ターミナルをトグルする" },
--   { "<Leader>oT", "ターミナルを開く" },
--
--   { "Tl", desc = "不可視文字を表示をトグルする" },
--   { "Tn", desc = "行番号の表示をトグルする" },
--   { "Tw", desc = "折り返しをトグルする" },
--   { "Tp", desc = "ペーストモードをトグルする" },
--
--   { "<Leader><Tab>n", desc = "タブを作成する" },
--   { "<Leader><Tab>d", desc = "タブを削除する" },
--   { "<Leader><Tab>[", desc = "タブを一つ前に移動する" },
--   { "<Leader><Tab>]", desc = "タブを一つ後に移動する" },
--
--   { "<Leader>bM", desc = "messagesをバッファに表示する" },
--   { "<Leader>ft", desc = "ファイルツリーを開く" },
--   { "<Leader>pp", desc = "プロジェクトを開く" },
--   { "<Leader>pf", desc = "ファイル名で検索する" },
--   { "<Leader>ff", desc = "ファイル名で検索する" },
--   { "<Leader>fp", desc = "dotfilesを検索する" },
--   { "<Leader>fr", desc = "最近開いたファイルで検索する" },
--   { "<Leader>fR", desc = "最近開いたファイルで検索する(workspace=CWD)" },
--   { "<Leader>fs", desc = "ファイル内の文字列を検索する" },
--   { "<Leader>sp", desc = "ファイル内の文字列を検索する" },
--   { "<Leader>fb", desc = "バッファ一覧を表示する" },
--   { "<Leader>bB", desc = "バッファ一覧を表示する" },
--   { "<Leader>bl", desc = "バッファ一覧を表示する" },
--   { "<Leader>fh", desc = "ヘルプを表示する" },
--   { "<Leader>fd", desc = "ファイル名で検索する(cwd=%:h)" },
--   { "<Leader>sd", desc = "ファイル内の文字列を検索する(cwd=%:h)" },
--
--   { "[d", desc = "一つ前の診断に戻る" },
--   { "]d", desc = "一つ後の診断に進む" },
--   { "<Leader>q", desc = "フローティングウィンドウにカーソルの下にあるシンボルに関する情報を表示します。2回呼び出すと、フローティング ウィンドウにジャンプします。" },
--   { "gD", desc = "宣言にジャンプする" },
--   { "gd", desc = "定義にジャンプする" },
--   { "K", desc = "ホバーを表示する" },
--   { "gi", desc = "実装にジャンプする" },
--   { "<C-k>", desc = "シグネチャヘルプを表示する" },
--   { "<Leader>wa", desc = "ワークスペースにフォルダを追加する" },
--   { "<Leader>wr", desc = "ワークスペースからフォルダを削除する" },
--   { "<Leader>wl", desc = "ワークスペースのフォルダを表示する" },
--   { "<Leader>D", "型定義にジャンプする" },
--   { "<Leader>rn", desc = "変数名を変更する" },
--   { "<Leader>ca", desc = "現在のカーソル位置で利用可能なコードアクションを選択する" },
--   { "gr", desc = "リファレンス一覧を表示する" },
--   { "<Leader>F", desc = "バッファ内のコードをフォーマットする" },
-- }
--
-- for i = 1, 9 do
--   local key = string.format("<Leader><Tab>%d", i)
--   local desc = string.format("タブ[%d]に移動する", i)
--   table.insert(which_key_table, { key, desc = desc })
-- end
--
-- require("which-key").add(which_key_table)

