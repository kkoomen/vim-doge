let s:save_cpo = &cpoptions
set cpoptions&vim

" vint: next-line -ProhibitUnusedVariable
function! s:jump_forward() abort
  let l:next_pos = search('TODO', 'nW')

  " Check if the next pos we want to jump to is still inside the comment.
  if l:next_pos != 0 && l:next_pos <= b:doge_interactive['lnum_comment_end_pos']
    if mode() ==# 'i'
      return "\<C-O>/TODO\<CR>\<C-O>:silent! noh\<CR>\<C-O>viwo\<C-g>"
    elseif mode() ==# 's'
      return "\<Esc>/TODO\<CR>:silent! noh\<CR>viwo\<C-g>"
    elseif mode() ==# 'n'
      return "/TODO\<CR>:silent! noh\<CR>viwo\<C-g>"
    else
      return "viwo\<C-g>"
    endif
  elseif expand('<cword>') ==# 'TODO' && mode() ==# 'i'
    return "\<C-O>viwo\<C-g>"
  endif

  " No more next TODOs found.
  return 0
endfunction

" vint: next-line -ProhibitUnusedVariable
function! s:jump_backward() abort
  let l:prev_pos = search('TODO', 'bnW')

  " Check if the prev pos we want to jump to is still inside the comment.
  if l:prev_pos != 0 && l:prev_pos >= b:doge_interactive['lnum_comment_start_pos']
    if mode() ==# 'i'
      return "\<C-O>?TODO\<CR>\<C-O>:silent! noh\<CR>\<C-O>viwo\<C-g>"
    elseif mode() ==# 's'
      return "\<Esc>?TODO\<CR>:silent! noh\<CR>viwo\<C-g>"
    elseif mode() ==# 'n'
      return "?TODO\<CR>:silent! noh\<CR>viwo\<C-g>"
    else
      return "viwo\<C-g>"
    endif
  elseif expand('<cword>') ==# 'TODO' && mode() ==# 'i'
    return "\<C-O>viwo\<C-g>"
  endif

  " No more previous TODOs found.
  return 0
endfunction

""
" @public
" Jumps to the previous and next TODO item in the comment based on the b:doge_interactive
" variable. Requires @setting(g:doge_comment_interactive) to be enabled.
" The {direction} can be of the following values: 'forward' | 'backward'
function! doge#comment#jump(direction) abort
  let l:regular_mapping = doge#helpers#keyseq(get(g:, 'doge_mapping_comment_jump_' . a:direction))

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
      " We update the interactive comment info also when jumping which fixes the
      " scenario if a user is using visual mode in-between the jumping to maybe
      " delete some lines.
      call doge#comment#update_interactive_comment_info()

      let l:jump_keyseq = call(printf('s:jump_%s', a:direction), [])
      if l:jump_keyseq != v:false
        return l:jump_keyseq
      endif
    else
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
" @setting(g:doge_comment_interactive) to be enabled.
function! doge#comment#update_interactive_comment_info() abort
  if exists('b:doge_interactive')
    " Only update if the cursor is inside the comment.
    " We add +1 to the lnum_comment_end_pos which covers the scenario if a user
    " pressed ENTER while being on the last line of the comment.
    if line('.') >= b:doge_interactive['lnum_comment_start_pos'] && line('.') <= b:doge_interactive['lnum_comment_end_pos'] + 1
      " When filling in the TODO items the user might hit the ENTER key so we
      " constantly have to update the end position of the comment, because the
      " comment can get bigger.

      " We will use a while loop because of languages like lua and ruby which
      " use single-line comments which gives us no separation if we have a lua
      " comment like this:
      "
      "   -- TODO
      "   -- @param arg1 TODO
      "   -- @param arg2 I can aplp
      "   -- @param arg3 TODO
      "   -- @param arg4 TODO
      "   function new_function(arg1, arg2, arg3, arg4)
      "   end
      "
      " So the idea is to just loop through every line until we come across a
      " non-comment line.
      let l:lnum_comment_end_pos = line('.')
      let l:comment_last_line = trim(b:doge_interactive['comment'][-1])[0]
      while trim(getline(l:lnum_comment_end_pos)) =~# printf('\m^%s', l:comment_last_line)
        let l:lnum_comment_end_pos += 1
      endwhile

      " If we're still at the same line we're probably dealing with python
      " comments (or something equivalent) where it only has an opener and
      " closer and each comment line does not start with a comment leader, so
      " just search for the last line of the comment
      if l:lnum_comment_end_pos == line('.')
        let l:lnum_comment_end_pos = search(l:comment_last_line, 'nW')
      endif

      let b:doge_interactive['lnum_comment_end_pos'] = l:lnum_comment_end_pos - 1
    endif
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
