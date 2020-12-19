# Contribution Guidelines

To keep consistency within the codebase, several guidelines will be required
when contributing to the repository. The topics below will also contain small
checklists to keep in mind when contributing.

When contributing make sure you have read and understood the
[Code of Conduct](./CODE_OF_CONDUCT.md).

# Table of Contents

- [Contribution Guidelines](#contribution-guidelines)
- [Table of Contents](#table-of-contents)
- [How does DoGe work?](#how-does-doge-work)
- [Topics](#topics)
  - [Linting](#linting)
  - [Documentation](#documentation)
  - [Doc standard](#doc-standard)
  - [Filetype / language](#filetype--language)
  - [Configurable setting](#configurable-setting)
  - [Code](#code)
  - [Tests](#tests)
- [Tips](#tips)
  - [Writing your first pattern](#writing-your-first-pattern)
    - [Additional token formatting](#additional-token-formatting)
      - [Creating TODO placeholders](#creating-todo-placeholders)
      - [Default value](#default-value)
      - [Conditional rendering](#conditional-rendering)

# How does DoGe work?

The key to DoGe is _tree-sitter_. Why? Because the plugin provides enough
languages that DoGe can support and it is extendable for the community if they
want to create their own parsers.

Each filetype consists of a buffer-local variable named `b:doge_patterns` which
is a list of dictionaries containing info about the pattern to match and how the
comment should be structured.

When triggering DoGe the `dist/index.js` is being executed and the corresponding
parser is being run onto the current buffer file. The parser will output the
parsed patterns if it did parse anything successful.

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

When adding a doc standard make sure to add proper tests which covers all kinds
of cases and add your doc standard to all the places in the documentation
where needed in the README.

**Summary of requirements:**

- ftplugin
- Make sure to add your doc standard to the top comment in `ftplugin/<filetype>.vim`.
- README
  - Add your doc standard to the [**Supported languages and doc standards**](https://github.com/kkoomen/vim-doge#supported-languages-and-doc-standards) section.
  - Add your new doc standard to the [**Choosing a different doc standard**](https://github.com/kkoomen/vim-doge#choosing-a-different-doc-standard) section.
- Tests (located in `test/filetypes/<filetype>/`)

## Filetype / language

When adding a new filetype/language to DoGe there is a lot to take into
account. Assuming you know the language ins and outs, it is recommended for
everyone to create a custom file with all possible scenarios. This helps to
write proper tests and increases the speed of writing them.

**Summary of requirements:**

- Parser (located in `src/parsers/<filetype>.service.ts`)
- ftplugin
  - Top comment describing what doc standard it should follow.
  - `b:doge_parser` (Used to determine which parser to use)
  - `b:doge_insert` (Used to determine whether to insert the docblocks above or below the expression)
  - `b:doge_supported_doc_standards` (A list containing the available doc standards)
  - `b:doge_doc_standard` (Contains the preferred doc standard by the user with a fallback to the first item of `b:doge_supported_doc_standards`)
- Tests (located in `test/filetypes/<filetype>/`)
- README
  - Add your doc standard to the [**Supported languages and doc standards**](https://github.com/kkoomen/vim-doge#supported-languages-and-doc-standards) section.
  - Add your new doc standard to the [**Choosing a different doc standard**](https://github.com/kkoomen/vim-doge#choosing-a-different-doc-standard) section.

## Configurable setting

When adding a new global-configurable setting then it should use proper
[vimdoc](https://github.com/google/vimdoc) syntax and documentation with the
default value, a brief description of what is does and tests.

**Summary of requirements:**

- Add the setting in `plugin/doge.vim`.
  - Add the default value
  - Add a brief description of what it does
- Install [vimdoc](https://github.com/google/vimdoc) and run `vimdoc .`
  locally. If no errors were given, the `doc/doge.txt` should be updated.
- Open vim and run `:helptags doc`. This should
  update the `tags` file located at `doc/tags`.
- Tests (located at `test/options/<option-name>.vader`)

## Code

When none of the above applies to your contribution you're probably
contributing a bug fix or a new feature.

Depending on how big your feature is, it might need some tests. If it is a
bug fix then it might be that some tests need to be updated or a new one has to
be added to cover this new scenario.

Make sure to document code where needed and keep the [README](./README.md),
[doge.txt](./doc/doge.txt) and [tags](./doc/tags) file updated.

## Tests

Running tests can be done in a docker by simply running `./run-tests`.
Use `./run-tests --help` for more info about the usage.

# Tips

Below will be some helpful tips for contributing.

## Writing your first pattern

If you have looked through the `ftplugin` folder through some files you have
noticed the buffer-local variable patterns. Below will be some explanation
about the dictionary structure per pattern.

The generation is done as described below:

- Run the corresponding parser to get the tokens.
- Render the tokens in the `template`.

```vim
" Example taken from ftplugin/php.vim

let b:doge_patterns = {
\  'phpdoc': [
\    {
        " The 'parameters' key is an optional key, since not every expression has a
        " parameter list.
\       'parameters': {
          " The 'format' key describes how the format of each parameter should be.
          " It contains a format for each supported doc standard.
          " Use a list for multi-line.
          " Use a tab '\t' to indent properly based on the user setting.
\         'format': '@param {type|!type} {name} !description',
\       },

        " The 'template' key is a new line when rendering the comment.
        " All the root-level tokens returned from the parser can be used here.
\       'template': [
\         '/**',
\         ' * !description',
\         '%(parameters| *)%',
\         '%(parameters| * {parameters})%',
\         ' */',
\       ],
\     }
\  ],
\}
```

### Additional token formatting

Additional formatting is available when using tokens in the `template` key. The
following subsections will elaborate more on the types of token formatting that
are available.

#### Creating TODO placeholders

If you've used DoGe already at least for a single function you've noticed it
will render items such as: `[TODO:description]`. These TODO items will
automatically be searched for when jumping forward or backward.

Inside a DoGe pattern you can use the token format `!<context>` which will be
replaced with `[TODO:<context>]`. To give the user a clear understanding what to
add at this TODO it's recommended to add a context. You may use the following in
a context: `[[:alpha:]-]`.

For example: some Python doc standards require a summary at the start of the doc
block followed by a description (separated by a whiteline).

If you see this:

```python
def myFunc(a):
    """
    TODO

    TODO

    :param a: TODO
    """
    pass
```

then you don't know _exactly_ what to add in the first TODO and the second TODO.

Giving it context will be more user-friendly:

```python
def myFunc(a):
    """
    [TODO:summary]

    [TODO:description]

    :param a: [TODO:description]
    """
    pass
```

#### Default value

You can render a token using the format `{...}`. When the captured group failed
to capture a value you can specify a default value using the pipe character
`|` like so: `{...|my default value}`.

For example:
PHP uses `mixed` as a type when the variable has no type hint specified. You
can accomplish this by render the `{type}` token as `{type|mixed}`. This will
result in `* @param mixed $myVar !description` instead of `* @param {type} $myVar !description`.

You can also leave the default value empty to just remove the token when it
fails to capture a value. Example: `{type|}`. This will result in:
`* @param $p1 !description` instead of `* @param {type} $p1 !description`, but
you never want this. In fact, using `{type|!type}` here would be very
user-friendly, since this allows the user to jump to this place to quickly fill
in the corresponding type.

#### Conditional rendering

The syntax for a conditional render is `%(<token>|<value>)%` where `<token>` is
the name of the token and `<value>` the value you want to render when `<token>`
is _not empty_.

Example:

```vim
" Example taken from ftplugin/python.vim

let b:doge_patterns = {
\  'numpy': [
\    {
       " ...
\      'template': [
\          '"""',
\          '!description',
\          '%(parameters|)%',              " Render an empty line if '{parameters}' is not empty
\          '%(parameters|Parameters)%',    " Renders 'Parameters' if '{parameters}' is not empty
\          '%(parameters|----------)%',    " Renders '----------' if '{parameters}' is not empty
\          '%(parameters|{parameters})%',  " Renders '{parameters}' if '{parameters}' is not empty
\          '"""',
\      ],
\    },
\  ],
\}
```
