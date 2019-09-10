let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Generates documentation based on available patterns in b:doge_patterns.
function! doge#generate() abort
  let l:success = v:false
  if exists('b:doge_patterns')
    for l:pattern in get(b:, 'doge_patterns')
      if doge#generate#pattern(l:pattern) == v:false
        continue
      else
        let l:success = v:true
      endif
      if l:success
        call doge#activate()
      endif
      return l:success
    endfor
  endif
endfunction

""
" @public
" Activate doge mappings
function! doge#activate() abort
  if !get(g:, 'doge_comment_interactive', 1) || !get(g:, 'doge_buffer_mappings', 0)
    return
  endif
  let [l:f, l:b] = [g:doge_mapping_comment_jump_forward, g:doge_mapping_comment_jump_backward]
  execute 'nmap <nowait><silent><buffer>' l:f '<Plug>(doge-comment-jump-forward)'
  execute 'nmap <nowait><silent><buffer>' l:b '<Plug>(doge-comment-jump-backward)'
  execute 'imap <nowait><silent><buffer>' l:f '<Plug>(doge-comment-jump-forward)'
  execute 'imap <nowait><silent><buffer>' l:b '<Plug>(doge-comment-jump-backward)'
  execute 'smap <nowait><silent><buffer>' l:f '<Plug>(doge-comment-jump-forward)'
  execute 'smap <nowait><silent><buffer>' l:b '<Plug>(doge-comment-jump-backward)'
  if get(g:, 'doge_activation_message', 0)
    echo '[DoGe] '
    echohl Label
    echon 'activated'
    echohl None
  endif
endfunction

""
" @public
" Deactivate doge mappings and unlet buffer variable.
" Can print a message with the reason of deactivation/termination.
function! doge#deactivate(...) abort
  unlet b:doge_interactive
  if !get(g:, 'doge_comment_interactive', 1) || !get(g:, 'doge_buffer_mappings', 0)
    return
  endif
  execute 'nunmap <buffer>' g:doge_mapping_comment_jump_forward
  execute 'nunmap <buffer>' g:doge_mapping_comment_jump_backward
  execute 'iunmap <buffer>' g:doge_mapping_comment_jump_forward
  execute 'iunmap <buffer>' g:doge_mapping_comment_jump_backward
  execute 'sunmap <buffer>' g:doge_mapping_comment_jump_forward
  execute 'sunmap <buffer>' g:doge_mapping_comment_jump_backward
  if get(g:, 'doge_deactivation_message', 0)
    echo '[DoGe] '
    echohl WarningMsg
    echon 'deactivated'
    echohl None
    if a:0
      echon ': ' a:1
    endif
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
