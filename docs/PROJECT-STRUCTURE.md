# Project structure

## Top level

```
vim-doge/
├── plugin/doge.vim          Entry point: version gate, g:doge_* options,
│                            <Plug> mappings, :DogeGenerate, autocmds
├── autoload/doge.vim        Core logic: doge#generate(), doge#run_parser(),
│                            doge#install(), activate/deactivate
├── autoload/doge/
│   ├── comment.vim          Interactive TODO-jumping (b:doge_interactive)
│   ├── buffer.vim           Doc-standard resolution helpers
│   ├── indent.vim           doge#indent#add() — indent comment lines
│   ├── utils.vim            placeholder regex, count, deepextend, keyseq,
│   │                        get_filetype
│   └── preprocessors/       Optional per-language CLI-arg appenders
│       ├── c.vim cpp.vim javascript.vim php.vim python.vim
├── ftplugin/<ft>.vim        Per-filetype b:doge_parser / b:doge_insert /
│                            b:doge_supported_doc_standards; one per language
├── helper/                  Rust crate vim-doge-helper (the parser/renderer)
├── test/                    Vader tests + test environment
├── scripts/                 build / install / test / release shell scripts
├── doc/                     Vim help (doc/doge.txt), banner, demo gifs
├── bin/                     Installed helper binary + release tarballs
├── .version                 Version of the helper contract (compare against
│                            `vim-doge-helper --version`)
└── .github/workflows/       tests.yml (vim/nvim matrix + vint), release.yml
```

## autoload/ — the Vimscript core

All functions are namespaced `doge#<domain>#<fn>()` (lazy-loaded on first
call). Files:

| File | Key functions |
|---|---|
| `autoload/doge.vim` | `doge#generate(arg)` — main entry; `doge#run_parser()` — temp file + system() call + json_decode; `doge#activate()`/`doge#deactivate()` — buffer mapping lifecycle; `doge#install()` — build/install helper; `doge#command_complete()`; `doge#on_filetype_change()` |
| `autoload/doge/comment.vim` | `doge#comment#jump(direction)`, `doge#comment#update_interactive_comment_info()`, `doge#comment#deactivate_when_done()` |
| `autoload/doge/buffer.vim` | `doge#buffer#get_doc_standard(filetype)` |
| `autoload/doge/indent.vim` | `doge#indent#add(indent, text)` |
| `autoload/doge/utils.vim` | `doge#utils#placeholder()` (TODO regex), `count()`, `deepextend()`, `keyseq()`, `trim()`, `get_filetype()` |
| `autoload/doge/preprocessors/<lang>.vim` | `doge#preprocessors#<lang>#alter_parser_args(args)` |

## ftplugin/ — per-language wiring

One file per supported language: `c, cpp, cs, html, java, javascript, lua,
php, python, r, ruby, rust, scala, sh`. Each sets buffer-local variables:

```vim
let b:doge_parser = 'python'                    " --parser value
let b:doge_insert = 'below'                     " '' = above, 'below' = below
let b:doge_supported_doc_standards = ['reST', ...]
let b:doge_doc_standard = doge#buffer#get_doc_standard('python')
```

`g:doge_filetype_aliases` (default in `plugin/doge.vim`) maps aliases to
canonical filetypes: `javascript` ← `typescript`, `typescript.tsx`, ...
`html` ← `svelte`, `vue`; `java` ← `groovy`. So `ftplugin/javascript.vim` and
`ftplugin/html.vim` cover multiple actual Vim filetypes.

## helper/ — the Rust crate

```
helper/
├── Cargo.toml          tree-sitter grammars pinned by git rev; clap, tera,
│                       serde, regex
└── src/
    ├── main.rs         CLI args -> options HashMap -> docblock::generate()
    ├── lib.rs          module declarations (one per language)
    ├── config.rs       <parser>_<doc> -> include_str! YAML registry
    ├── docblock.rs     generate(): template iteration, postprocessors
    ├── base_parser.rs  BaseParser trait
    ├── tokens.rs       Tera render + whitespace/~ cleanup
    ├── traverse.rs     PreOrder tree-sitter traversal iterator
    └── <lang>/         bash c cpp csharp html java lua php python r ruby
        │               rust scala typescript
        ├── mod.rs      `pub mod parser;`
        ├── parser.rs   tree-sitter setup + BaseParser impl (tokens, line adj.)
        └── docs/*.yaml Doc-standard templates (Tera syntax)
```

Notable: `html` reuses the typescript parser (`typescript_jsdoc` and
`html_jsdoc` map to the same YAML; `HtmlParser` extracts inline `<script>`
content). The tree-sitter grammars come from git deps — check the revisions
in `Cargo.toml` before assuming node kinds.

## test/ — Vader test suite

```
test/
├── vimrc                 Test environment: <C-d> mapping, interactive mode
│                         disabled, g:doge_test_env=1, vader.vim on rtp
├── commands/
│   └── generate.vader    :DogeGenerate command tests
├── options/
│   └── doge_*.vader      Per-option behavior tests
├── filetypes/<ft>/       Per-language/standard tests (functions, classes,
│                         es6/es7, jsx, doc-* per standard, ...)
└── undo-cursor-pos.vader Cursor/undo position regression tests
```

## scripts/

| Script | Purpose |
|---|---|
| `build.sh` | `cargo build --release`, copy binary to `bin/`, optional target/tar.gz |
| `build.ps1` | Windows equivalent |
| `install.sh` | Download prebuilt helper binary from GitHub releases into `bin/` |
| `install.ps1` | Windows equivalent |
| `run-vader-tests.sh` | Runs Vader over all test files with retry + colored output |
| `release.sh` | Release pipeline (build, archive, git tag) |

## Files agents must keep in sync

Changing any of these usually requires coordinated edits elsewhere:

| Change | Also touch |
|---|---|
| New/changed YAML template in `helper/src/<lang>/docs/` | rebuild binary (`scripts/build.sh`); tests in `test/filetypes/<ft>/` |
| New CLI flag | `main.rs`, `autoload/doge/preprocessors/<lang>.vim`, option docs |
| New language | see `docs/ADDING-A-LANGUAGE.md` |
| Helper output/CLI contract change | `.version` (both repo file and binary), README |
