----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
local schemastore = require("schemastore")

vim.lsp.config("lua_ls", {
  -- "folke/neodev.nvim"
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      venvPath = ".",
      pythonPath = ".venv/bin/python",
      analysis = {
        extraPaths = { "." },
      },
    },
  },
})

vim.lsp.config('ty', {
  settings = {
    ty = {
    }
  }
})

vim.lsp.config("ruby_lsp", {})

vim.lsp.config("ts_ls", {
  filetypes = {
    -- "javascript",
    -- "javascriptreact",
    -- "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
})

vim.lsp.config("gopls", {})

vim.lsp.config("terraformls", {})

-- haskell-tools.nvimで代用するのでコメントアウト
-- vim.lsp.config("hie", {}

vim.lsp.config("dhall_lsp_server", {})

vim.lsp.config("nil_ls", {})

vim.lsp.config("purescriptls", {
  settings = {
    purescript = {
      addSpagoSources = true -- e.g. any purescript language-server config here
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {}
  }
})

vim.lsp.config("fsautocomplete", {})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        -- b0o/schemastore.nvimを使うため
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = schemastore.yaml.schemas(),
      -- format = { enable = true },
      completion = true,
      hover = true,
      validate = true,
    },
  },
})

vim.lsp.config("dbt-lsp", {
  filetypes = { "sql", "yaml", "jinja" },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { "dbt_project.yml", })
    if root then
      on_dir(root)
    end
  end,

  cmd = function(dispatchers, config)
    -- VSCodeのdbtプラグインを入れると暗黙的にインストールされるdbt-lspへのシンボリックリンク
    -- <https://zenn.dev/myshmeh/articles/37480d3a85e87e#dbt-fusion%E3%81%A8%E8%A8%80%E8%AA%9E%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC>
    local lsp_path = vim.fn.expand("~/.local/bin/dbt-lsp")

    -- --project-dir == --profiles-dir になるように設定
    return vim.lsp.rpc.start({
      lsp_path,
      "--project-dir", config.root_dir,
      "--profiles-dir", config.root_dir,
    }, dispatchers)
  end,
})

vim.lsp.enable({
  "lua_ls",
  -- "pyright",
  "ty",
  "ruby_lsp",
  "ts_ls",
  "gopls",
  "terraformls",
  "dhall_lsp_server",
  "nil_ls",
  "purescriptls",
  "rust_analyzer",
  "fsautocomplete",
  "yamlls",
  "dbt-lsp",
})

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { noremap = true, silent = true })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { noremap = true, silent = true })
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


