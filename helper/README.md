# vim-doge-helper

Helper extension for the [vim-doge](https://github.com/kkoomen/vim-doge)
plugin that parses code in order to generate docblocks using
[tree-sitter](https://github.com/tree-sitter/tree-sitter), written in Rust.

# Table of Contents
- [vim-doge-helper](#vim-doge-helper)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)

# Installation

```
cargo install --path .
```

# Usage

Assume the following php file `code.php`:

```php
<?php

function add(int $a, int $b) {
  return $a + $b;
}
```

Use the following command to generate a docblock for the `add` function on line 3:

```
$ cargo run -- --filepath code.php --parser php --doc-name phpdoc --line 3
{
  "docblock": [
    "/**",
    " * [TODO:description]",
    " *",
    " * @param int $a [TODO:description]",
    " * @param int $b [TODO:description]",
    " *",
    " * @return [TODO:type] [TODO:description]",
    " */"
  ],
  "line": 3
}
```

The `line` is the line number of where the expression actually starts. This is
useful (and required for optimal user experience) in languages like C++, Rust or
JavaScript/TypeScript where there might be other expressions placed on top of
the function and thus the comment should be inserted above this.

C++ can have `template` to be put on the line above. Rust may have additional
macros, and JavaScript/TypeScript may contain function decorators.

To see all available options, run `cargo run -- --help`.

# Contributing

Help or feedback is always appreciated. If you find any bugs, feel free to
[submit a bug report][bug-report]. If you think vim-doge can be improved, feel
free to submit a [feature request][feature-request] or a pull request if you
have time to help out.

Read the [Contribution Guidelines][contrib-guide] and [Code of Conduct][coc]
when doing contributions.

[bug-report]: https://github.com/kkoomen/vim-doge/issues/new?labels=bug&template=bug_report.md
[feature-request]: https://github.com/kkoomen/vim-doge/issues/new?labels=enhancement&template=feature_request.md
[contrib-guide]: https://github.com/kkoomen/vim-doge/blob/master/CONTRIBUTING.md
[coc]: https://github.com/kkoomen/vim-doge/blob/master/CODE_OF_CONDUCT.md
