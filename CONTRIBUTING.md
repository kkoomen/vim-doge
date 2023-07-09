# Contribution Guidelines

To keep consistency within the codebase, several guidelines will be required
when contributing to the repository. The topics below will also contain small
checklists to keep in mind when contributing.

When contributing make sure you have read and understood the
[Code of Conduct](./CODE_OF_CONDUCT.md).

# Table of Contents

- [Contribution Guidelines](#contribution-guidelines)
- [Table of Contents](#table-of-contents)
- [How does vim-doge work?](#how-does-vim-doge-work)
- [Topics](#topics)
  * [Linting](#linting)
  * [Documentation](#documentation)
  * [Doc standard](#doc-standard)
  * [Filetype / language](#filetype--language)
  * [Configurable setting](#configurable-setting)
  * [Code](#code)
  * [Tests](#tests)
- [Tips](#tips)
  * [Parsers](#parsers)
    + [Doc standards templating](#doc-standards-templating)

# How does vim-doge work?

The key to vim-doge is _tree-sitter_. Why? Because the plugin provides enough
languages that vim-doge can support and it is extendable for the community if
they want to create their own parsers.

Vim-doge has a custom command-line interface called [vim-doge-helper](./helper/)
that is responsible for all the code parsing and generating docblocks based on
certain flags. The vimscript code is simply a wrapper around it along with some
additional logic, such as interactive mode.

# Topics

Below will be several topics describing their minimum requirements when
contributing.

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

Try to document all functions and configurable options where needed. The
documentation in the `doc/doge.txt` should be generated using
[vimdoc](https://github.com/google/vimdoc).

## Doc standard

When adding a doc standard for the vim-doge-helper, make sure to add proper
tests which covers all kinds of cases and add your doc standard to all the
places in the documentation where needed in the README.

**Summary of requirements:**

- ftplugin
- Make sure to add your doc standard to the top comment in `helper<lang>/docs/<doc-name>.yaml`.
- README
  - Add your doc standard to the [**Supported languages and doc standards**](https://github.com/kkoomen/vim-doge#supported-languages-and-doc-standards) section.
  - Add your new doc standard to the [**Choosing a different doc standard**](https://github.com/kkoomen/vim-doge#choosing-a-different-doc-standard) section.
- Tests (located in `test/filetypes/<filetype>/`)

## Filetype / language

When adding a new filetype/language to vim-doge, there is a lot to take into
account. Assuming you know the language ins and outs, it is recommended for
everyone to create a custom file with all possible scenarios. This helps to
write proper tests and increases the speed of writing them.

**Summary of requirements:**

- Parser (located in `helper/src/<lang>/parser.rs`)
- ftplugin
  - `b:doge_parser` (Used to determine which parser to use)
  - `b:doge_insert` (Used to determine whether to insert the docblocks above or below the expression)
  - `b:doge_supported_doc_standards` (A list containing the available doc standards)
  - `b:doge_doc_standard` (Contains the preferred doc standard by the user with a fallback to the first item of `b:doge_supported_doc_standards`)
- Tests (located in `test/filetypes/<filetype>/`)
- README
  - Add your doc standard to the [**Supported languages and doc standards**](https://github.com/kkoomen/vim-doge#supported-languages-and-doc-standards) section.
  - Add your new doc standard to the [**Choosing a different doc standard**](https://github.com/kkoomen/vim-doge#choosing-a-different-doc-standard) section.

## Configurable setting

When adding a new global-configurable setting, it should use proper
[vimdoc](https://github.com/google/vimdoc) syntax and documentation with the
default value, a brief description of what is does and tests.

**Summary of requirements:**

- Add the setting in `plugin/doge.vim`.
  - Add the default value
  - Add a brief description of what it does
- Install [vimdoc](https://github.com/google/vimdoc) and run `vimdoc .`
  locally. If no errors were given, the `doc/doge.txt` should be updated.
- Open vim and run `:helptags doc`. This should update the `tags` file located
  at `doc/tags`.
- Tests (located at `test/options/<option-name>.vader`)

## Code

When none of the above applies to your contribution you're probably contributing
a bug fix or a new feature.

Depending on how big your feature is, it might need some tests. If it is a bug
fix, then it might be that some tests need to be updated or a new one has to be
added to cover this new scenario.

Make sure to document code where needed and keep the [README](./README.md),
[doge.txt](./doc/doge.txt) and [tags](./doc/tags) file updated.

## Tests

If you want to run tests locally, you can simply do so by running the command(s)
below:

```
$ ./scripts/run-vader-tests.sh vim
$ ./scripts/run-vader-tests.sh nvim
```

or specifying specific tests:

```
$ ./scripts/run-vader-tests.sh vim "test/filetypes/python/*.vader"
```

You can also open vim and run specific tests

```
:Vader ./test/filetypes/javascript/functions.vader ./test/filetypes/rust/functions.vader
```

or open vim and run the current file:

```
:Vader
```

**NOTE:** However, you do require to have
[Vader](https://github.com/junegunn/vader.vim) installed being a sibling folder
to the `vim-doge` folder, like so:

```
parent
├── vader.vim
└── vim-doge
```

# Tips

Below will be some helpful tips for contributing.

## Parsers

When implementing parsers, it is recommended to always print the AST:
`println!("{}", self.tree.root_node().to_sexp());` and then use
https://xaedes.github.io/online-sexpr-format in order to make it easier to
browse through the tree.

Being familiar with this makes it relatively quick to implement a new parser or
debug some code.


### Doc standards templating

The vim-doge-helper uses [Tera](https://tera.netlify.app/docs), a powerful
templating engine for rust that allows advanced expressions.

Each doc standard resides in `src/<lang>/docs/` as `<doc-name>.yaml`.

Below is an example for a random language. Keep in mind that this is a fixed
structure, although you can specify any name for each direct child key inside
the `templates` key. In the example below, `class` and `function` can be changed
to whatever suits.

```yaml
templates:
  class:
    node_types:
      - class
    template: |
      # [TODO:description]
      #
      # @implements {{ class_name }}
      # @extends {{ parent_name }}

  function:
    node_types:
      - function_definition
    template: |
      # [TODO:summary]
      # [TODO:description]
      {% if params %}
        {% for param in params %}
      # @param {{ param.name }} [TODO:description]
        {% endfor %}
      {% endif %}
