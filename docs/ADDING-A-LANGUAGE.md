# Adding a language or doc standard

This is the most common contribution. A language needs a tree-sitter grammar
(dependency) or the language must already be in `helper/Cargo.toml`, and a
set of templates. A new doc standard for an *existing* language only needs a
new YAML template file plus config/test wiring.

## 1. The YAML doc config — `helper/src/<lang>/docs/<standard>.yaml`

Structure (Tera syntax, rendered by `helper/src/tokens.rs`):

```yaml
templates:
  function:
    node_types:
      - function_definition      # tree-sitter node kinds to match
    template: |
      /**
       * [TODO:description]
       {% if params %}
       *
       {% for param in params %}
       * @param {{ param.name }} [TODO:description]
       {% endfor %}
       {% endif %}
       */
```

Rules and available markup:

- `node_types` must be a YAML sequence of tree-sitter node kinds. The parser
  only matches a node whose `kind()` is in this list *and* whose
  `start_position().row + 1` equals the target line.
- `template` is a Tera string. Available context values are the token map
  returned by the parser (`params`, `return_type`, `name`, `exceptions`,
  `attributes`, `tparams`, ...) plus per-language injected tokens
  (`show_types`, `char`, ...).
- `<INDENT>` is replaced with the user's indent (spaces from `--indent` or a
  tab with `--use-tabs`) — use it for indented content inside the comment.
- `~` on a line by itself inside an `{% if %}` block is a separator: after
  rendering, empty lines and standalone `~` lines are removed, and runs of
  multiple spaces are collapsed to one. This keeps conditional sections from
  leaving blank gaps. Pattern from `reST.yaml`:
  ```yaml
  [TODO:description]
  {% if params or return_type or exceptions %}
  ~
  {% endif %}
  {% if params %}
  ```
- `[TODO:...]` placeholders must match the Vim regex
  `\[TODO:[[:alnum:]- ]\+\]` (see `doge#utils#placeholder()`). Never use
  punctuation inside brackets; use `{{ param.name | default(value="[TODO:type]") }}`
  for optional data.
- Remember the whole buffer is indented again on the Vim side; the template
  should be written at indent level 0 relative to the comment.

## 2. The parser — `helper/src/<lang>/parser.rs`

Model after an existing language. Minimal skeleton (bash is the simplest):

```rust
use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct BashParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for BashParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> BashParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_bash::language()).unwrap();
        let tree = parser.parse(code, None).unwrap();
        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line
                && self.node_types.contains(&child_node.kind())
            {
                return match child_node.kind() {
                    "function_definition" => self.empty_parse_result(),
                    _ => None,
                };
            }
        }
        None
    }
}
```

Notes:

- **1-based vs 0-based**: always compare `node.start_position().row + 1 == *self.line`.
- `empty_parse_result()` returns an empty token map — use it for templates
  with no variables. Otherwise return a `Map` with tokens (see the python or
  typescript parsers for full examples: `params`, `return_type`, `exceptions`,
  `attributes`, `tparams`).
- For richer extraction, iterate node children and match `child_node.kind()`
  (tree-sitter node kinds are language-specific — inspect them with the
  tree-sitter playground or a debug print before guessing).
- Templates with `{% if return_type %}` need the key absent (not null) when
  there's no value — only insert tokens you actually have.
- Grammar pin: if your language's grammar is not in `helper/Cargo.toml`, add
  it as a git dependency with a pinned rev, matching the style of the others.
- `postprocess_line()` — override when the insertion point differs from the
  matched node's line:
  - Python: returns the `:` line for multi-line `def` (docstring goes after
    the signature).
  - TypeScript: walks up to the topmost `decorator`.
  - C++: would walk up over `template<...>` lines.
  The JSON `"line"` is where Vim inserts the docblock.

## 3. Wiring — 4 small edits

1. `helper/src/lib.rs` — `pub mod <lang>;`
2. `helper/src/config.rs` — add the mapping(s), e.g.
   ```rust
   "mylang_mydoc" => include_str!("mylang/docs/mydoc.yaml"),
   ```
3. `helper/src/docblock.rs` — add the parser to the match inside
   `generate()`:
   ```rust
   "mylang" => Box::new(MyLangParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
   ```
   (Pass `options` too if the language has settings.)
4. `ftplugin/<ft>.vim` — buffer variables:
   ```vim
   let b:doge_parser = 'mylang'
   let b:doge_insert = ''            " '' = above; 'below' = below signature
   let b:doge_supported_doc_standards = ['mydoc']
   let b:doge_doc_standard = doge#buffer#get_doc_standard('mylang')
   ```
   For alias filetypes (e.g. `svelte` → `html`), add the alias to
   `g:doge_filetype_aliases` in `plugin/doge.vim` instead of a new ftplugin.

## 4. Optional: settings + preprocessor

If the language needs user settings passed to the helper:

1. Define defaults in `ftplugin/<ft>.vim` as `g:doge_<lang>_settings`.
2. Define flags in `helper/src/main.rs` (clap) and fold them into `options`
   in the `match args.parser.as_str()` block.
3. Create `autoload/doge/preprocessors/<lang>.vim`:
   ```vim
   function! doge#preprocessors#mylang#alter_parser_args(parser_args) abort
     let l:args = deepcopy(a:parser_args)
     if get(g:, 'doge_mylang_settings', {})['some_setting']
       let l:args += ['--mylang-some-setting']
     endif
     return l:args
   endfunction
   ```
4. Use per-language token postprocessing in `docblock.rs` (`postprocess_tokens`
   / `postprocess_template`) if needed (see python `single_quotes`, c/cpp
   `char`, typescript `Promise` wrapping).

## 5. Tests

1. Rebuild: `./scripts/build.sh`.
2. Create `test/filetypes/<ft>/functions.vader` (see `docs/TESTING.md` for
   syntax). Cover: no-arg functions, typed params, return types, multi-line
   signatures, ignored expressions (non-functions at the cursor).
3. Add a test for each doc standard (e.g. `functions-doc-<standard>.vader`),
   switching standards with `:let b:doge_doc_standard='<standard>'\<CR>` in
   the `Do` block.
4. Run: `vim -u test/vimrc` → `:Vader test/filetypes/<ft>/functions.vader`.
   Then the full suite:
   `./scripts/run-vader-tests.sh "$(command -v nvim)"`.

## Adding only a new doc standard (existing language)

1. Write `helper/src/<lang>/docs/<newstandard>.yaml` (mirror an existing one).
2. `helper/src/config.rs`: add `"<lang>_<newstandard>" => include_str!(...)`.
3. `ftplugin/<lang>.vim`: append the standard to
   `b:doge_supported_doc_standards`.
4. `plugin/doge.vim`: update the `<lang>` row of the supported standards in
   the option comment (user-facing docs in README too).
5. Rebuild, add `test/filetypes/<ft>/...-doc-<newstandard>.vader`, run tests.

## Checklist summary

- [ ] `helper/src/<lang>/mod.rs` (`pub mod parser;`)
- [ ] `helper/src/<lang>/parser.rs`
- [ ] `helper/src/<lang>/docs/<standard>.yaml`
- [ ] `helper/src/lib.rs` module registration
- [ ] `helper/src/config.rs` include_str! mapping
- [ ] `helper/src/docblock.rs` parser dispatch (and postprocessors if needed)
- [ ] `helper/Cargo.toml` grammar dep (if new grammar)
- [ ] `ftplugin/<ft>.vim` buffer vars (+ `g:doge_<lang>_settings` if any)
- [ ] `autoload/doge/preprocessors/<lang>.vim` (if flags)
- [ ] `helper/src/main.rs` flags (if flags)
- [ ] `test/filetypes/<ft>/*.vader`
- [ ] `./scripts/build.sh` + run test suite
- [ ] Update README language/doc-standard tables
