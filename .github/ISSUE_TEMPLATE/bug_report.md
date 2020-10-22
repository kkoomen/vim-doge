---
name: Bug report
about: Report unwanted behavior
title: ''
labels: 'bug'
assignees: ''
---

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

<!--
If you can't reproduce the bug with a minimum vimrc then we might close your issue immediately.
-->

- Create file `doge.vim` with:

```vim
set nocompatible
set runtimepath^=/path/to/vim-doge
filetype plugin indent on
syntax on
set hidden
```

- Start (neo)vim with command: `vim -u doge.vim`

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

**Output of `vim --version`**

<!--
Run `vim --version` on the command-line and paste the output here.
-->
