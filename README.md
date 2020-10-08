<p align="center">
  <a href="https://github.com/kkoomen/vim-doge/blob/master/doc/demos">
    <img src="https://user-images.githubusercontent.com/10693490/60382742-df4a2c80-9a67-11e9-82e3-9ada6daff0a8.jpg" alt="DoGe" />
  </a>
</p>
<p align="center">
  <a href="https://travis-ci.com/kkoomen/vim-doge">
    <img src="https://travis-ci.com/kkoomen/vim-doge.svg?branch=master" alt="Travic CI Build Status" />
  </a>
  <img src="https://img.shields.io/badge/vim-7.4.2119%2B-informational.svg" alt="Minimum supported Vim version" />
  <img src="https://img.shields.io/badge/neovim-0.2.0%2B-informational.svg" alt="Minimum supported NeoVim version" />
  <img src="https://img.shields.io/github/v/tag/kkoomen/vim-doge?label=version" alt="Latest version" />
  <a href="https://github.com/kkoomen/vim-doge/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/kkoomen/vim-doge.svg" alt="License" />
  </a>
</p>

> Any fool can write code that a computer can understand. Good programmers write
> code that humans can understand. -- Martin Fowler, 1999

We all love documentation because it makes our codebases easier to understand,
yet no one has time to write it in a good and proper way.

DoGe is a (Do)cumentation (Ge)nerator which will generate a proper documentation
skeleton based on certain expressions (mainly functions). Simply put your cursor
on a function, press `<Leader>d`, jump quickly through `TODO` items using
`<Tab>` and `<S-Tab>` to quickly add descriptions and go on coding!

[Visit the demo page][demo-readme]

# Table of Contents

- [Table of Contents](#table-of-contents)
- [Supported languages and doc standards](#supported-languages-and-doc-standards)
- [Migrating from v2 to v3](#migrating-from-v2-to-v3)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
- [Configuration](#configuration)
  - [Choosing a different doc standard](#choosing-a-different-doc-standard)
  - [Options](#options)
    - [`g:doge_parsers`](#gdoge_parsers)
    - [`g:doge_enable_mappings`](#gdoge_enable_mappings)
    - [`g:doge_mapping`](#gdoge_mapping)
    - [`g:doge_filetype_aliases`](#gdoge_filetype_aliases)
    - [`g:doge_buffer_mappings`](#gdoge_buffer_mappings)
    - [`g:doge_mapping_comment_jump_forward`](#gdoge_mapping_comment_jump_forward)
    - [`g:doge_mapping_comment_jump_backward`](#gdoge_mapping_comment_jump_backward)
    - [`g:doge_comment_interactive`](#gdoge_comment_interactive)
    - [`g:doge_comment_jump_wrap`](#gdoge_comment_jump_wrap)
    - [`g:doge_comment_jump_modes`](#gdoge_comment_jump_modes)
- [Commands](#commands)
  - [`:DogeGenerate {doc_standard}`](#dogegenerate-doc_standard)
  - [`:DogeCreateDocStandard {doc_standard}`](#dogecreatedocstandard-doc_standard)
- [Language-specific configuration](#language-specific-configuration)
  - [PHP](#php)
  - [Python](#python)
- [FAQ](#faq)
- [Help](#help)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [Supporting DoGe](#supporting-doge)
- [License](#license)

# Supported languages and doc standards

Every language that has a documentation standard should be supported by DoGe.

Is your favorite language not supported?
[Suggest a new language][suggest-language] :tada:<br/>
Is your favorite doc standard not supported?
[Suggest a new doc standard][suggest-doc-standard] :tada:

|                    | Language                                       | Doc standards                                                                |
| :----------------- | :--------------------------------------------- | :--------------------------------------------------------------------------- |
| :white_check_mark: | Python                                         | [reST][py-rest], [Numpy][py-numpy], [Google][py-google], [Sphinx][py-sphinx] |
| :white_check_mark: | PHP                                            | [phpdoc][phpdoc]                                                             |
| :white_check_mark: | JavaScript (Including: ES6, FlowJS and NodeJS) | [JSDoc][jsdoc]                                                               |
| :white_check_mark: | TypeScript                                     | [JSDoc][jsdoc]                                                               |
| :white_check_mark: | Lua                                            | [LDoc][ldoc]                                                                 |
| :white_check_mark: | Java                                           | [JavaDoc][javadoc]                                                           |
| :white_check_mark: | Groovy                                         | [JavaDoc][javadoc]                                                           |
| :white_check_mark: | Ruby                                           | [YARD][yard]                                                                 |
| :white_check_mark: | C++                                            | [Doxygen][doxygen]                                                           |
| :white_check_mark: | C                                              | [Doxygen][doxygen], [KernelDoc][kerneldoc]                                   |
| :white_check_mark: | Bash                                           | [Google][sh-google]                                                          |

# Migrating from v2 to v3

⚠️ If you've used DoGe v2 or less and upgraded to v3 then you are required to have
NodeJS + NPM on your local machine in order to use this plugin, because of the
new usage of the [tree-sitter](https://tree-sitter.github.io/tree-sitter/)
parsers. This plugin is using the node bindings for tree-sitter, because the
amount of supported languages is a lot.

If you just want to use v3, then read the [Getting started](#getting-started).

If you feel more comfortable to use v2, then you can still do so by using
[v2.8.0](https://github.com/kkoomen/vim-doge/tree/v2.8.0). **Please be aware that
v2 might contain bugs and will not be maintained anymore.**

Using Plug:

- `Plug 'kkoomen/vim-doge', { 'tag': 'v2.8.0' }`

# Getting started

## Prerequisites

Make sure your local system contains the following prerequisites:

- [NodeJS](https://nodejs.org)
- [NPM](https://www.npmjs.com)

**NOTE:** If you only want to use a specific amount of languages, then make sure
you use [`g:doge_parsers`](#gdoge_parsers) in your `.vimrc` before running
`doge#install()`.

Install `DoGe`:

Using plug:

- `Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }`

Using vim-pack:

- `git clone --depth 1 https://github.com/kkoomen/vim-doge ~/.vim/pack/*/start/vim-doge`
- `:call doge#install()`

Using pathogen:

- `git clone --depth 1 https://github.com/kkoomen/vim-doge ~/.vim/bundle/vim-doge`
- `:call doge#install()`

# Configuration

Run `:help doge` to get the full help page.

## Choosing a different doc standard

DoGe supports multiple doc standard and you can overwrite them per filetype in
your vimrc. Is your favorite doc standard not supported?
[Suggest a new doc standard][suggest-doc-standard] :tada:

Example:

```vim
let g:doge_doc_standard_python = 'numpy'
```

If you want to change the doc standard specifically for a buffer, then you can do:

```vim
" Inside test.py
:let b:doge_doc_standard = 'numpy'
```

If you want to generate a docblock using a different doc standard just for a
specific expression, then you can use `DogeGenerate`:

```vim
" Inside test.py, cursor is at a function expression (cursor = `|`):
"   |def foo(p1, p2):
"       pass
:DogeGenerate numpy
```

Here is the full list of available doc standards per filetype:

| Variable                         | Default             | Supported                                                                                                                                    |
| :------------------------------- | :------------------ | :------------------------------------------------------------------------------------------------------------------------------------------- |
| `g:doge_doc_standard_python`     | `'reST'`            | `'reST'`, `'numpy'`, `'google'`, `'sphinx'`                                                                                                  |
| `g:doge_doc_standard_php`        | `'phpdoc'`          | `'phpdoc'`                                                                                                                                   |
| `g:doge_doc_standard_javascript` | `'jsdoc'`           | `'jsdoc'`                                                                                                                                    |
| `g:doge_doc_standard_typescript` | `'jsdoc'`           | `'jsdoc'`                                                                                                                                    |
| `g:doge_doc_standard_lua`        | `'ldoc'`            | `'ldoc'`                                                                                                                                     |
| `g:doge_doc_standard_java`       | `'javadoc'`         | `'javadoc'`                                                                                                                                  |
| `g:doge_doc_standard_groovy`     | `'javadoc'`         | `'javadoc'`                                                                                                                                  |
| `g:doge_doc_standard_ruby`       | `'YARD'`            | `'YARD'`                                                                                                                                     |
| `g:doge_doc_standard_cpp`        | `'doxygen_javadoc'` | `'doxygen_javadoc'`, `'doxygen_javadoc_no_asterisk'`, `'doxygen_javadoc_banner'`, `'doxygen_qt'`, `'doxygen_qt_no_asterisk'`                 |
| `g:doge_doc_standard_c`          | `'doxygen_javadoc'` | `'kernel_doc'`, `'doxygen_javadoc'`, `'doxygen_javadoc_no_asterisk'`, `'doxygen_javadoc_banner'`, `'doxygen_qt'`, `'doxygen_qt_no_asterisk'` |
| `g:doge_doc_standard_sh`         | `'google'`          | `'google'`                                                                                                                                   |

## Options

### `g:doge_parsers`

Default:

```
Default: [
  'bash',
  'c',
  'cpp',
  'java', // includes groovy
  'lua',
  'php',
  'python',
  'ruby',
  'typescript', // used for JavaScript, ES6, FlowJS and NodeJS
]
```

Defines the parsers that are enabled, which is useful if you only want to use
specific languages. This also decreases installation time.

**NOTE:** By default, all parsers will be installed.

Whether or not to enable built-in mappings.

### `g:doge_enable_mappings`

Default: `1`

Whether or not to enable built-in mappings.

### `g:doge_mapping`

Default: `'<Leader>d'`

The mapping to trigger DoGe. The mapping accepts a count, to select a specific
doc standard, if more than one is defined.

### `g:doge_filetype_aliases`

Default:

```
{
  'javascript': [
    'javascript.jsx',
    'javascriptreact',
    'javascript.tsx',
    'typescriptreact',
    'typescript',
    'typescript.tsx',
  ],
  'java': ['groovy'],
}
```

Set filetypes as an alias for other filetypes. The key should be the filetype
that is defined in `ftplugin/<key>.vim`. The value must be a list of 1 or more
filetypes that will be aliases.

Example:

```vim
let g:doge_filetype_aliases = {
\  'javascript': ['vue']
\}
```

If you use the above settings and you open `myfile.vue` then it will behave like
you're opening a JavaScript filetype.

### `g:doge_buffer_mappings`

Default: `1`

Mappings to jump forward/backward are applied as buffer mappings when
interactive mode starts and removed when it ends.

### `g:doge_mapping_comment_jump_forward`

Default: `'<Tab>'`

The mapping to jump forward to the next `TODO` item in a comment. Requires
`g:doge_comment_interactive` to be enabled.

### `g:doge_mapping_comment_jump_backward`

Default: `'<S-Tab>'`

The mapping to jump backward to the previous `TODO` item in a comment. Requires
`g:doge_comment_interactive` to be enabled.

### `g:doge_comment_interactive`

Default: `1`

Jumps interactively through all `TODO` items in the generated comment.

### `g:doge_comment_jump_wrap`

Default: `1`

Continue to cycle among placeholders when reaching the start or end.

### `g:doge_comment_jump_modes`

Default: `['n', 'i', 's']`

Defines the modes in which doge will jump forward and backward when interactive
mode is active. For example: removing `i` would allow you to use `<Tab>` for
autocompletion in insert mode.

# Commands

### `:DogeGenerate {doc_standard}`

Command to generate documentation. The `{doc_standard}` accepts a count or a
string as argument, and it can complete the available doc standards for the
current buffer.

The numeric value should point to an index key from the
`b:doge_supported_doc_standards` variable.

The string value should point to a doc standard name listed in the
`b:doge_supported_doc_standards` variable.

### `:DogeCreateDocStandard {doc_standard}`

Command to generate a custom doc standard template. The `{doc_standard}` is a
mandatory argument which is the name of the new doc standard. If it exists, the
existing doc standard with the same name will be used as base for the custom
template. It can complete the available doc standards for the current buffer.

For more information on how to create custom doc standards you can read
[Writing your first pattern](./CONTRIBUTING.md#writing-your-first-pattern).

# Language-specific configuration

Below is a list of language-specific configuration and their default values.

### PHP

```vim
let g:doge_php_settings = {
\  'resolve_fqn': 1
\}
```

### Python

```vim
let g:doge_python_settings = {
\  'single_quotes': 0
\}
```

# FAQ

# Help

To open all the help pages, run `:help doge`.

# Contributing

Help or feedback is always appreciated. If you find any bugs, feel free to
[submit a bug report][bug-report]. If you think DoGe can be improved, feel free
to submit a [feature request][feature-request] or a pull request if you have
time to help out.

Read the [Contribution Guidelines][contrib-guide] and [Code of Conduct][coc]
when doing contributions.

# Motivation

I created DoGe mainly because I couldn't find a plugin that could generate
proper comments for a big collection of languages in a quick and easy way. I am
a polyglot developer when it comes to programming languages and I couldn't find
proper vim plugins that would generate documentation quickly for all languages I
did want to be supported.

Rather then scraping off the internet to find all sorts of vim plugins for every
language I was coding in, I did want a single plugin that would support every
language I was working in.

Another big motivation for me is that I've noticed people tend to skip the
documentation part because writing _just the skeleton_ of the comment takes
already too much time and I am one of those people. Having the skeleton
generated and an interactive mode to quickly add descriptions is a big
time saver.

# Supporting DoGe

Do you enjoy using DoGe? Give it a star on GitHub and submit your vote on
[vim.org][vim-script].

# License

DoGe is licensed under the GPL-3.0 license.

[py-rest]: http://daouzli.com/blog/docstring.html#restructuredtext
[py-numpy]: http://daouzli.com/blog/docstring.html#numpydoc
[py-google]: https://github.com/google/styleguide/blob/gh-pages/pyguide.md#38-comments-and-docstrings
[py-sphinx]: https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html#the-sphinx-docstring-format
[phpdoc]: https://www.phpdoc.org
[jsdoc]: https://jsdoc.app
[ldoc]: https://github.com/stevedonovan/LDoc
[javadoc]: https://www.oracle.com/technetwork/articles/javase/index-137868.html
[yard]: https://www.rubydoc.info/gems/yard/file/docs/Tags.md
[roxygen2]: https://github.com/klutometis/roxygen
[doxygen]: http://www.doxygen.nl
[kerneldoc]: https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
[sh-google]: https://google.github.io/styleguide/shell.xml#Function_Comments
[demo-readme]: https://github.com/kkoomen/vim-doge/blob/master/doc/demos
[suggest-language]: https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=feature_request.md&title=Add+support+for+<language>
[suggest-doc-standard]: https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=doc_standard.md
[bug-report]: https://github.com/kkoomen/vim-doge/issues/new?labels=bug&template=bug_report.md
[feature-request]: https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=feature_request.md
[contrib-guide]: https://github.com/kkoomen/vim-doge/blob/master/CONTRIBUTING.md
[coc]: https://github.com/kkoomen/vim-doge/blob/master/CODE_OF_CONDUCT.md
[vim-script]: https://www.vim.org/scripts/script.php?script_id=5801
