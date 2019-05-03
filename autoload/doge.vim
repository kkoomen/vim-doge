" ==============================================================================
" Filename: doge.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#generate() abort
  if !exists('b:doge_func_expr') && !exists('b:doge_var_expr')
    echo 'No b:doge_func_expr or b:doge_var_expr found for current filetype.'
  endif

  if exists('b:doge_func_expr')
    for l:func_expr in get(b:, 'doge_func_expr')
      if doge#generate#func_expr(l:func_expr) == 0
        continue
      else
        return 1
      endif
    endfor
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
