let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @private
" Replace all tokens in the text parameter based on a given dictionary
" containing all the tokens.
function! s:token_replace(tokens, text) abort
  " Ensure the input is a string.
  if type(a:text) != v:t_string
    return a:text
  endif

  let l:text = deepcopy(a:text)
  let l:empty_conditional_pattern_value = 0

  for [l:token, l:token_value] in items(a:tokens)
    let l:formatted_token = printf('{%s}', l:token)

    " Tokens can be in the following 2 formats:
    " - {name}
    " - {name|default}
    " so if the line contains a pipe character with a default value then we
    " grab that value and remove it from the text.
    let l:stripped_token = matchlist(l:text, '\m{\(' . l:token . '\)\%(|\([^}]*\)\)\?}')
    let l:token_default_value = doge#helpers#trim(get(l:stripped_token, 2, ''))
    let l:has_token_default_value = !empty(l:token_default_value)

    let l:text = substitute(
          \ l:text,
          \ '{' . l:token . '|' . fnameescape(l:token_default_value) . '}',
          \ '{' . l:token . '}',
          \ 'g'
          \ )

    let l:conditional_pattern = '\m%(' . l:token . '|\(.\{-}\))%'
    if l:text =~# l:conditional_pattern
      let l:conditional_pattern_replacement_value = '\1'
      if (type(l:token_value) == v:t_string && empty(l:token_value))
            \ || (type(l:token_value) == v:t_list && len(l:token_value) == 0)
            \ || (type(l:token_value) == type(v:null) && l:token_value == v:null)
            \ || (type(l:token_value) == v:t_bool && l:token_value == v:false)
        let l:conditional_pattern_replacement_value = ''
        let l:empty_conditional_pattern_value = 1
      endif

      let l:text = substitute(
            \ l:text,
            \ l:conditional_pattern,
            \ l:conditional_pattern_replacement_value,
            \ 'g'
            \)
    endif

    " Skip if the token does not exists in the text.
    if l:text !~# l:formatted_token
      continue
    endif

    " The value of a token might be a list, for example:
    "   { 'parameters': ['@param $p1 string TODO', '@param $p2 int TODO'] }
    " and if this is the case then do a replacement for each item.
    if type(l:token_value) == v:t_list
      let l:multiline_replacement = []
      for l:multi_line_value in l:token_value
        if empty(l:multi_line_value) && l:has_token_default_value
          call add(l:multiline_replacement,
                \ substitute(l:text, l:formatted_token, l:token_default_value, 'g'))
        elseif !empty(l:multi_line_value)
          call add(l:multiline_replacement,
                \ substitute(l:text, l:formatted_token, escape(l:multi_line_value, '\'), 'g'))
        endif
      endfor
      let l:text = join(l:multiline_replacement, "\n")
    else

      " A return type in some languages mightbe definedas 'TypeA & TypeB'.
      " For the sake of the substitution process, we need to escape the '&'.
      if !empty(l:token_value)
        let l:token_value = substitute(l:token_value, '&', '\\&', 'g')
      endif

      if empty(l:token_value) && l:has_token_default_value
        let l:text = substitute(l:text, l:formatted_token, l:token_default_value, 'g')
      elseif !empty(l:token_value)
        let l:text = substitute(l:text, l:formatted_token, l:token_value, 'g')
      endif
    endif
  endfor

  " Replace !<name> with [TODO:<name>].
  let l:text = substitute(l:text, '\m!\([[:alpha:]-]\+\)', '[TODO:\1]', 'g')

  " Replace 2 or more white-spaces with 1 single white-space, except for leading
  " white-spaces and/or newlines. Those should be preserved.
  let l:text = substitute(l:text, '\m\(^\|\s\|\n\)\@<!\s\{2,}', ' ', 'g')

  " Remove trailing whitespace.
  let l:text = substitute(l:text, '\m\s\+$', '', 'g')

  " Replace the <Bar> back to a pipe character.
  let l:text = substitute(l:text, '\m<Bar>', '|', 'g')

  " Empty lines will be added to the empty in the doge#pattern#generate()
  " function and to indicate it should be prevented from rendering we have to
  " add some kind of format. We use a dash '-' as an indication that it should
  " be removed.
  if l:empty_conditional_pattern_value == v:true && empty(l:text)
    return '-'
  endif

  return l:text
endfunction

""
" @public
" Replace all tokens in the text parameter based on a given dictionary
" containing all the tokens.
function! doge#token#replace(tokens, text) abort
  let l:text = deepcopy(a:text)
  if type(l:text) == v:t_list
    return map(l:text, { key, line -> s:token_replace(a:tokens, line) })
  elseif type(l:text) == v:t_string
    return s:token_replace(a:tokens, l:text)
  endif
endfunction

""
" @public
" Extract all the tokens in a text by creating a dictionary holding key-value
" pairs where the 'key' is the given group name and the 'value' the captured
" value of that group. The regex groups in the 'regex' parameter should be
" symmetrical in length to the 'regex_group_names' parameter.
function! doge#token#extract(text, regex, regex_group_names) abort
  let l:submatches = []
  call substitute(a:text, a:regex, '\=add(l:submatches, submatch(0))', 'g')

  let l:matches = map(l:submatches, { k, v -> doge#helpers#trim(v) })
  let l:tokens = []

  " We can expect a list of matches like:
  "   ['val1', 'val2', '', 'val3']
  " and a list of groups with equal length to name them:
  "   ['type', 'name', 'default', 'return']
  "
  " We create a dict where every value will be under its name, like so:
  " {
  "   'type': 'val1',
  "   'name': 'val2',
  "   'type': '',
  "   'type': 'val1',
  " }
  if len(l:matches) > 0 && len(a:regex_group_names) > 0
    for l:match in l:matches
      let l:values = matchlist(l:match, a:regex)
      let l:group = {}

      for l:token in a:regex_group_names
        let l:group_idx = index(a:regex_group_names, l:token)
        let l:token_value = l:values[l:group_idx + 1]
        let l:group[l:token] = doge#helpers#trim(l:token_value)
      endfor

      call add(l:tokens, l:group)
    endfor
  endif

  return l:tokens
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
