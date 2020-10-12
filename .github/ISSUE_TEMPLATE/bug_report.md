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
If you don't provide a minimal vimrc then we will close your issue very quickly.
-->

- Create file `doge.vim` with:

```vim
set nocompatible
set runtimepath^=/path/to/vim-doge.nvim
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

**Output of `npm --version`**

<!--
Run `npm --version` on the command-line and paste the output here.
-->

**Output of `node --version`**

<!--
Run `node --version` on the command-line and paste the output here.
-->
