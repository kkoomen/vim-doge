let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#generate() abort
  if exists('b:doge_patterns')
    for l:pattern in get(b:, 'doge_patterns')
      if doge#generate#pattern(l:pattern) == 0
        continue
      endif

      return 1
    endfor
    echo '[DoGe] No patterns did match the current line.'
  else
    echo '[DoGe] b:doge_patterns variable not found for filetype "' . &filetype . '".'
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
