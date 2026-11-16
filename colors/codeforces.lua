-- Codeforces submission-view colorscheme.
--
-- Reproduces the stock CF "→ Source" block:
--   <pre id="program-source-text" class="prettyprint lang-cpp linenums program-source">
-- CF styles it with https://codeforces.org/s/*/css/prettify.css (NOT desert.css,
-- which is the userscript dark theme). The real palette is light:
--
--   .pln            #000                      plain text
--   .str  #080 bold  strings
--   .kwd  #008 bold  keywords
--   .com  #800 bold  comments (includes #include / #define lines)
--   .typ  #606 bold  type names
--   .lit  #066       numbers / literals
--   .pun  #660       punctuation and operators
--   .fun  red        function names (prettify never emits it for C++, see below)
--   pre.prettyprint 1px solid #888 border on CF's light page; the source panel
--   itself sits on .roundbox .dark = #F5F5F5 (roundbox.css), not pure white.
--   See bg = #F5F5F5 below.
--
-- Prettify's C++ lexer differs from treesitter in ways that matter, so the
-- links below deliberately deviate from the "obvious" mapping:
--   1. `int/long/bool/void/char/float/double` are C_KEYWORDS -> kwd (navy),
--      NOT type (purple). Same for `const/static/unsigned/signed/short`.
--   2. Only C_TYPES (vector, set/map, queue, stack, list, bitset, int32_t ...)
--      plus CamelCase identifiers and `foo_t` are typ (purple). NOT `pair`,
--      `string`, `greater`, or lower-case typedef aliases.
--   3. Function calls are pln (black) -- its C++ handler emits no .fun.
--   4. Macro names (#define MAXN -> `MAXN`) are pln black, not literal.
--   5. `#include` is part of a com (maroon) run, same as #define.
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "light"
vim.o.termguicolors = true
vim.g.colors_name = "codeforces"

-- Colors measured from a rendered codeforces.com submission page (screenshot
-- sampled), not from the CSS source -- the browser's rendering shifts the raw
-- CSS values slightly. CSS declared value in parentheses.
local c = {
  bg = "#eff0f1", -- CSS said #F5F5F5 / white, page renders #eff0f1
  fg = "#000000",
  kwd = "#000d86", -- CSS #008
  str = "#038716", -- CSS #080
  com = "#890003", -- CSS #800
  typ = "#660464", -- CSS #606
  lit = "#006666", -- CSS #066
  pun = "#67650f", -- CSS #660
  ln = "#888888",
  border = "#bbbbbb",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- UI ---------------------------------------------------------------------
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalNC", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.bg })
hi("FloatBorder", { fg = c.border, bg = c.bg })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = "#e4e5e7" })
hi("CursorColumn", { bg = "#e4e5e7" })
hi("ColorColumn", { bg = "#e4e5e7" })
hi("LineNr", { fg = c.ln })
hi("CursorLineNr", { fg = c.fg, bold = true })
hi("SignColumn", { bg = c.bg })
hi("FoldColumn", { fg = c.ln, bg = c.bg })
hi("Folded", { fg = c.fg, bg = "#dcdee0" })
hi("Visual", { fg = c.fg, bg = "#cce4ff" })
hi("Search", { fg = c.bg, bg = c.kwd })
hi("IncSearch", { fg = c.bg, bg = c.str })
hi("CurSearch", { link = "IncSearch" })
hi("MatchParen", { fg = c.fg, bold = true, underline = true })
hi("Pmenu", { fg = c.fg, bg = "#e6e8ea" })
hi("PmenuSel", { fg = c.bg, bg = c.kwd })
hi("PmenuSbar", { bg = "#e0e0e0" })
hi("PmenuThumb", { bg = c.ln })
hi("StatusLine", { fg = c.fg, bg = "#dcdee0" })
hi("StatusLineNC", { fg = c.ln, bg = "#e6e8ea" })
hi("VertSplit", { fg = c.border, bg = c.bg })
hi("WinSeparator", { link = "VertSplit" })
hi("TabLine", { fg = c.ln, bg = "#e6e8ea" })
hi("TabLineSel", { fg = c.fg, bg = c.bg })
hi("TabLineFill", { bg = "#e6e8ea" })
-- Without these, Neovim keeps its blue-tinted defaults (#eef1f8) and the
-- winbar/bufferline strip renders a different shade than the #f5f5f5 panel.
hi("WinBar", { fg = c.fg, bg = c.bg })
hi("WinBarNC", { fg = c.ln, bg = c.bg })
hi("BufferLineFill", { fg = c.ln, bg = "#e6e8ea" })
hi("BufferLineBackground", { fg = c.ln, bg = "#e6e8ea" })
hi("BufferLineTab", { fg = c.ln, bg = "#e6e8ea" })
hi("BufferLineTabSelected", { fg = c.fg, bg = c.bg })
hi("BufferLineBuffer", { fg = c.ln, bg = "#e6e8ea" })
hi("BufferLineBufferSelected", { fg = c.fg, bg = c.bg, bold = true })
hi("BufferLineBufferVisible", { fg = c.fg, bg = "#e6e8ea" })
hi("BufferLineSeparator", { fg = c.border, bg = "#e6e8ea" })
hi("BufferLineModified", { fg = c.com, bg = "#e6e8ea" })
hi("BufferLineCloseButton", { fg = c.ln, bg = "#e6e8ea" })
hi("NonText", { fg = "#bbbbbb" })
hi("SpecialKey", { fg = "#bbbbbb" })
hi("Whitespace", { fg = "#bbbbbb" })
hi("Directory", { fg = c.kwd })
hi("Title", { fg = c.kwd, bold = true })
hi("ErrorMsg", { fg = c.com, bold = true })
hi("WarningMsg", { fg = "#886600" })
hi("MoreMsg", { fg = c.str })
hi("Question", { fg = c.str })
hi("DiffAdd", { fg = c.fg, bg = "#ccffcc" })
hi("DiffChange", { fg = c.fg, bg = "#ffffcc" })
hi("DiffDelete", { fg = c.fg, bg = "#ffcccc" })
hi("DiffText", { fg = c.fg, bg = "#ccddff" })
hi("Added", { fg = c.str })
hi("Changed", { fg = "#886600" })
hi("Removed", { fg = c.com })
hi("DiagnosticError", { fg = c.com })
hi("DiagnosticWarn", { fg = "#886600" })
hi("DiagnosticInfo", { fg = c.kwd })
hi("DiagnosticHint", { fg = c.typ })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.com })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = "#886600" })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.kwd })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.typ })

-- Core syntax (legacy groupings, used when treesitter is off) --------------
hi("Comment", { fg = c.com, bold = true })
hi("Constant", { fg = c.lit })
hi("String", { fg = c.str, bold = true })
hi("Character", { fg = c.str, bold = true })
hi("Number", { fg = c.lit })
hi("Float", { fg = c.lit })
hi("Boolean", { fg = c.kwd, bold = true })
hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.fg }) -- prettify never colors C++ call sites
hi("Statement", { fg = c.kwd, bold = true })
hi("Keyword", { fg = c.kwd, bold = true })
hi("Conditional", { fg = c.kwd, bold = true })
hi("Repeat", { fg = c.kwd, bold = true })
hi("Label", { fg = c.kwd, bold = true })
hi("Exception", { fg = c.kwd, bold = true })
hi("Operator", { fg = c.pun })
hi("Delimiter", { fg = c.pun })
hi("Special", { fg = c.fg })
hi("SpecialChar", { fg = c.str })
hi("PreProc", { fg = c.com, bold = true })
hi("Include", { fg = c.com, bold = true })
hi("Define", { fg = c.com, bold = true })
hi("Macro", { fg = c.com, bold = true })
hi("PreCondit", { fg = c.com, bold = true })
hi("Type", { fg = c.typ, bold = true })
hi("StorageClass", { fg = c.kwd, bold = true })
hi("Structure", { fg = c.kwd, bold = true })
hi("Typedef", { fg = c.kwd, bold = true })
hi("Todo", { fg = c.kwd, bold = true })
hi("Error", { fg = c.com })
hi("Underlined", { underline = true })
hi("cBlock", { link = "Comment" })
hi("cCppString", { fg = c.str, bold = true })
hi("cppSTLnamespace", { fg = c.fg })
hi("cppModifier", { fg = c.kwd, bold = true })
hi("cppType", { fg = c.kwd, bold = true })
hi("cppStructure", { fg = c.kwd, bold = true })
hi("cppNumber", { fg = c.lit })

-- Treesitter ------------------------------------------------------------
-- leaves: token text stays black (pln) in CF
hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.fg })
hi("@variable.member", { fg = c.fg })
hi("@variable.parameter", { fg = c.fg })
hi("@property", { fg = c.fg })
-- calls: prettify paints them plain black, no .fun for C++
hi("@function", { fg = c.fg })
hi("@function.call", { fg = c.fg })
hi("@function.builtin", { fg = c.fg })
hi("@function.macro", { fg = c.fg })
hi("@function.method", { fg = c.fg })
hi("@function.method.call", { fg = c.fg })
hi("@constructor", { fg = c.fg })
hi("@module", { fg = c.fg })
hi("@namespace", { fg = c.fg })
hi("@label", { fg = c.fg })
-- keywords: navy + bold
hi("@keyword", { fg = c.kwd, bold = true })
hi("@keyword.type", { fg = c.kwd, bold = true })
hi("@keyword.modifier", { fg = c.kwd, bold = true })
hi("@keyword.operator", { fg = c.kwd, bold = true })
hi("@keyword.conditional", { fg = c.kwd, bold = true })
hi("@keyword.conditional.ternary", { fg = c.kwd, bold = true })
hi("@keyword.repeat", { fg = c.kwd, bold = true })
hi("@keyword.return", { fg = c.kwd, bold = true })
hi("@keyword.exception", { fg = c.kwd, bold = true })
hi("@keyword.coroutine", { fg = c.kwd, bold = true })
-- #include is lexed as part of the surrounding comment run (maroon)
hi("@keyword.import", { fg = c.com, bold = true })
hi("@keyword.directive", { fg = c.com, bold = true })
hi("@keyword.directive.define", { fg = c.com, bold = true })
-- types: purple -- only C_TYPES / CamelCase / _t
hi("@type", { fg = c.typ, bold = true })
hi("@type.definition", { fg = c.typ, bold = true })
hi("@attribute", { fg = c.typ, bold = true })
-- set by after/queries/cpp/highlights.scm for names outside prettify's C_TYPES
hi("@cf_plain", { fg = c.fg })
-- prettify checks its `types` regex BEFORE its `keywords` regex, and that
-- regex is `u?(int|float)\d*`, so exactly these match as typ (purple):
--   int float int8_t int16_t int32_t int64_t uint32_t uint64_t ufloat...
-- Everything else (short long char bool double void unsigned signed auto)
-- is NOT in C_TYPES and falls through to the C keyword list -> kwd (navy).
-- Verified against a rendered codeforces.com page: #660464 purple is a very
-- common color there (3735 sampled pixels) for exactly these tokens.
hi("@type.builtin", { fg = c.kwd, bold = true })
-- strings / chars / comments / numbers
hi("@string", { fg = c.str, bold = true })
hi("@string.escape", { fg = c.str })
hi("@character", { fg = c.str, bold = true })
hi("@comment", { fg = c.com, bold = true })
hi("@comment.documentation", { fg = c.com, bold = true })
hi("@number", { fg = c.lit })
hi("@number.float", { fg = c.lit })
hi("@boolean", { fg = c.kwd, bold = true })
-- `true`/`false`/`NULL`/`nullptr` are in prettify's keyword list
hi("@constant", { fg = c.fg })
hi("@constant.builtin", { fg = c.kwd, bold = true })
-- macro names (#define MAXN) stay plain black
hi("@constant.macro", { fg = c.fg })
hi("@operator", { fg = c.pun })
hi("@punctuation.bracket", { fg = c.pun })
hi("@punctuation.delimiter", { fg = c.pun })
hi("@punctuation.special", { fg = c.pun })
hi("@spell", {})

hi("@lsp.type.class", { fg = c.typ, bold = true })
hi("@lsp.type.struct", { fg = c.typ, bold = true })
hi("@lsp.type.enum", { fg = c.typ, bold = true })
hi("@lsp.type.interface", { fg = c.typ, bold = true })
hi("@lsp.type.type", { fg = c.typ, bold = true })
hi("@lsp.type.typeParameter", { fg = c.typ, bold = true })
hi("@lsp.type.function", { fg = c.fg })
hi("@lsp.type.method", { fg = c.fg })
hi("@lsp.type.variable", { fg = c.fg })
hi("@lsp.type.property", { fg = c.fg })
hi("@lsp.type.parameter", { fg = c.fg })
hi("@lsp.type.enumMember", { fg = c.fg })
hi("@lsp.type.macro", { fg = c.fg })
hi("@lsp.type.keyword", { fg = c.kwd, bold = true })
hi("@lsp.typemod.variable.readonly", { fg = c.fg })
hi("@lsp.typemod.variable.static", { fg = c.fg })

-- Re-assert after treesitter/LSP default links
hi("Comment", { fg = c.com, bold = true })
hi("Keyword", { fg = c.kwd, bold = true })
