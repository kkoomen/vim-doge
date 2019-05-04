" ==============================================================================
" Filename: generate.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim


function! doge#generate#func_expr(func_expr) abort
  " Assuming multiline function expressions won't be longer than 15 lines.
  let l:lines = getline('.', line('.') + 15)
  if empty(trim(get(l:lines, 0)))
    return 0
  endif

  " Skip immediately if the current line does not match.
  let l:curr_line = escape(trim(join(l:lines, ' ')), '\')
  if l:curr_line !~# a:func_expr['match']
    return 0
  endif

  let l:tokens = doge#token#extract(l:curr_line, a:func_expr['match'], a:func_expr['match_group_names'])


  " Split the 'parameters' token value into a list.
  let l:params_dict = a:func_expr['parameters']
  let l:parameter_match_group_name = l:params_dict['parent_match_group_name']
  let l:params = map(split(l:tokens[l:parameter_match_group_name], ','), {k, v -> trim(v)})

  " Go through each parameter, match the regex, extract the token values and
  " replace the 'parameters' key with the formatted version.
  let l:formatted_params = []
  for l:param in l:params
    let l:param_tokens = doge#token#extract(l:param, l:params_dict['match'], l:params_dict['match_group_names'])
    let l:format = doge#token#replace(l:param_tokens, l:params_dict['format'])
    call add(l:formatted_params, l:format)
  endfor
  let l:tokens[l:parameter_match_group_name] = l:formatted_params

  " Create the comment by replacing the tokens in the template with their
  " corresponding values.
  let l:comment = []
  for l:line in a:func_expr['comment']['template']
    let l:line_replaced = split(doge#token#replace(l:tokens, l:line), "\n")
    for l:replaced in l:line_replaced
      call add(l:comment, l:replaced)
    endfor
  endfor


  " If an existing comment exists, remove it before we insert a new one.
  let l:old_comment_pattern = fnameescape(a:func_expr['comment']['opener']) . '\_.\{-}' . fnameescape(a:func_expr['comment']['closer']) . '$'
  let l:old_comment_start_lnum = search(l:old_comment_pattern, 'bn')
  let l:old_comment_end_lnum = search(l:old_comment_pattern, 'bne')
  let l:old_comment_lines_amount = l:old_comment_end_lnum - l:old_comment_start_lnum + 1

  " When deleting the old comment and inserting the new one, it might be that
  " some things have been added or deleted.
  " For example: a new parameter might have been added.
  " If so, we have to increment the line number as well.
  " The same goes for deleting but then we subtract the line number.
  let l:adjusted_cursor_lnum = line('.') + (len(l:comment) - l:old_comment_lines_amount)
  let l:cursor_pos = [0, l:adjusted_cursor_lnum, col('.'), 0]

  " If the old comment ends at the line above our cursor, then remove it.
  " If it returns any other number then the prev line, it belongs to another
  " code block.
  let l:has_old_comment = l:old_comment_end_lnum == line('.') - 1
  if l:has_old_comment
    execute(l:old_comment_start_lnum . 'd' . l:old_comment_lines_amount)
  endif

  " Write the comment.
  call append(line('.') - 1, map(l:comment, {k, line -> doge#indent#line(line('.'), line)}))

  " Set the cursor position back at where we started.
  if l:has_old_comment
    call setpos('.', l:cursor_pos)
  endif

  " Return 1 to indicate we have succesfully inserted the comment.
  return 1
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
