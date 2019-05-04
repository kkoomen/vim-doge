" ==============================================================================
" Filename: token.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#token#replace_string(tokens, text) abort
  " Ensure the input is a string.
  if type(a:text) != type('')
    return a:text
  endif

  let l:text = deepcopy(a:text)

  " Grab all the tokens in the text by matching on the format: {name|default}.
  let l:text_tokens = filter(map(split(l:text, ' '), {k, v -> matchstr(v, '\({[^}]\+}\)')}), 'v:val !=# ""')
  for l:text_token in l:text_tokens
    " The text can be in the following scenarios:
    " - {name}
    " - {name|default}
    " so if the line contains a pipe character with a default value then we
    " grab that value and remove it from the text.
    let l:stripped_text_token = matchlist(l:text_token, '{\(.*\)|\(.*\)}')
    let l:default_token_value = trim(get(l:stripped_text_token, 2, ''))
    if !empty(l:default_token_value)
      let l:formatted_text_token = '{' . trim(get(l:stripped_text_token, 1, '')) . '}'
      let l:text = substitute(l:text, l:text_token, l:formatted_text_token, 'g')
      let l:text_token = l:formatted_text_token
    endif

    for [l:token, l:value] in items(a:tokens)
      let l:formatted_token = '{' . l:token . '}'

      " Skip if the token does not exists in the text.
      if l:text_token !~# l:formatted_token
        continue
      endif

      " The value of a token might be a list, for example:
      "   { 'format': ['someRandomText', '{token|default}'] }
      " and if this is the case then do a replacement for each item.
      if type(l:value) == type([])
        let l:multiline_replacement = []
        for l:item in l:value
          if empty(l:item)
            call add(l:multiline_replacement, substitute(l:text, l:formatted_token, l:default_token_value, 'g'))
          else
            call add(l:multiline_replacement, substitute(l:text, l:formatted_token, escape(l:item, '\'), 'g'))
          endif
        endfor
        let l:text = join(l:multiline_replacement, "\n")
      else
        if empty(l:value)
          let l:text = substitute(l:text, l:formatted_token, l:default_token_value, 'g')
        else
          let l:text = substitute(l:text, l:formatted_token, l:value, 'g')
        endif
      endif
    endfor
  endfor

  return substitute(l:text, ' \+', ' ', 'g')
endfunction

function! doge#token#replace(tokens, text) abort
  let l:text = deepcopy(a:text)
  if type(l:text) == type([])
    return map(l:text, {key, line -> doge#token#replace_string(a:tokens, line)})
  elseif type(l:text) == type('')
    return doge#token#replace_string(a:tokens, l:text)
  endif
endfunction

function! doge#token#extract(line, regex, regex_group_names) abort
  let l:matches = map(matchlist(a:line, a:regex), {key, val -> trim(val)})
  let l:tokens = {}

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
    for l:token in a:regex_group_names
      let l:index = index(a:regex_group_names, l:token)
      let l:match = l:matches[l:index + 1]
      let l:tokens[l:token] = l:match
    endfor
  endif

  return l:tokens
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
