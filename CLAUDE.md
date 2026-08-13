# vim-doge — Agent Guide

This file is the entry point for AI agents working on this repo. Read the
referenced files under `docs/` before making changes. Keep this file updated as
the codebase evolves.

## What vim-doge is

A Vim/Neovim plugin that generates documentation skeletons ("docblocks") from
the code expression under the cursor (mainly functions). Press `<Leader>d`
while the cursor is on a function and a docblock with `[TODO:...]` placeholders
is inserted; then `<Tab>` / `<S-Tab>` cycles through the placeholders so the
user can quickly fill in descriptions.

Goal: make writing documentation skeletons fast for as many languages and doc
standards as possible, with a consistent interactive fill-in experience.

- Languages: Python, PHP, JavaScript/TypeScript (incl. JSX/TSX/Vue/Svelte),
  HTML inline scripts, Lua, Java, Groovy, Ruby, C, C++, C#, Bash, Rust, R,
  Scala (15+).
- Doc standards: reST, Numpy, Google, Sphinx, Doxygen (many variants),
  phpdoc, JSDoc, LDoc, JavaDoc, YARD, XMLDoc, RustDoc, Roxygen2, ScalaDoc,
  KernelDoc.
- Requires Vim 7.4.2119+ or Neovim 0.3.2+.

## Architecture in one paragraph

The plugin is two components glued together by a shell call:

1. **Vimscript plugin** (this repo root: `plugin/`, `autoload/`, `ftplugin/`)
   — mappings, commands, per-filetype configuration, docblock insertion, and
   the interactive TODO-jumping mode.
2. **`helper/`** — a Rust crate (`vim-doge-helper`) that parses code with
   tree-sitter and renders docblocks from YAML templates. The Vim side writes
   the buffer to a temp file, runs the helper binary with `system()`, and gets
   back a JSON docblock.

Full walkthrough: `docs/ARCHITECTURE.md`.

## Repo layout (what matters where)

| Path | Purpose |
|---|---|
| `plugin/doge.vim` | Entry point: options, `<Plug>` mappings, `:DogeGenerate`, autocmds |
| `autoload/doge.vim` | `doge#generate()`, `doge#run_parser()`, `doge#install()`, activate/deactivate |
| `autoload/doge/comment.vim` | Interactive mode: jump forward/backward, TODO tracking |
| `autoload/doge/buffer.vim` | Doc-standard resolution (`b:doge_doc_standard`) |
| `autoload/doge/indent.vim` | Indent each docblock line before insert |
| `autoload/doge/utils.vim` | `[TODO:]` placeholder pattern, count, deepextend, trim |
| `autoload/doge/preprocessors/` | Per-language: append CLI args for the helper (optional) |
| `ftplugin/<ft>.vim` | Sets `b:doge_parser`, `b:doge_insert`, `b:doge_supported_doc_standards` |
| `helper/src/main.rs` | CLI arg parsing, dispatch to docblock generation |
| `helper/src/docblock.rs` | Template iteration, per-language token post-processing |
| `helper/src/config.rs` | Maps `<parser>_<doc>` to embedded YAML (via `include_str!`) |
| `helper/src/base_parser.rs` | `BaseParser` trait + `postprocess_line()` hook |
| `helper/src/tokens.rs` | Tera rendering, whitespace cleanup, `~` line removal |
| `helper/src/traverse.rs` | Lazy pre-order tree-sitter traversal iterator |
| `helper/src/<lang>/` | One module per language: `mod.rs`, `parser.rs`, `docs/*.yaml` |
| `test/` | Vader tests (`vimrc`, `filetypes/`, `commands/`, `options/`) |
| `scripts/` | `build.sh`, `install.sh`, `run-vader-tests.sh`, `release.sh` |
| `doc/doge.txt` | Vim help file (generated from plugin/ doc comments) |

## How a docblock is generated (the contract)

1. Cursor on a function line → `doge#generate()` → `doge#run_parser()`.
2. Whole buffer is written to a temp file; args are built (`--filepath`,
   `--parser`, `--doc-name`, `--line`, `--indent`/`--use-tabs`) and optionally
   extended by the filetype preprocessor.
3. The helper parses the temp file with tree-sitter, finds the node at the
   target line whose `kind` matches a template's `node_types`, extracts tokens
   (params, return type, exceptions, etc.), renders the Tera template, and
   prints `{"line": N, "docblock": [lines]}` as JSON on stdout.
4. Vim decodes it, indents each line, appends at `line`, and starts
   interactive mode (jumps to the first `[TODO:]`, sets up buffer mappings).

**Critical conventions — do not break these:**

- Line numbers are **1-based** in the CLI/JSON; tree-sitter rows are 0-based,
  so parsers always compare `node.start_position().row + 1 == line`.
- Placeholder regex (must match Vim + templates): `[TODO:description]`,
  `[TODO:type]`, etc. — Vim side: `doge#utils#placeholder()` in
  `autoload/doge/utils.vim:88`. Any placeholder `[TODO:...]` must consist of
  alnum, `-`, or space.
- `<INDENT>` in YAML templates is replaced with the indent string (spaces or
  tab) by `replace_indent_placeholders()` (`helper/src/docblock.rs:25`).
- In templates, a line containing only `~` is a "preserve" line: after
  rendering, empty lines and standalone `~` lines are removed, and runs of
  multiple spaces are collapsed to one (`helper/src/tokens.rs:21`). Use `~`
  to separate conditionally-rendered sections.
- The YAML templates are **embedded in the binary** (`include_str!` in
  `helper/src/config.rs`). Any template/doc-standard change requires
  `cargo build --release` (or `./scripts/build.sh`).
- The JSON `line` is the insertion point and may be adjusted by
  `postprocess_line()` in each parser (e.g. TypeScript decorators, C++
  templates, multi-line Python `def`).
- `b:doge_insert` decides above ('') vs below ('below') insertion per filetype.
- `.version` at repo root must match the helper binary version
  (`vim-doge-helper --version`); `doge#install()` skips install when equal.

## Testing

- Framework: **Vader** (`test/*.vader` files). Vader.vim lives at
  `../vader.vim` (sibling of this repo; CI checks it out next to the repo).
- Test env is configured by `test/vimrc` (disables interactive mode, sets
  `g:doge_test_env`, uses `<C-d>` as the doge mapping).
- Run everything:
  `./scripts/run-vader-tests.sh "$(command -v nvim)"` (or `vim`)
- Run one file: `vim -u test/vimrc` then inside vim
  `:Vader test/filetypes/python/functions.vader`
- Rebuild the helper after Rust changes before testing: `./scripts/build.sh`
- Lint: `vint -s ./autoload ./plugin` (config: `.vintrc.yaml`)
- CI (`.github/workflows/tests.yml`): vim 7.4/8.2/9.0 + nvim 0.3.2/stable on
  Ubuntu/macOS, plus vint.

Details and Vader syntax: `docs/TESTING.md`.

## Adding a language or doc standard (most common task)

See `docs/ADDING-A-LANGUAGE.md`. Checklist:

1. `helper/src/<lang>/` — `mod.rs`, `parser.rs`, `docs/<doc>.yaml`
2. `helper/src/lib.rs` — register module
3. `helper/src/config.rs` — map `<parser>_<doc>` → `include_str!`
4. `helper/src/docblock.rs` — add parser to the match in `generate()`
5. `ftplugin/<ft>.vim` — set `b:doge_parser`, `b:doge_insert`,
   `b:doge_supported_doc_standards`
6. Optionally `autoload/doge/preprocessors/<lang>.vim` for settings/CLI flags
7. Tests: `test/filetypes/<ft>/*.vader`

## Gotchas / traps for agents

- `serde_yaml` values: `get_node_types()` expects `node_types` to be a YAML
  sequence; templates is a mapping — order of iteration in
  `docblock::generate()` is arbitrary but the first successful parse wins, so
  template order matters when node types overlap.
- Python class parsing skips `self`/`cls` as first param of methods;
  TypeScript strips parens from union return types and wraps async returns in
  `Promise<T>`; PHP resolves FQNs via `use` statements when
  `php_resolve_fqn` is set. All handled in `docblock.rs` postprocessors or the
  per-language parsers.
- `doge#run_parser()` (autoload/doge.vim:10) searches 4 candidate binary
  paths — debug failures by running the helper manually, e.g.:
  `helper/target/release/vim-doge-helper --filepath /tmp/x.py --parser python --doc-name reST --line 1`
- Interactive mode state lives in `b:doge_interactive`
  (`{'comment', 'lnum_comment_start_pos', 'lnum_comment_end_pos'}`) and is
  created/destroyed by `doge#activate()` / `doge#deactivate()`. Autocmds in
  `plugin/doge.vim` keep the range updated as the user types.
- Filetype aliases (`g:doge_filetype_aliases`) mean `doge#utils#get_filetype()`
  returns the canonical filetype (e.g. `typescript` → `javascript`); helpers
  and preprocessors must use it, not `&filetype`.
- `.version` file: bump it when the helper CLI/output contract changes.
