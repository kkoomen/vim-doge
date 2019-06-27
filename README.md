<p align="center">
  <a href="./doc/demos/README.md">
    <img src="./doc/banner.jpg" alt="DoGe" />
  </a>
</p>
<p align="center">
  <a href="https://travis-ci.com/kkoomen/vim-doge">
    <img src="https://travis-ci.com/kkoomen/vim-doge.svg?branch=master" alt="Travic CI Build Status" />
  </a>
  <img src="https://img.shields.io/badge/vim-8.0.1630%2B-informational.svg" alt="Minimum supported Vim version" />
  <img src="https://img.shields.io/badge/neovim-0.3.2%2B-informational.svg" alt="Minimum supported NeoVim version" />
  <a href="./LICENSE">
    <img src="https://img.shields.io/github/license/kkoomen/vim-doge.svg" alt="License" />
  </a>
</p>

> Any fool can write code that a computer can understand. Good programmers write
> code that humans can understand. -- Martin Fowler, 1999

We all love documentation because it makes our codebases easier to understand,
yet no one has time to write it in a good and proper way.

DoGe is a [Do]cumentation [Ge]nerator which will generate a proper documentation
skeleton based on certain expressions (mainly functions). Simply put your cursor
on a function, press `<C-d>`(<kbd>Ctrl</kbd> + <kbd>d</kbd>), jump quickly
through `TODO` items using `<Tab>` and `<S-Tab>` to quickly add descriptions and
go on coding!

[Visit the demo page](./doc/demos/README.md)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Supported languages and doc standards](#supported-languages-and-doc-standards)
- [Getting started](#getting-started)
- [Configuration](#configuration)
  * [Choosing a different doc standard](#choosing-a-different-doc-standard)
  * [Options](#options)
    + [`g:doge_mapping`](#gdoge_mapping)
    + [`g:doge_mapping_comment_jump_forward`](#gdoge_mapping_comment_jump_forward)
    + [`g:doge_mapping_comment_jump_backward`](#gdoge_mapping_comment_jump_backward)
    + [`g:doge_comment_todo_suffix`](#gdoge_comment_todo_suffix)
    + [`g:doge_comment_interactive`](#gdoge_comment_interactive)
- [Help](#help)
- [FAQ](#faq)
    + [Jump-forward trigger requires to be pressed 2 times in order to jump forward](#jump-forward-trigger-requires-to-be-pressed-2-times-in-order-to-jump-forward)
- [Contributing](#contributing)
- [Motivation](#motivation)
- [Supporting DoGe](#supporting-doge)
- [License](#license)

# Supported languages and doc standards

Every language that has a documentation standard should be supported by DoGe.

Is your favorite language not supported?
[Suggest a new language](https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=feature_request.md&title=Add+support+for+<language>) :tada:<br/>
Is your favorite doc standard not supported?
[Suggest a new doc standard](https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=doc_standard.md) :tada:

|                    | Language                                       | Doc standard                                                                                                              |
| :----------------- | :--------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------ |
| :white_check_mark: | Python                                         | [reST](http://daouzli.com/blog/docstring.html#restructuredtext), [Numpy](http://daouzli.com/blog/docstring.html#numpydoc) |
| :white_check_mark: | PHP                                            | [phpdoc](https://www.phpdoc.org)                                                                                          |
| :white_check_mark: | JavaScript (Including: ES6, FlowJS and NodeJS) | [JSDoc](https://jsdoc.app)                                                                                                |
| :white_check_mark: | TypeScript                                     | [JSDoc](https://jsdoc.app)                                                                                                |
| :white_check_mark: | CoffeeScript                                   | [JSDoc](https://jsdoc.app)                                                                                                |
| :white_check_mark: | Lua                                            | [LDoc](https://github.com/stevedonovan/LDoc)                                                                              |
| :white_check_mark: | Java                                           | [JavaDoc](https://www.oracle.com/technetwork/articles/javase/index-137868.html)                                           |
| :white_check_mark: | Groovy                                         | [JavaDoc](https://www.oracle.com/technetwork/articles/javase/index-137868.html)                                           |
| :white_check_mark: | Ruby                                           | [YARD](https://www.rubydoc.info/gems/yard/file/docs/Tags.md)                                                              |
| :white_check_mark: | Scala                                          | [ScalaDoc](https://docs.scala-lang.org/style/scaladoc.html)                                                               |
| :white_check_mark: | Kotlin                                         | [KDoc](https://kotlinlang.org/docs/reference/kotlin-doc.html)                                                             |
| :white_check_mark: | R                                              | [Roxygen2](https://github.com/klutometis/roxygen)                                                                         |
| :white_check_mark: | C++                                            | [Doxygen](http://www.doxygen.nl)                                                                         |

# Getting started

Install `DoGe`:

Using vim-pack:

- `git clone https://github.com/kkoomen/vim-doge ~/.vim/pack/*/start/vim-doge`

Using pathogen:

- `git clone https://github.com/kkoomen/vim-doge ~/.vim/bundle/vim-doge`

Using plug:

- `Plug 'kkoomen/vim-doge'`

# Configuration

Run `:help doge` to get the full help page.

## Choosing a different doc standard

DoGe supports multiple doc standard and you can overwrite them per filetype in
your vimrc. Is your favorite doc standard not supported?
[Suggest a new doc standard](https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=doc_standard.md) :tada:

Example:
```vim
let g:doge_doc_standard_python = 'numpy'
```

Here is the full list of available doc standards per filetype:

| Variable                           | Default      | Supported           |
| :--------------------------------- | :----------- | :------------------ |
| `g:doge_doc_standard_python`       | `'reST'`     | `'reST'`, `'numpy'` |
| `g:doge_doc_standard_php`          | `'phpdoc'`   | `'phpdoc'`          |
| `g:doge_doc_standard_javascript`   | `'jsdoc'`    | `'jsdoc'`           |
| `g:doge_doc_standard_typescript`   | `'jsdoc'`    | `'jsdoc'`           |
| `g:doge_doc_standard_coffeescript` | `'jsdoc'`    | `'jsdoc'`           |
| `g:doge_doc_standard_lua`          | `'ldoc'`     | `'ldoc'`            |
| `g:doge_doc_standard_java`         | `'javadoc'`  | `'javadoc'`         |
| `g:doge_doc_standard_groovy`       | `'javadoc'`  | `'javadoc'`         |
| `g:doge_doc_standard_ruby`         | `'YARD'`     | `'YARD'`            |
| `g:doge_doc_standard_scala`        | `'scaladoc'` | `'scaladoc'`        |
| `g:doge_doc_standard_kotlin`       | `'kdoc'`     | `'kdoc'`            |
| `g:doge_doc_standard_r`            | `'roxygen2'` | `'roxygen2'`        |
| `g:doge_doc_standard_cpp`          | `'doxygen'`  | `'doxygen'`         |

## Options

### `g:doge_mapping`

Default: `'<C-d>'`

The mapping to trigger DoGe.

### `g:doge_mapping_comment_jump_forward`

Default: `'<Tab>'`

The mapping to jump forward to the next `TODO` item in a comment. Requires
`g:doge_comment_interactive` to be enabled.

### `g:doge_mapping_comment_jump_backward`

Default: `'<S-Tab>'`

The mapping to jump backward to the next `TODO` item in a comment. Requires
`g:doge_comment_interactive` to be enabled.

### `g:doge_comment_todo_suffix`

Default: `1`

Adds the `TODO` suffix after every generated parameter.

### `g:doge_comment_interactive`

Default: `1`

Jumps interactively through all `TODO` items in the generated comment.

# Help

To open all the help pages, run `:help doge`.

# FAQ

### Jump-forward trigger requires to be pressed 2 times in order to jump forward

**Problem:**
This is because you have another plugin that overrides the DoGe default `<Tab>`
mapping in select mode. UltiSnips could be one of them for most people or any
other plugin that maps the `<Tab>` character in select mode.


**Solution:**
You can solve this by re-mapping the jump forward/backward keys using
`g:doge_mapping_comment_jump_forward` and `g:doge_mapping_comment_jump_backward`
or re-map the other plugins. You can also load DoGe earlier since it uses `nore`
and thus should prevent other plugins from overwriting at a later stage.

# Contributing

Help or feedback is always appreciated. If you find any bugs, feel free to
[submit a bug report](https://github.com/kkoomen/vim-doge/issues/new?labels=bug&template=bug_report.md).
If you think DoGe can be improved, feel free to submit a
[feature request](https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=feature_request.md)
or a pull request if you have time to help out.

Read the [Contribution Guidelines](./CONTRIBUTING.md) and [Code of Conduct](./CODE_OF_CONDUCT.md) when doing contributions.

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

Do you enjoy using DoGe? Give it a star on GitHub and submit your vote on [vim.org](https://www.vim.org/scripts/script.php?script_id=5801).

# License

DoGe is licensed under the GPL-3.0 license.
