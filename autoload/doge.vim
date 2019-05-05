" ==============================================================================
" Filename: doge.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#generate() abort
  if exists('b:doge_patterns')
    for l:pattern in get(b:, 'doge_patterns')
      if doge#generate#pattern(l:pattern) == 0
        continue
      else
        return 1
      endif
    endfor
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
