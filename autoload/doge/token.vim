let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @private
" Replace all tokens in the text parameter based on a given dictionary
" containing all the tokens.
function! s:token_replace(tokens, text) abort
  " Ensure the input is a string.
  if type(a:text) isnot v:t_string
    return a:text
  endif

  let l:text = deepcopy(a:text)

  " When the text starts with '!' it indicates that we should empty the string
  " the token did not got replaced to ensure no additional markup is left.
  let l:return_empty_on_fail = l:text =~# '\m^!'
  if l:return_empty_on_fail
    " Remove the '!' character
    let l:text = l:text[1:]
  endif

  " Tokens can be in the following 2 formats:
  " - {name}
  " - {name|default}
  " so if the line contains a pipe character with a default value then we
  " grab that value and remove it from the text.
  let l:stripped_line = matchlist(l:text, '\m{\([^|{}]\+\)\%(\(|[^}]*\)\)\?}')
  let l:default_token_value = trim(get(l:stripped_line, 2, '|'))[1:]
  let l:has_default_token_value = !empty(trim(get(l:stripped_line, 2, '')))
  if l:has_default_token_value
    let l:text = substitute(
          \ l:text,
          \ '{' . trim(get(l:stripped_line, 1, '')) . '|' . fnameescape(get(l:stripped_line, 2, '|')[1:]) . '}',
          \ '{' . trim(get(l:stripped_line, 1, '')) . '}',
          \ 'g'
          \ )
  endif

  let l:has_replaced_tokens = 0
  for [l:token, l:value] in items(a:tokens)
    let l:formatted_token = '{' . l:token . '}'

    " Skip if the token does not exists in the text.
    if l:text !~# l:formatted_token
      continue
    endif

    " The value of a token might be a list, for example:
    "   { 'format': ['someRandomText', '{token|default}'] }
    " and if this is the case then do a replacement for each item.
    if type(l:value) is v:t_list
      let l:multiline_replacement = []
      for l:item in l:value
        if empty(l:item) && l:has_default_token_value
          call add(l:multiline_replacement, substitute(l:text, l:formatted_token, l:default_token_value, 'g'))
        elseif !empty(l:item)
          call add(l:multiline_replacement, substitute(l:text, l:formatted_token, escape(l:item, '\'), 'g'))
        endif
      endfor
      let l:text = join(l:multiline_replacement, "\n")
    else
      if empty(l:value) && l:has_default_token_value
        let l:text = substitute(l:text, l:formatted_token, l:default_token_value, 'g')
      elseif !empty(l:value)
        let l:text = substitute(l:text, l:formatted_token, l:value, 'g')
      endif
    endif

    if l:text !~# l:formatted_token
      let l:has_replaced_tokens = 1
      " break
    endif
  endfor

  if l:has_replaced_tokens is 0 && l:return_empty_on_fail is 1
    return ''
  endif

  " Replace double whitespace with a single.
  let l:text = substitute(l:text, ' \+', ' ', 'g')

  " Remove leading whitespace.
  let l:text = substitute(l:text, ' \+$', '', 'g')

  " For JSDoc we replace the typing 'typeA | type B' with 'typeA|typeB'.
  let l:text = substitute(l:text, '\s*|\s*', '|', 'g')

  return l:text
endfunction

""
" @public
" Replace all tokens in the text parameter based on a given dictionary
" containing all the tokens.
function! doge#token#replace(tokens, text) abort
  let l:text = deepcopy(a:text)
  if type(l:text) is v:t_list
    return map(l:text, {key, line -> <SID>token_replace(a:tokens, line)})
  elseif type(l:text) is v:t_string
    return <SID>token_replace(a:tokens, l:text)
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

  let l:matches = map(l:submatches, {key, val -> trim(val)})
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
        let l:group[l:token] = trim(l:token_value)
      endfor

      call add(l:tokens, l:group)
    endfor
  endif

  return l:tokens
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
