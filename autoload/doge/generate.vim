let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#generate#pattern(pattern) abort
  " Assuming multiline function expressions won't be longer than 15 lines.
  let l:lines = getline('.', line('.') + 15)

  " Skip if the cursor doesn't start with text.
  if empty(trim(get(l:lines, 0)))
    return 0
  endif

  " Skip immediately if the current line does not match.
  let l:curr_line = escape(trim(join(l:lines, ' ')), '\')
  if l:curr_line !~# a:pattern['match']
    return 0
  endif

  " Extract the primary tokens.
  let l:tokens = get(doge#token#extract(l:curr_line, a:pattern['match'], a:pattern['match_group_names']), 0)

  " Split the 'parameters' token value into a list.
  if has_key(a:pattern, 'parameters')
    let l:params_dict = a:pattern['parameters']
    let l:params = l:tokens['parameters']

    " Go through each parameter, match the regex, extract the token values and
    " replace the 'parameters' key with the formatted version.
    let l:param_tokens = doge#token#extract(l:params, l:params_dict['match'], l:params_dict['match_group_names'])
    let l:formatted_params = []
    for l:param_token in l:param_tokens
      let l:format = doge#token#replace(l:param_token, l:params_dict['format'])
      let l:format = join(filter(l:format, 'v:val !=# ""'), ' ')
      call add(l:formatted_params, l:format)
    endfor
    let l:tokens['parameters'] = l:formatted_params
  endif

  " Create the comment by replacing the tokens in the template with their
  " corresponding values.
  let l:comment = []
  for l:line in a:pattern['comment']['template']
    " If empty lines are present, just append them to ensure a whiteline is
    " inserted rather then completely removed. This allows us to insert some
    " whitelines in the comment template.
    if empty(l:line)
      call add(l:comment, l:line)
      continue
    endif

    let l:line_replaced = split(doge#token#replace(l:tokens, l:line), "\n")
    for l:replaced in l:line_replaced
      call add(l:comment, l:replaced)
    endfor
  endfor

  " Indent the comment. By doing this we can compare the current comment its
  " indent vs the new comment its indent and detect whether the indentation
  " changed to. If so, it will also be updated.
  if a:pattern['comment']['insert'] ==# 'below'
    let l:comment_lnum_inherited_indent = line('.') + 1
  else
    let l:comment_lnum_inherited_indent = line('.')
  endif
  let l:comment = map(l:comment, {k, line -> doge#indent#add(l:comment_lnum_inherited_indent, line)})

  " If an existing comment exists, remove it before we insert a new one.
  " We start off by creating the regex pattern
  let l:old_comment_regex = '\m' . fnameescape(a:pattern['comment']['opener']) . '\_.\{-}' . fnameescape(a:pattern['comment']['closer']) . '$'

  if a:pattern['comment']['insert'] ==# 'below'
    let l:old_comment_start_lnum = search(l:old_comment_regex, 'n')
    let l:old_comment_end_lnum = search(l:old_comment_regex, 'ne')
    let l:has_old_comment = l:old_comment_start_lnum == line('.') + 1
  else
    let l:old_comment_start_lnum = search(l:old_comment_regex, 'bn')
    let l:old_comment_end_lnum = search(l:old_comment_regex, 'bne')
    let l:has_old_comment = l:old_comment_end_lnum == line('.') - 1
  endif
  let l:old_comment_lines_amount = l:old_comment_end_lnum - l:old_comment_start_lnum + 1


  " When deleting the old comment and inserting the new one, it might be that
  " some things have been added or deleted.
  " For example: a new parameter might have been added.
  " If so, we have to increment the line number as well.
  " The same goes for deleting but then we subtract the line number.
  if a:pattern['comment']['insert'] ==# 'below'
    let l:adjusted_cursor_lnum = line('.') + (1 + len(l:comment) - l:old_comment_lines_amount)
  else
    let l:adjusted_cursor_lnum = line('.') + (len(l:comment) - l:old_comment_lines_amount)
  endif
  let l:cursor_pos = [0, l:adjusted_cursor_lnum, col('.'), 0]

  if l:has_old_comment
    let l:temp_cursor_pos = getpos('.')

    " Preserve the old comment before deleting.
    let l:old_comment = getline(l:old_comment_start_lnum, l:old_comment_end_lnum)
    let l:comment_has_changed = doge#comment#has_changed(l:old_comment, l:comment, a:pattern['comment']['trim_comparision_check'])

    " Delete the old comment.
    if l:comment_has_changed == 1
      execute(l:old_comment_start_lnum . 'd' . l:old_comment_lines_amount)
    endif

    " If we have deleted a comment that is 'below' the function expression then
    " our cursor moved a line too much, so revert its position. This is the
    " same for 'above' the function expression, but we land on our old position
    " automatically, hence that we don't have to take that situation into
    " account.
    if a:pattern['comment']['insert'] ==# 'below'
      call setpos('.', l:temp_cursor_pos)
    endif
  endif

  if a:pattern['comment']['insert'] ==# 'below'
    let l:comment_lnum_insert_position = line('.')
  else
    let l:comment_lnum_insert_position = line('.') - 1
  endif

  " Write the comment if it changed or is new.
  if (l:has_old_comment == 1 && l:comment_has_changed == 1) || l:has_old_comment == 0
    call append(
          \ l:comment_lnum_insert_position,
          \ l:comment
          \ )
  else
    echo '[DoGE] Comment is up-to-date, skipping'
  endif

  if l:has_old_comment == 1 && l:comment_has_changed == 1 && a:pattern['comment']['insert'] ==# 'above'
    call setpos('.', l:cursor_pos)
  endif

  " Return 1 to indicate we have succesfully inserted the comment.
  return 1
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
