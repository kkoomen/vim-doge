<h1 align="center">DoGe</h1>
<p align="center">
  <a href="https://travis-ci.com/kkoomen/doge">
    <img src="https://travis-ci.com/kkoomen/doge.svg?branch=master" alt="Travic CI Build Status" />
  </a>
  <img src="https://img.shields.io/badge/vim-8.1%2B-informational.svg" alt="Minimum supported Vim version" />
  <img src="https://img.shields.io/badge/neovim-0.3.2%2B-informational.svg" alt="Minimum supported NeoVim version" />
  <a href="https://github.com/kkoomen/doge/blob/develop/LICENSE">
    <img src="https://img.shields.io/github/license/kkoomen/doge.svg" alt="License" />
  </a>
</p>

We all love documentation because it makes our codebases easier to understand,
yet no one has time to write it in a good and proper way or some might not even
like to write it.

DoGe is a [Do]cumentation [Ge]nerator which will generate instant proper
documentation based on the function declaration. You can simply put your cursor
on a function, press `<C-d>`(<kbd>Ctrl</kbd> + <kbd>d</kbd>), add brief
descriptions and go on coding!

> Any fool can write code that a computer can understand. Good programmers write
> code that humans can understand. -- Martin Fowler, 1999

### Supported languages and doc standards

- [x] Python ([Sphinx reST](http://daouzli.com/blog/docstring.html#restructuredtext))
- [x] PHP ([phpdoc](https://www.phpdoc.org))
- [x] Javascript ([JSDoc](https://jsdoc.app))
  - [x] ES6
  - [x] FlowJS
  - [x] NodeJS
- [x] Typescript ([JSDoc](https://jsdoc.app))
- [x] Coffeescript ([JSDoc](https://jsdoc.app))
- [x] Lua ([LDoc](https://github.com/stevedonovan/LDoc))
- [x] Java ([JavaDoc](https://www.oracle.com/technetwork/articles/javase/index-137868.html))
- [x] Ruby ([YARD](https://www.rubydoc.info/gems/yard/file/docs/Tags.md))
- [x] Scala ([ScalaDoc](https://docs.scala-lang.org/style/scaladoc.html))
- [ ] Kotlin ([KDoc](https://kotlinlang.org/docs/reference/kotlin-doc.html))
- [ ] R ([R style guide](https://style.tidyverse.org/documentation.html))
- [ ] C++ ([CPPDoc](http://www.edparrish.net/common/cppdoc.html#comment))
- [ ] Haskell ([Haddock](https://www.haskell.org/haddock/doc/html/ch03s02.html))
- [ ] Idris ([IdrisDocs](http://docs.idris-lang.org/en/latest/reference/documenting.html))
- [ ] Assembly ([ASMDoc](https://www.ee.ryerson.ca/~kclowes/stand-alone/CodingStandards/CodingStdAsm/CodingStdAsm.html#SECTION00070000000000000000))
- [ ] C# ([XML Documentation](https://docs.microsoft.com/en-us/previous-versions/visualstudio/visual-studio-2010/5ast78ax%28v%3dvs.100%29))

# Table of Contents
- [DoGe](#doge)
    + [Supported languages and doc standards](#supported-languages-and-doc-standards)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
    + [`g:doge_mapping`](#gdoge_mapping)
- [Contributing](#contributing)
  * [Linting](#linting)
  * [Documentation](#documentation)
  * [Help](#help)

# Getting Started

Install `DoGe`:

Using vim-pack:

- `git clone https://github.com/kkoomen/doge ~/.vim/pack/*/start/doge`

Using pathogen:

- `git clone https://github.com/kkoomen/doge ~/.vim/bundle/doge`

Using plug:

- `Plug 'kkoomen/doge'`

# Configuration

<!-- Run `:help doge-config` to get the help page for all the possible configuration. -->

### `g:doge_mapping`

(Default: `<C-d>`)

Sets the mapping to trigger DoGe.

# Contributing

Help or feedback is always appreciated. If you find any bugs, feel free to
submit an issue. If you find any improvements, feel free to submit a pull
request.

## Linting

Your pull request should follow the rules of the `vim-vint` linter which is a
must to keep the code clean and prevent mistakes being made. Each PR will
automatically run tests for code quality using Vint. You don't have to use Vint
locally, but it will help you to fix any errors before submitting a PR.

- `pip3 install vim-vint`

If you use [ALE](https://github.com/w0rp/ale) (recommended)

```
let g:ale_linters = { 'vim': ['vint'] }
```

or if you use [Syntastic](https://github.com/vim-syntastic/syntastic)
```
let g:syntastic_vim_checkers = ['vint']
```

## Documentation

Every function, mapping or configurable option should contain documentation. The
documentation in the `doc/` should be generated using
[vimdoc](https://github.com/google/vimdoc).

## Help

To open all the help pages, run `:help doge`.
