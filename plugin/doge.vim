let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_doge')
  finish
endif
let g:loaded_doge = 1

if !exists('g:doge_mapping')
  ""
  " @setting(g:doge_mapping)
  "
  " (Default: '<C-d>')
  "
  " Sets the mapping to trigger DoGe.
  let g:doge_mapping = '<C-d>'
endif

execute('nnoremap ' . get(g:, 'doge_mapping') . ' :call doge#generate()<CR>')

let &cpoptions = s:save_cpo
unlet s:save_cpo
