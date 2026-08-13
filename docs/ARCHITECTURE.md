# Architecture

This document walks through the full docblock-generation pipeline, from a key
press to the final inserted comment. The plugin is two components:

1. **Vimscript plugin** — UI, mappings, buffer integration, interactive mode.
2. **`helper/` (Rust)** — tree-sitter parsing + template rendering, exposed as
   a CLI binary `vim-doge-helper`.

The two sides communicate over a single JSON object printed to stdout. Nothing
else crosses the boundary.

## Data flow overview

```
User: cursor on a function line, presses <Leader>d
  |
  v
doge#generate(v:count)                        autoload/doge.vim:77
  |-- validates b:doge_doc_standard against b:doge_supported_doc_standards
  |-- resolves requested doc standard (count or string arg from :DogeGenerate)
  |
  v
doge#run_parser()                             autoload/doge.vim:10
  |-- finds helper binary (4 candidate paths, release dir first)
  |-- writes whole buffer to temp file
  |-- builds args: --filepath --parser --doc-name --line --indent|--use-tabs
  |-- doge#preprocessors#<ft>#alter_parser_args() may append flags
  |-- system(binary + args)
  |
  v
vim-doge-helper (helper/src/main.rs)
  |-- reads file, maps flags to options HashMap
  |
  v
docblock::generate(...)                       helper/src/docblock.rs:115
  |-- load_doc_config_str() -> embedded YAML (helper/src/config.rs)
  |-- for each template in YAML:
  |     get_node_types() from template's `node_types` list
  |     construct per-language tree-sitter parser
  |     parser.parse() -> Option<Result<Map<String,Value>>>
  |       (walks the tree, finds node at target line whose kind matches)
  |     on success:
  |       new_line = parser.postprocess_line(line)
  |       postprocess_tokens()  (per-language token fixes)
  |       replace_tokens()      (Tera render, helper/src/tokens.rs)
  |       replace_indent_placeholders()  (<INDENT> -> spaces/tab)
  |       postprocess_template()         (e.g. python ''' delimiters)
  |       return JSON { "line": N, "docblock": [line, ...] }
  |
  v
doge#generate() (resumes)
  |-- json_decode()
  |-- doge#indent#add() per line (autoload/doge/indent.vim)
  |-- append() at computed line
  |-- if g:doge_comment_interactive: build b:doge_interactive dict,
  |     jump to first [TODO:] placeholder (gno<C-g> to select it)
  |-- doge#activate() -> <buffer> mappings for <Tab>/<S-Tab>
```

## Vim side (Vimscript)

### Entry point and plugin init — `plugin/doge.vim`

- Version gate (Vim 7.4.2119+, Neovim 0.3.2+), sets `g:doge_dir`.
- Defines all `g:doge_*` options with defaults.
- Registers `<Plug>(doge-generate)` and `<Plug>(doge-comment-jump-forward|backward)`
  (the jump plugs are `<expr>` mappings that call `doge#comment#jump()`).
- Defines `:DogeGenerate {doc_standard}` command.
- Autocmds (group `doge`):
  - `TextChangedI` → `doge#comment#update_interactive_comment_info()`
  - `InsertLeave`/`TextChanged` → `doge#comment#deactivate_when_done()`
  - `FileType` → `doge#on_filetype_change()` (applies `g:doge_filetype_aliases`)

### Per-filetype config — `ftplugin/<ft>.vim`

Each filetype plugin sets buffer-local variables read by `doge#generate()`:

- `b:doge_parser` — name passed to the helper (`--parser`), e.g. `'python'`.
- `b:doge_insert` — `''` (insert above the line, most languages) or
  `'below'` (insert below the signature line; Python uses this because the
  docstring goes *inside* the function body).
- `b:doge_supported_doc_standards` — list of doc-standard names.
- `b:doge_doc_standard` — current standard, resolved via
  `doge#buffer#get_doc_standard('python')`: honors buffer-local
  `b:doge_doc_standard`, else `g:doge_doc_standard_<ft>`, else the first
  supported. In test env (`g:doge_test_env`) always the first.

Language-specific `g:doge_<lang>_settings` dicts (e.g. `g:doge_python_settings`)
may also be defined here.

### Preprocessors — `autoload/doge/preprocessors/<lang>.vim`

Optional per-language `doge#preprocessors#<lang>#alter_parser_args(args)`
that appends CLI flags based on `g:doge_<lang>_settings`. Called via
`function()` lookup in `doge#run_parser()`; a missing preprocessor is
swallowed by a catch (E117). Example: python adds `--python-single-quotes`
and `--python-omit-redundant-param-types`.

### Interactive mode — `autoload/doge/comment.vim`

State lives in the buffer-local dict `b:doge_interactive`:

```vim
{
  'comment': <the inserted docblock lines>,
  'lnum_comment_start_pos': <first line of comment>,
  'lnum_comment_end_pos':   <last line of comment>,
}
```

- `doge#comment#jump(direction)` is an `<expr>` mapping: returns the key
  sequence to execute (moves cursor + re-enters visual mode via `gno<C-g>`)
  or the original key if no TODO remains.
- The comment range is kept fresh: `update_interactive_comment_info()` runs on
  `TextChangedI` and extends `lnum_comment_end_pos` when the user types
  newlines inside the comment (loop for single-line-comment languages like
  Lua/Ruby, fallback search for block-comment languages like Python).
- When all placeholders are gone (checked on `InsertLeave`/`TextChanged` by
  `deactivate_when_done()`), or the cursor leaves the comment, the mode
  deactivates (`doge#deactivate()` removes buffer mappings, unlets
  `b:doge_interactive`, restores the search register).
- Jump/wrap behavior is controlled by `g:doge_comment_jump_wrap`,
  `g:doge_comment_jump_modes`, `g:doge_buffer_mappings`.

## Helper side (Rust)

### CLI — `helper/src/main.rs`

Args (clap derive): `--filepath`, `--parser`, `--doc-name`, `--line`,
`--indent` (2|4|8), `--use-tabs`, plus per-language flags
(`--php-resolve-fqn`, `--python-single-quotes`,
`--python-omit-redundant-param-types`, `--doxygen-use-slash-char`,
`--js-destructuring-props`, `--js-omit-redundant-param-types`).

Flags are folded into an `options: HashMap<&str, bool>` passed to
`docblock::generate()`. Output is `println!("{:#}", output)` — pretty JSON or
`Error: ...` on failure.

### Doc config registry — `helper/src/config.rs`

`load_doc_config_str(parser, doc)` maps the `<parser>_<doc>` string to an
`include_str!` of the YAML file. **The YAML files are compiled into the
binary** — changing a template requires a rebuild.

### Template iteration — `helper/src/docblock.rs`

`generate()` loads the YAML, then iterates every template in the `templates:`
mapping in arbitrary (serde_yaml) order. For each template it builds the
matching parser and calls `parse()`. The first template whose parse succeeds
wins, so when node types overlap between templates, template order matters.

Per-language post-processing in `docblock.rs`:

- **c/cpp**: injects the `char` token (`@` or `\`) from
  `--doxygen-use-slash-char`.
- **python**: injects `show_types` = !`omit_redundant_param_types`.
- **typescript**: injects `show_types`; strips parens from union return types
  (`(Foo | Bar)` → `Foo | Bar`); wraps non-Promise async return types in
  `Promise<T>`; no return type + async → `Promise<[TODO:type]>`.

### Parsers — `helper/src/<lang>/parser.rs`

Every language module implements `BaseParser` (`helper/src/base_parser.rs`):

- `parse() -> Option<Result<Map<String, Value>, String>>` — pre-order walk
  (`helper/src/traverse.rs`) looking for a node at the target line
  (`node.start_position().row + 1 == *self.line`) whose `kind()` is in
  `node_types`; then extract tokens from that node's children.
- `postprocess_line(line) -> usize` — default identity; overridden to move the
  insertion point, e.g. Python returns the line of the `:` ending the def
  (multi-line defs), TypeScript walks up to the topmost decorator.
- `get_code_bytes()` + `get_node_text()` helpers.

Token maps are plain `serde_json::Map<String, Value>`; keys used by templates
are language-specific but common ones are `name`, `params`, `return_type`,
`exceptions`, `attributes`, `tparams`, `generator`, `async`, `static`,
`has_panics`, `has_errors`, `has_unsafe`, `has_non_void_return_value`.

### Rendering — `helper/src/tokens.rs`

`replace_tokens()` renders the template string with Tera, then cleans up:

- lines that are empty after render are dropped,
- lines whose only content is `~` are dropped (used as separators inside
  `{% if %}` blocks so conditional sections don't produce blank gaps),
- runs of multiple spaces are collapsed to one.

### Language modules

`helper/src/lib.rs` declares all modules. Each `helper/src/<lang>/` contains
`mod.rs` (`pub mod parser;`), `parser.rs`, and `docs/*.yaml`. The tree-sitter
grammars are pinned by git revision in `helper/Cargo.toml` — upgrading a
grammar can silently change node kinds and break parsers/tests.

## The JSON contract (must stay stable)

Vim side expects exactly:

```json
{
  "line": <int, 1-based insertion line>,
  "docblock": ["line 1 of comment", "line 2", ...]
}
```

- `"line"` is where the comment should be *appended after* (Vim appends the
  docblock lines after this line; for `b:doge_insert == 'below'` this is the
  signature line, else it is decremented by 1 in Vim to insert above).
- `null` output means "nothing matched" (no docblock generated).
- Errors are printed as `Error: <message>` text on stdout; Vim catches
  non-JSON output and reports it via echoerr.
