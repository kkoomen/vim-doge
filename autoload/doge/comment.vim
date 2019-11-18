let s:save_cpo = &cpoptions
set cpoptions&vim

let s:comment_placeholder = doge#helpers#placeholder()

" vint: next-line -ProhibitUnusedVariable
function! s:jump_forward() abort
  let @/ = s:comment_placeholder
  let l:next_pos = searchpos(s:comment_placeholder, 'nW')
  let l:cpos = getpos('.')
  let l:cpos[1] = l:next_pos[0]
  let l:cpos[2] = l:next_pos[1]

  if (l:next_pos[0] > b:doge_interactive['lnum_comment_end_pos'] || l:next_pos[0] == 0)
    \ && g:doge_comment_jump_wrap == v:true
    " If we have more TODO items below the comment or we are at the last TODO
    " inside the comment, then we'll go backward to the start position of the
    " comment so we can continue to cycle.
    return "\<Esc>:" . b:doge_interactive['lnum_comment_start_pos'] . "\<CR>^:call search('" . s:comment_placeholder . "')\<CR>gno\<C-g>"
  endif

  " Check if the next pos we want to jump to is still inside the comment.
  if l:next_pos[0] != 0 && l:next_pos[0] <= b:doge_interactive['lnum_comment_end_pos']
    if mode() ==# 'i'
      return "\<C-o>:call setpos('.', " . string(l:cpos) . ")\<CR>\<C-o>gno\<C-g>"
    elseif mode() ==# 's'
      return "\<Esc>:call setpos('.', " . string(l:cpos) . ")\<CR>gno\<C-g>"
    elseif mode() ==# 'n'
      return ":call setpos('.', " . string(l:cpos) . ")\<CR>gno\<C-g>"
    else
      return "viw\<C-g>"
    endif
  elseif expand('<cword>') ==# s:comment_placeholder && mode() ==# 'i'
    return "\<C-o>viw\<C-g>"
  endif

  " No more next TODOs found.
  return 0
endfunction

" vint: next-line -ProhibitUnusedVariable
function! s:jump_backward() abort
  let @/ = s:comment_placeholder
  let l:prev_pos = searchpos(s:comment_placeholder, 'bnW')
  let l:cpos = getpos('.')
  let l:cpos[1] = l:prev_pos[0]
  let l:cpos[2] = l:prev_pos[1]

  if (l:prev_pos[0] < b:doge_interactive['lnum_comment_start_pos'] || l:prev_pos[0] == 0)
    \ && g:doge_comment_jump_wrap == v:true
    " If we have more TODO items above the comment or we are at the first TODO
    " inside the comment, then we'll go forward to the end position of the
    " comment so we can continue to cycle.
    return "\<Esc>:" . b:doge_interactive['lnum_comment_end_pos'] . "\<CR>$:call search('" . s:comment_placeholder . "', 'b')\<CR>gno\<C-g>"
  endif

  " Check if the prev pos we want to jump to is still inside the comment.
  if l:prev_pos[0] != 0 && l:prev_pos[0] >= b:doge_interactive['lnum_comment_start_pos']
    if mode() ==# 'i'
      return "\<C-o>:call setpos('.', " . string(l:cpos) . ")\<CR>\<C-o>gNo\<C-g>"
    elseif mode() ==# 's'
      return "\<Esc>:call setpos('.', " . string(l:cpos) . ")\<CR>gno\<C-g>"
    elseif mode() ==# 'n'
      return ":call setpos('.', " . string(l:cpos) . ")\<CR>gno\<C-g>"
    else
      return "viW\<C-g>"
    endif
  elseif expand('<cword>') ==# s:comment_placeholder && mode() ==# 'i'
    return "\<C-o>viw\<C-g>"
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
      call doge#deactivate()
      return l:regular_mapping
    endif

    let l:todo_count = doge#helpers#count(
          \ s:comment_placeholder,
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
      call doge#deactivate()
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
    if line('.') > b:doge_interactive['lnum_comment_start_pos'] && line('.') <= b:doge_interactive['lnum_comment_end_pos'] + 1
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
      let l:comment_last_line = doge#helpers#trim(b:doge_interactive['comment'][-1])[0]
      while doge#helpers#trim(getline(l:lnum_comment_end_pos)) =~# printf('\m^%s', l:comment_last_line)
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

""
" @public
" This function is trigged by the auto-commands InsertLeave and TextChanged and
" will deactivate doge when there are no more TODO items left. Requires
" @setting(g:doge_comment_interactive) to be enabled.
function! doge#comment#deactivate_when_done(...) abort
  if exists('b:doge_interactive')
    let l:pos = getcurpos()[1:2]
    call cursor(b:doge_interactive['lnum_comment_start_pos'], 1)
    if search(s:comment_placeholder, 'W', b:doge_interactive['lnum_comment_end_pos']) == v:false
      call doge#deactivate()
    endif
    call cursor(l:pos)
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
