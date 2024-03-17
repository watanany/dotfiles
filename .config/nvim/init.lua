require("plugins")

-- プラグイン管理ファイルに書き込みが行われた場合、PackerCompileを行うようにする
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

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
-- ステータスラインを2行にする
vim.o.cmdheight = 2
-- カーソル移動の動作を変更
vim.o.whichwrap = "b,s,h,l,<,>,[,]"
-- ファイルを閉じてもundoできるようにする
vim.opt.undofile = true
-- クリップボードを設定する
vim.opt.clipboard:append("unnamedplus")
-- :mksession時に絶対パスで保存するように強制する(curdir,sesdirを削除)
-- cf. <https://www.reddit.com/r/vim/comments/adtnfv/comment/edk34ky/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>
vim.o.sessionoptions = "blank,buffers,folds,help,tabpages,winsize,terminal"
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

-- カラースキームの設定
vim.cmd [[
  try
    set background=dark
    colorscheme hybrid
  catch /E185/
    echo 'カラースキーム「hybrid」がインストールされていません。'
  endtry
]]


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
vim.keymap.set("n", "<Space>ot", (function() vim.cmd("TabToggleTerm!") end), { noremap = true, silent = true })
vim.keymap.set("n", "<Space>oT", (function() vim.cmd("term") end), { noremap = true, silent = true })

-- :PackerSync
vim.keymap.set("n", "<Space>hrr", (function() require("packer").sync() end), { noremap = true, silent = true })

-- 各種設定のトグル
vim.keymap.set("n", "Tl", (function() vim.wo.list = not vim.wo.list end), { noremap = true, silent = true })
vim.keymap.set("n", "Tn", (function() vim.wo.number = not vim.wo.number end), { noremap = true, silent = true })
vim.keymap.set("n", "Tw", (function() vim.wo.wrap = not vim.wo.wrap end), { noremap = true, silent = true })
vim.keymap.set("n", "Tp", (function() vim.o.paste = not vim.o.paste end), { noremap = true, silent = true })

-- タブ関連
vim.keymap.set("n", "<Space><Tab>n", ":tablast | tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space><Tab>d", ":tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space><Tab>[", ":tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space><Tab>]", ":tabnext<CR>", { noremap = true, silent = true })

for i = 1, 9 do
  local key = string.format("<Space><Tab>%d", i)
  local cmd = string.format(":tabnext %d<CR>", i)
  vim.keymap.set("n", key, cmd, { noremap = true, silent = true })
end

-- neogit
-- vim.keymap.set("n", "<Space>gg", require("neogit").open, { noremap = true, silent = true })


----------------------------------------------------------------------
-- Telescope
----------------------------------------------------------------------
-- Fernのキーバインドを設定する
vim.keymap.set("n", "<Space>ft", ":Fern . -drawer<CR>", { noremap = true, silent = true })

-- Telescopeの設定を行う
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")

telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        { path = "~/dotfiles", max_depth = 1 },
        { path = "~/sanctum/org", max_depth = 1 },
        { path = "~/sanctum/chatgpt-logs", max_depth = 1 },
        { path = "~/sanctum/projects", max_depth = 2 },
      },
      order_by = "asc",
      hidden_files = true,
      cd_scope = { "tab" },
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

local function live_grep(params)
  params = params or {}
  params["hidden"] = true
  telescope_builtin.live_grep(params)
end

local function find_configs()
  telescope_builtin.git_files({ cwd = "~/dotfiles", hidden = true })
end

vim.keymap.set("n", "<Space>ff", find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>pf", git_files, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fp", find_configs, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fs", live_grep, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>sp", live_grep, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fb", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>bB", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fh", telescope_builtin.help_tags, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>pp", telescope.extensions.project.project, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>pP", telescope.extensions.projects.projects, { noremap = true, silent = true })
-- vim.keymap.set("n", "<Space>fr", telescope.extensions.recent_files.pick, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fr", ":Telescope frecency<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fR", ":Telescope frecency workspace=CWD<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<Space>fd",
  function() find_files({ cwd = vim.fn.expand("%:h") }) end,
  { noremap = true, silent = true }
)
vim.keymap.set("n", "<Space>sd",
  function() live_grep({ cwd = vim.fn.expand("%:h") }) end,
  { noremap = true, silent = true }
)


----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup {
  -- "folke/neodev.nvim"
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

lspconfig.pyright.setup {
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

lspconfig.ruby_ls.setup {}

lspconfig.tsserver.setup {
  -- cf. <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver>
  filetypes = {
    -- "javascript",
    -- "javascriptreact",
    -- "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
}

lspconfig.gopls.setup {}

lspconfig.terraformls.setup {}

-- lspconfig["hie"].setup {}

lspconfig.purescriptls.setup {
  settings = {
    purescript = {
      addSpagoSources = true -- e.g. any purescript language-server config here
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

-- lspconfig["rust_analyzer"].setup {
--   -- Server-specific settings...
--   settings = {
--     ["rust-analyzer"] = {}
--   }
-- }

vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

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
    vim.keymap.set("n", "<Space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<Space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<Space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<Space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<Space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<Space>F", function()
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
}


----------------------------------------------------------------------
-- nvim-treesitter
----------------------------------------------------------------------
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query",
    "json", "yaml", "toml", "bash", "fish", "dockerfile",
    "hcl", "terraform",
    "python", "ruby", "go", "haskell", "rust",
    "typescript", "javascript", "tsx", "html", "css", "tsx",
    "org", "norg",
  },
  highlight = {
    enable = true,
    disable = { "markdown" },
  },
  indent = {
    enable = true,
  },

  -- RRethy/nvim-treesitter-endwise
  endwise = {
    enable = true,
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
  command = ":%s/\\s\\+$//e",
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
autocmd("DirChanged", {
  pattern = "",
  callback = function()
    print(string.format("[DEBUG-DEBUG-DEBUG] CWD = %s", vim.fn.getcwd()))
  end,
})


----------------------------------------------------------------------
-- which-key
----------------------------------------------------------------------
local which_key_map = {
  ["<Space>ot"] = "ターミナルをトグルする",
  ["<Space>oT"] = "ターミナルを開く",

  ["<Space>hrr"] = ":PackerSync",

  ["Tl"] = "不可視文字を表示をトグルする",
  ["Tn"] = "行番号の表示をトグルする",
  ["Tw"] = "折り返しをトグルする",
  ["Tp"] = "ペーストモードをトグルする",

  ["<Space><Tab>n"] = "タブを作成する",
  ["<Space><Tab>d"] = "タブを削除する",
  ["<Space><Tab>["] = "タブを一つ前に移動する",
  ["<Space><Tab>]"] = "タブを一つ後に移動する",

  ["<Space>gg"] = "Neogitを開く",

  ["<Space>ft"] = "ファイルツリーを開く",
  ["<Space>pp"] = "プロジェクトを開く",
  ["<Space>pf"] = "ファイル名で検索する",
  ["<Space>ff"] = "ファイル名で検索する",
  ["<Space>fp"] = "dotfilesを検索する",
  ["<Space>fr"] = "最近開いたファイルで検索する",
  ["<Space>fR"] = "最近開いたファイルで検索する(workspace=CWD)",
  ["<Space>fs"] = "ファイル内の文字列を検索する",
  ["<Space>sp"] = "ファイル内の文字列を検索する",
  ["<Space>fb"] = "バッファ一覧を表示する",
  ["<Space>bB"] = "バッファ一覧を表示する",
  ["<Space>fh"] = "ヘルプを表示する",
  ["<Space>fd"] = "ファイル名で検索する(cwd=%:h)",
  ["<Space>sd"] = "ファイル内の文字列を検索する(cwd=%:h)",

  ["[d"] = "一つ前の診断に戻る",
  ["]d"] = "一つ後の診断に進む",
  ["<Space>q"] = "フローティングウィンドウにカーソルの下にあるシンボルに関する情報を表示します。2回呼び出すと、フローティング ウィンドウにジャンプします。",
  ["gD"] = "宣言にジャンプする",
  ["gd"] = "定義にジャンプする",
  ["K"] = "ホバーを表示する",
  ["gi"] = "実装にジャンプする",
  ["<C-k>"] = "シグネチャヘルプを表示する",
  ["<Space>wa"] = "ワークスペースにフォルダを追加する",
  ["<Space>wr"] = "ワークスペースからフォルダを削除する",
  ["<Space>wl"] = "ワークスペースのフォルダを表示する",
  ["<Space>D"] = "型定義にジャンプする",
  ["<Space>rn"] = "変数名を変更する",
  ["<Space>ca"] = "現在のカーソル位置で利用可能なコードアクションを選択する",
  ["gr"] = "リファレンス一覧を表示する",
  ["<Space>F"] = "バッファ内のコードをフォーマットする",
}

for i = 1, 9 do
  local key = string.format("<Space><Tab>%d", i)
  local desc = string.format("タブ[%d]に移動する", i)
  which_key_map[key] = desc
end

require("which-key").register(which_key_map)
