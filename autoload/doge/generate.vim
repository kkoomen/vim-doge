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

  let l:curr_line = escape(trim(join(l:lines, ' ')), '\')
  if l:curr_line !~# a:func_expr['match']
    return 0
  endif

  let l:tokens = doge#token#extract(l:curr_line, a:func_expr['match'], a:func_expr['match_group_names'])

  " Prepare tokens and parameter values
  let l:params_dict = a:func_expr['parameters']
  let l:parameter_match_group_name = l:params_dict['parent_match_group_name']
  let l:params = map(split(l:tokens[l:parameter_match_group_name], ','), {k, v -> trim(v)})

  " Go through each parameter, match the regex, extract the token values and
  " replace the 'parameters' key with the formatted version.
  let l:formatted_params = []
  for l:param in l:params
    let l:param_tokens = doge#token#extract(l:param, l:params_dict['match'], l:params_dict['match_group_names'])
    let l:format = doge#token#replace(l:param_tokens, l:params_dict['format'])
    let l:format = join(filter(l:format, 'v:val !=# ""'), ' ')
    call add(l:formatted_params, l:format)
  endfor
  let l:tokens[l:parameter_match_group_name] = l:formatted_params

  " Create the comment by replacing the tokens in the 'comment_template'
  " with their corresponding values.
  let l:comment = []
  for l:line in a:func_expr['comment_template']
    let l:line_replaced = doge#token#replace(l:tokens, l:line)
    if type(l:line_replaced) == type([])
      for l:replaced in l:line_replaced
        call add(l:comment, l:replaced)
      endfor
    else
      call add(l:comment, l:line_replaced)
    endif
  endfor

  call append(line('.') - 1, map(l:comment, {k, line -> doge#indent#string(line('.'), line)}))
  return 1
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
