# vim-doge-helper

Helper extension for the [vim-doge](https://github.com/kkoomen/vim-doge)
plugin that parses code in order to generate docblocks using
[tree-sitter](https://github.com/tree-sitter/tree-sitter).

# Installation

```
git clone git@github.com:kkoomen/vim-doge-helper.git
cd vim-doge-helper
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
$ cargo run -- --filepath code.php --lang php --doc-name phpdoc --line 3
/**
 * [TODO:description]
 *
 * @param int $a [TODO:description]
 * @param int $b [TODO:description]
 * @return
 */
```

To see all available options, run `cargo run -- --help`.
