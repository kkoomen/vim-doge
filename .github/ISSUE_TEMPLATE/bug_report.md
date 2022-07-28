---
name: Bug report
about: Report unwanted behavior
title: ''
labels: 'bug'
assignees: ''
---

<!--
READ THIS BEFORE YOU CONTINUE: please fill in the information below and make
sure to test your bug by using the minimal vimrc provided below. If you can't
reproduce the bug with a minimal vimrc then your issue is mostly not related to
this plugin, therefore this issue might be closed immediately.

1. Create file `vim-doge.vimrc` with:
```vim
set nocompatible
set runtimepath^=/path/to/vim-doge
filetype plugin indent on
syntax on
set hidden
```
2. Start (neo)vim with command: `vim -u vim-doge.vimrc`
3. Test whether you can still run into the problem.
-->

**Describe the bug**

<!--
A clear and concise description of what the bug is. Provide the scenarios if
you're reporting an issue for a certain expression that doesn't (properly)
generate documentation.
-->

**Settings**

<!--
If applicable, describe your custom DoGe settings like so:

```vim
let g:doge_mapping = '<Leader>f'
```
-->

**To Reproduce**

Steps to reproduce the behavior:

1. ...

**Expected behavior**

<!--
A clear and concise description of what you expected to happen.
-->

**Screenshots**

<!--
If applicable, add screenshots to help explain your problem.
-->

**Output of `./bin/vim-doge --version`**

<!--
HOW TO FIND VERSION
1. cd into vim-doge directory
2. run `./bin/vim-doge --version`
-->

**Output of `vim --version`**

<!--
Run `vim --version` on the command-line and paste the output here.
-->
