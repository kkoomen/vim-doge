# DoGe

We all love documentation because it makes our codebases easier to understand,
yet no one has time to write it in a good and proper way or likes to write it.

DoGe is a DOcumentation GEnerator which will generate proper documentation based
on the function declaration. You can simply put your cursor on a function, press
`<C-d>`(<kbd>Ctrl</kbd> + <kbd>d</kbd>) and go on coding!

**(In progress)** DoGe is also able to update an existing generated doc-comment which allows you
to add, modify or delete a parameter, press `<C-d>` again and the corresponding
doc-comment has been updated.

**NOTE: The comment will be replaced for now rather then updated properly, this
means that additional commentary being added will be removed as well when
generating the comment again.**

### Supported languages and doc standards

- [x] Python ([Sphinx reST](http://daouzli.com/blog/docstring.html#restructuredtext))
- [x] PHP ([phpdoc](https://www.phpdoc.org))
- [ ] Javascript ([JSDoc](https://jsdoc.app))
- [ ] Typescript ([JSDoc](https://jsdoc.app))

# Table of Contents
- [DoGe](#doge)
    + [Supported languages and doc standards](#supported-languages-and-doc-standards)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Contributing](#contributing)
  * [Linting](#linting)
  * [Documentation](#documentation)
- [License](#license)

# Getting Started

Install `DoGe`:

Using vim-pack:

- `git clone https://github.com/kkoomen/doge ~/.vim/pack/<dir>/start/doge`

Using pathogen:

- `git clone https://github.com/kkoomen/doge ~/.vim/bundle/doge`

Using plug:

- `Plug 'kkoomen/doge'`

# Configuration

[TODO]

# Contributing

Help or feedback is always appreciated. If you find any bugs, feel free to
submit an issue. If you find any improvements, feel free to submit a pull
request.

## Linting

Your pull request should follow the rules of the `vim-vint` linter which is a
must to keep your code clean and prevent mistakes being made.

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
documentation in the `doc/` should be generated using [vimdoc](https://github.com/google/vimdoc).

# License

Copyright 2019 Kim Koomen

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
