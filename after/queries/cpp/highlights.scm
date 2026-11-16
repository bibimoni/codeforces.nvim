; extends
;
; The `; extends` on line 1 is a required modeline: nvim-treesitter's cpp query
; begins with `; inherits: c`, and without it Neovim treats this file as a
; competing base query and silently drops it.
;
; ---------------------------------------------------------------------------
; Codeforces / prettify parity for C++. Every rule below was derived by running
; prettify's real C++ lexer (src/prettify.js) over test programs, mapping the
; resulting token classes through prettify.css, and cross-checking the colors
; against a rendered codeforces.com page. Not guessed.
; ---------------------------------------------------------------------------

; prettify's `types` regex runs BEFORE its keyword regex and is
;   ^(DIR|FILE|array|vector|(de|priority_)?queue|(forward_)?list|stack|
;     (const_)?(reverse_)?iterator|(unordered_)?(multi)?(set|map)|bitset|u?(int|float)\d*)\b
; so the int/float family matches as typ (purple) even though it is also listed
; in C_KEYWORDS. Everything else in that regex is typ too. Re-capture the
; int/float family over @type.builtin (the theme paints short/long/char/...
; navy, matching prettify's keyword fallback).
(
  (primitive_type) @type
  (#any-of? @type
    "int" "float"
    "int8_t" "int16_t" "int32_t" "int64_t"
    "uint8_t" "uint16_t" "uint32_t" "uint64_t"
    "int_fast8_t" "int_fast16_t" "int_fast32_t" "int_fast64_t"
    "int_least8_t" "int_least16_t" "int_least32_t" "int_least64_t")
  (#set! priority 110)
)

; prettify's C_TYPES regex omits these, so CF renders them plain black even
; though nvim-treesitter calls them types. Confirmed pln on CF: pair, tuple,
; deque, string, greater, function, list.
(
  (type_identifier) @cf_plain
  (#any-of? @cf_plain
    "pair" "tuple" "deque" "string" "greater" "function" "list")
  (#set! priority 110)
)

; Lower-case typedef aliases (`ll`, `pii`, `vi` ...) never match prettify's
; `^[A-Z]+[a-z]...` / `_t$` type rule, so CF shows them plain black. A leading
; upper-case identifier (Node, SegTree) or a `_t` suffix stays purple. The
; C_TYPES names below are explicitly excluded: they are lower-case but DO match
; prettify's types regex, so CF renders them purple.
(
  (type_identifier) @cf_plain
  (#lua-match? @cf_plain "^%l")
  (#not-lua-match? @cf_plain "_t$")
  (#not-any-of? @cf_plain
    "array" "vector" "queue" "deque" "priority_queue" "list"
    "forward_list" "stack" "iterator" "reverse_iterator"
    "set" "multiset" "map" "multimap"
    "unordered_set" "unordered_map" "unordered_multiset" "unordered_multimap"
    "bitset")
  (#set! priority 109)
)

; `#define MAXN 200005` -- prettify paints the macro *name* plain but the value
; is still a numeric literal, so it is teal on CF, not black.
(
  (preproc_def (preproc_arg) @number)
  (#lua-match? @number "^%d+$")
  (#set! priority 110)
)

; `static_cast<int>(...)` -- prettify has static_cast in C_KEYWORDS -> kwd
; (navy). nvim-treesitter parses it as call_expression > template_function.
(
  (template_function name: (identifier) @keyword)
  (#any-of? @keyword
    "static_cast" "dynamic_cast" "const_cast" "reinterpret_cast"
    "sizeof" "alignof" "typeid" "decltype")
  (#set! priority 112)
)

; `vector<int>(n, 1)` -- a C_TYPES name used as a constructor. prettify still
; paints the type name purple (typ); nvim-treesitter sees a call_expression.
(
  (call_expression function: (template_function name: (identifier) @type))
  (#any-of? @type
    "array" "vector" "queue" "deque" "priority_queue" "list"
    "forward_list" "stack" "iterator" "reverse_iterator"
    "set" "multiset" "map" "multimap"
    "unordered_set" "unordered_map" "unordered_multiset" "unordered_multimap"
    "bitset")
  (#set! priority 112)
)

; prettify only turns a header green when it matches its stdio.h-style pattern:
;   /^<(?:(?:(?:\.\.\/)*|\/?)(?:[\w-]+(?:\/[\w-]+)+)?[\w-]+\.h(?:h|pp|\+\+)?|[a-z]\w*)>$/
; `bits/stdc++.h` fails it (the `++` in the name) so CF does not paint it as one
; green token -- the lexer splits it and `bits`/`h` come out plain black with
; only punctuation olive. Whole-token olive is the closest faithful
; approximation available to a tokenizer that keeps the header whole.
((preproc_include
   path: (system_lib_string) @punctuation.delimiter)
 (#lua-match? @punctuation.delimiter "^<bits/")
 (#set! priority 105))
