let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Jumps to the next TODO item in the comment based on the b:doge_interactive
" variable. Requires @settings(g:doge_comment_interactive) to be enabled.
function! doge#comment#jump_forward() abort
  let l:regular_mapping = doge#helpers#keyseq(g:doge_mapping_comment_jump_forward)

  if exists('b:doge_interactive')
    " Quit interactive mode if the cursor is outside of the comment.
    if line('.') < b:doge_interactive['lnum_comment_start_pos'] || line('.') > b:doge_interactive['lnum_comment_end_pos']
      unlet b:doge_interactive
      return l:regular_mapping
    endif

    let l:todo_count = doge#helpers#count(
          \ 'TODO',
          \ b:doge_interactive['lnum_comment_start_pos'],
          \ b:doge_interactive['lnum_comment_end_pos']
          \ )
    if l:todo_count > 0
      let l:next_pos = search('TODO', 'nW')
      " Check if the next pos we want to jump to is still inside the comment.
      if l:next_pos != 0 && l:next_pos < b:doge_interactive['lnum_comment_end_pos']
        if mode() ==# 'i'
          return "\<C-O>/TODO\<CR>\<C-O>:silent! noh\<CR>\<C-O>viwo\<C-g>"
        elseif mode() ==# 's'
          return "\<Esc>/TODO\<CR>:silent! noh\<CR>viwo\<C-g>"
        else
          return "viwo\<C-g>"
        endif
      elseif expand('<cword>') ==# 'TODO' && mode() ==# 'i'
        return "\<C-O>viwo\<C-g>"
      endif
    elseif exists('b:doge_interactive')
      " All the TODO items have been resolved, so we're done.
      unlet b:doge_interactive
    endif
  endif

  " If none of the above returned anything, we will return the key itself.
  return l:regular_mapping
endfunction

""
" @public
" Jumps to the previous TODO item in the comment based on the b:doge_interactive
" variable. Requires @settings(g:doge_comment_interactive) to be enabled.
function! doge#comment#jump_backward() abort
  let l:regular_mapping = doge#helpers#keyseq(g:doge_mapping_comment_jump_backward)

  if exists('b:doge_interactive')
    " Quit interactive mode if the cursor is outside of the comment.
    if line('.') < b:doge_interactive['lnum_comment_start_pos'] || line('.') > b:doge_interactive['lnum_comment_end_pos']
      unlet b:doge_interactive
      return l:regular_mapping
    endif

    let l:todo_count = doge#helpers#count(
          \ 'TODO',
          \ b:doge_interactive['lnum_comment_start_pos'],
          \ b:doge_interactive['lnum_comment_end_pos']
          \ )
    if l:todo_count > 0
      " Check if the cursor is outside the comment, if so, put it back.
      if line('.') < b:doge_interactive['lnum_comment_start_pos'] || line('.') > b:doge_interactive['lnum_comment_end_pos']
        execute(printf(':%d', b:doge_interactive['lnum_comment_end_pos']))
      endif
      let l:prev_pos = search('TODO', 'bnW')
      " Check if the prev pos we want to jump to is still inside the comment.
      if l:prev_pos != 0 && l:prev_pos > b:doge_interactive['lnum_comment_start_pos']
        if mode() ==# 'i'
          return "\<C-O>?TODO\<CR>\<C-O>:silent! noh\<CR>\<C-O>viwo\<C-g>"
        elseif mode() ==# 's'
          return "\<Esc>?TODO\<CR>:silent! noh\<CR>viwo\<C-g>"
        else
          return "viwo\<C-g>"
        endif
      elseif expand('<cword>') ==# 'TODO' && mode() ==# 'i'
        return "\<C-O>viwo\<C-g>"
      endif
    elseif exists('b:doge_interactive')
      " All the TODO items have been resolved, so we're done.
      unlet b:doge_interactive
    endif
  endif

  " If none of the above returned anything, we will return the key itself.
  return l:regular_mapping
endfunction

""
" @public
" This function is trigged by the auto-command TextChangedI and will update the
" b:doge_interactive variable where needed. Requires
" @settings(g:doge_comment_interactive) to be enabled.
function! doge#comment#update_interactive_comment_info() abort
  if exists('b:doge_interactive')
    " When filling in the TODO items the user might hit the ENTER key so we
    " constantly have to update the end position of the comment, because the
    " comment can get bigger.
    let l:lnum_comment_end_pos = search(b:doge_interactive['comment'][-1], 'nW')
    let b:doge_interactive['lnum_comment_end_pos'] = l:lnum_comment_end_pos
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
