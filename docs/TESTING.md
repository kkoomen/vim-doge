# Testing

The test suite is written in **Vader** (junegunn/vader.vim). Tests are
`.vader` files that script a real Vim/Neovim session: given a buffer, execute
keys/ex commands, expect a resulting buffer.

## Running tests

Prerequisites: the helper binary must be built (`./scripts/build.sh`), and
`vader.vim` must exist at `../vader.vim` relative to this repo (CI checks it
out there; locally it is a sibling of the checkout).

Run the whole suite:

```bash
./scripts/run-vader-tests.sh "$(command -v nvim)"   # or: "$(command -p vim)"
```

The script retries up to 5 times (Vader occasionally needs the second pass),
filters noise, and colorizes results.

Run a single file interactively:

```bash
vim -u test/vimrc
```

then inside Vim:

```vim
:Vader test/filetypes/python/functions.vader
```

(`:Vader!` runs without the pause-prompt between tests.)

## The test environment (`test/vimrc`)

Important differences from a real user setup — tests rely on these:

- `g:doge_mapping = '<C-d>'` — tests trigger doge with `\<C-d>`.
- `g:doge_comment_interactive = 0` — interactive mode is disabled, so tests
  only assert the inserted docblock text.
- `g:doge_comment_jump_wrap = 0`, `g:doge_lazyredraw = 0` — avoid flakiness.
- `g:doge_test_env = 1` — `doge#buffer#get_doc_standard()` always returns the
  first standard in `b:doge_supported_doc_standards` (tests don't depend on
  `g:doge_doc_standard_<ft>`).
- `filetype plugin indent on`, `syntax on`, `expandtab`, `shiftwidth=2`.
- `$CI == 'true'` switches the runtimepath to `$PWD/vader.vim` (for CI runs).

## Anatomy of a test file

```vader
# ==============================================================================
# Section comment describing the case
# ==============================================================================
Given python (case name):
  def myFunc():
    pass

Do (trigger doge):
  \<C-d>

Expect python (generated comment):
  def myFunc():
    """
    [TODO:description]
    """
    pass
```

- `Given <filetype> (name):` — sets the buffer filetype and content (indented
  by 2 spaces, content starts at column 0 relative to the buffer).
- `Do (name):` — keys or ex commands (`:12\<CR>` jumps to line 12, then the
  next `\<C-d>` triggers doge there).
- `Expect <filetype> (name):` — the full expected buffer content.
- `Expect no changes` — asserts nothing was modified.

Conventions:

- One test file per language + feature area: `functions.vader`,
  `classes.vader`, `functions-doc-<standard>.vader`, `es6.vader`, `jsx.vader`,
  `classes-doc-<standard>.vader`, etc.
- Test files must be referenced by the filetype dir they live in
  (`test/filetypes/python/...`, `test/filetypes/typescript/...`).
- When testing a specific doc standard, switch it explicitly in `Do`:
  `:let b:doge_doc_standard='reST'\<CR>` — remember `g:doge_test_env` forces
  the first standard, so to test other standards you must set it manually and
  restore afterwards.

## CI (`test` job in `.github/workflows/tests.yml`)

Matrix: Vim 7.4.2119 / 8.2.1118 / 8.2.5172 / 9.0.1500 and Neovim
0.3.2 / stable on ubuntu + macos. Exception: the minimum Vim versions
(7.4.2119, 8.2.1118) run on ubuntu only — their configure cannot build on
current macOS runners (see `rhysd/action-setup-vim#38`), so macOS uses
v8.2.5136, the oldest Vim that builds there. Every job:

1. checks out this repo and `junegunn/vader.vim` into `vader.vim`,
2. caches `~/.cargo`,
3. runs `./scripts/build.sh` (builds the helper),
4. runs `./scripts/run-vader-tests.sh <vim-binary>`.

A separate `vint` job lints the Vimscript.

## Linting

```bash
vint -s ./autoload ./plugin
```

Config: `.vintrc.yaml` (strict policies; note `ProhibitNoAbortFunction` —
all public functions must be `abort`). The codebase silences specific rules
with inline comments like `" vint: next-line -ProhibitUnusedVariable` — follow
the existing style; add suppressions only when justified.

## Debugging a failing test

1. Check the helper in isolation first (a bad parse is usually a helper
   problem, not a Vimscript problem):
   ```bash
   helper/target/release/vim-doge-helper --filepath /tmp/repro.py \
     --parser python --doc-name reST --line 3
   ```
2. If the helper output is correct, the bug is in Vim-side handling
   (indenting, insert position, `b:doge_insert`).
3. Rebuild after any Rust change: `./scripts/build.sh` — the YAML templates
   are compiled into the binary, so editing them without rebuilding produces
   stale results.
4. Note `test/vimrc` sets `shiftwidth=2` and Python gets `setlocal shiftwidth=2`
   via the `vim_doge_tests` augroup — expected buffers in tests use 2-space
   indent; a docblock's internal indent (from `--indent`/`<INDENT>`) is also 2
   in tests.
