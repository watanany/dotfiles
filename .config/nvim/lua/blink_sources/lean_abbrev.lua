-- Lean の Unicode 略語(\vdash → ⊢)を blink.cmp の候補として出す。
-- 展開自体は lean.nvim が担当し、ここは候補表示だけを受け持つ
local constants = require("constants")

local M = {}

local ABBR_NS = vim.api.nvim_create_namespace("lean.abbreviations")

local cache = { leader = nil, entries = nil }

local function leader()
  local ok, config = pcall(require, "lean.config")
  return ok and config().abbreviations.leader or "\\"
end

local function escape_snippet(text)
  return (text:gsub("[\\$}]", "\\%0"))
end

-- lean.nvim の load() は debug.getinfo(2) つまり呼び出し元のディレクトリを基準に
-- JSON を探すため、外部から直接呼ぶと失敗する。lean.nvim 内部で load() を通る
-- reverse_lookup を先に叩いてメモ化させる
local function load_abbreviations()
  local abbreviations = require("lean.abbreviations")
  pcall(abbreviations.reverse_lookup, "")
  return abbreviations.load()
end

local function entries()
  local lead = leader()
  if cache.entries and cache.leader == lead then
    return cache.entries
  end

  local extra = require("lean.config")().abbreviations.extra or {}
  local all = vim.tbl_extend("force", load_abbreviations(), extra)

  local built = {}
  for key, value in pairs(all) do
    local new_text, format
    local head, tail = value:match("^(.-)%$CURSOR(.*)$")
    if head then
      new_text = escape_snippet(head) .. "$0" .. escape_snippet(tail)
      format = vim.lsp.protocol.InsertTextFormat.Snippet
    else
      new_text = value
      format = vim.lsp.protocol.InsertTextFormat.PlainText
    end

    built[#built + 1] = {
      label = lead .. key,
      filter_text = lead .. key,
      description = (value:gsub("%$CURSOR", "")),
      new_text = new_text,
      insert_text_format = format,
    }
  end

  cache.leader, cache.entries = lead, built
  return built
end

-- 未確定の略語の開始桁(0 始まり)。lean.nvim の extmark を使い、
-- 無ければ行を遡って leader を探す
local function abbrev_start_col(ctx)
  local abbreviations = package.loaded["lean.abbreviations"]
  local mark = abbreviations and abbreviations.abbr_mark
  if mark then
    local row, col = unpack(vim.api.nvim_buf_get_extmark_by_id(ctx.bufnr, ABBR_NS, mark, {}))
    if row == ctx.cursor[1] - 1 and col and col < ctx.cursor[2] then
      return col
    end
  end

  local lead = leader()
  local before = ctx.line:sub(1, ctx.cursor[2])
  for i = #before, 1, -1 do
    if before:sub(i, i):match("%s") then
      break
    end
    if before:sub(i, i + #lead - 1) == lead then
      return i - 1
    end
  end
end

-- 確定した時点で略語は完成しているので、lean.nvim の未確定マークと
-- それに伴う <CR>/<Tab> の一時マッピングを戻す
local function clear_abbr_mark()
  local abbreviations = package.loaded["lean.abbreviations"]
  if not (abbreviations and abbreviations.abbr_mark) then
    return
  end
  pcall(vim.api.nvim_buf_del_extmark, 0, ABBR_NS, abbreviations.abbr_mark)
  abbreviations.abbr_mark = nil
  if vim.b.cleanup_imaps then
    vim.b.cleanup_imaps()
  end
end

function M.new()
  return setmetatable({}, { __index = M })
end

function M:enabled()
  return vim.tbl_contains(constants.lean_abbrev_filetypes, vim.bo.filetype)
end

function M:get_trigger_characters()
  return { leader() }
end

function M:get_completions(ctx, callback)
  local start_col = abbrev_start_col(ctx)
  if not start_col then
    callback({ is_incomplete_forward = false, is_incomplete_backward = true, items = {} })
    return
  end

  -- 置換範囲は全候補で共通。blink は適用前に deepcopy するので共有してよい
  local range = {
    start = { line = ctx.cursor[1] - 1, character = start_col },
    ["end"] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
  }

  local items = {}
  for i, entry in ipairs(entries()) do
    items[i] = {
      label = entry.label,
      filterText = entry.filter_text,
      labelDetails = { description = entry.description },
      kind = vim.lsp.protocol.CompletionItemKind.Text,
      insertTextFormat = entry.insert_text_format,
      textEdit = { newText = entry.new_text, range = range },
    }
  end

  callback({ is_incomplete_forward = false, is_incomplete_backward = true, items = items })
end

function M:execute(_ctx, _item, callback, default_implementation)
  default_implementation()
  clear_abbr_mark()
  callback()
end

return M
