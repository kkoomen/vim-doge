" ==============================================================================
" Filename: doge.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#replace_tokens(text, tokens) abort
  if type(a:text) == type([])
    let l:text = []
    for l:line in a:text
      for [l:token, l:value] in items(a:tokens)
        let l:formatted_token = '{' . l:token . '}'
        if l:line !~# l:formatted_token
          continue
        endif
        if type(l:value) == type([])
          let l:multiline_replacement = []
          for l:item in l:value
            call add(l:multiline_replacement, substitute(l:line, l:formatted_token, escape(l:item, '\'), 'g'))
          endfor
          let l:line = join(l:multiline_replacement, "\n")
        else
          let l:line = substitute(l:line, l:formatted_token, l:value, 'g')
        endif
      endfor
      call add(l:text, l:line)
    endfor
    return l:text
  elseif type(a:text) == type('')
    for [l:token, l:value] in items(a:tokens)
      let l:formatted_token = '{' . l:token . '}'
      if a:text !~# l:formatted_token
        continue
      endif
      if type(l:value) == type([])
        let l:multiline_replacement = []
        for l:item in l:value
          call add(l:multiline_replacement, substitute(a:text, l:formatted_token, escape(l:item, '\'), 'g'))
        endfor
        return l:multiline_replacement
      else
        return substitute(a:text, l:formatted_token, l:value, 'g')
      endif
    endfor
    return a:text
  endif
endfunction

function! doge#extract_tokens(line, regex, regex_group_names) abort
  let l:matches = map(matchlist(a:line, a:regex), {key, val -> trim(val)})
  let l:tokens = {}

  if len(l:matches) > 0 && len(a:regex_group_names) > 0
    for l:token in a:regex_group_names
      let l:index = index(a:regex_group_names, l:token)
      let l:match = l:matches[l:index + 1]
      let l:tokens[l:token] = l:match
    endfor
  endif

  return l:tokens
endfunction

function! doge#generate() abort
  if !exists('b:doge_func_expr') && !exists('b:doge_var_expr')
    echo 'No b:doge_func_expr or b:doge_var_expr found for current filetype.'
  endif

  if exists('b:doge_func_expr')
    for l:func_expr in get(b:, 'doge_func_expr')
      " Assuming multiline function expressions won't be longer than 15 lines.
      let l:lines = getline('.', line('.') + 15)
      if empty(trim(get(l:lines, 0)))
        continue
      endif

      let l:curr_line = escape(trim(join(l:lines, ' ')), '\')
      if l:curr_line !~# l:func_expr['match']
        continue
      endif

      let l:tokens = doge#extract_tokens(l:curr_line, l:func_expr['match'], l:func_expr['match_group_names'])

      " Prepare tokens and parameter values
      let l:params_dict = l:func_expr['parameters']
      let l:parameter_match_group_name = l:params_dict['parent_match_group_name']
      let l:params = map(split(l:tokens[l:parameter_match_group_name], ','), {k, v -> trim(v)})

      let l:formatted_params = []
      for l:param in l:params
        let l:param_tokens = doge#extract_tokens(l:param, l:params_dict['match'], l:params_dict['match_group_names'])
        let l:format = doge#replace_tokens(l:params_dict['format'], l:param_tokens)
        let l:format = join(filter(l:format, 'v:val !=# ""'), ' ')
        call add(l:formatted_params, l:format)
      endfor
      let l:tokens[l:parameter_match_group_name] = l:formatted_params

      " Create the comment
      let l:comment = []
      for l:line in l:func_expr['comment_template']
        let l:line_replaced = doge#replace_tokens(l:line, l:tokens)
        if type(l:line_replaced) == type([])
          for l:replaced in l:line_replaced
            call add(l:comment, l:replaced)
          endfor
        else
          call add(l:comment, l:line_replaced)
        endif
      endfor

      call append(line('.') - 1, map(l:comment, {k, line -> doge#indent#string(line('.'), line)}))
    endfor
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
