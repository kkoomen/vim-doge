let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @section Introduction, intro
" We all love documentation because it makes our codebases easier to understand,
" yet no one has time to write it in a good and proper way or some might not
" even like to write it.
"
" DoGe is a [Do]cumentation [Ge]nerator which will generate instant
" proper documentation based on the function declaration. You can simply put
" your cursor on a function, press `<C-d>`, add brief descriptions and go on
" coding!

""
" @section Preprocessors, preprocessors
" @parentsection functions
" Preprocess functions are called for specific filetypes when @plugin(name) is
" generating a comment. The following preprocess functions are available:
"
"   doge#preprocessors#<filetype>#tokens(tokens)
"
"   doge#preprocessors#<filetype>#parameter_tokens(tokens)
"
"   doge#preprocessors#<filetype>#insert_position(lnum_insert_pos)

if exists('g:loaded_doge')
  finish
endif
let g:loaded_doge = 1

if !exists('g:doge_mapping')
  ""
  " (Default: '<C-d>')
  "
  " Sets the mapping to trigger DoGe.
  let g:doge_mapping = '<C-d>'
endif

if !exists('g:doge_comment_todo_suffix')
  ""
  " (Default: 1)
  "
  " Adds the TODO suffix after every generated parameter.
  let g:doge_comment_todo_suffix = 0
endif

nnoremap <Plug>(doge-generate) :call doge#generate()<CR>
execute('nmap <unique> ' . get(g:, 'doge_mapping') . ' <Plug>(doge-generate)')

let &cpoptions = s:save_cpo
unlet s:save_cpo
