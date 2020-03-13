let s:save_cpo = &cpoptions
set cpoptions&vim

let s:comment_placeholder = doge#helpers#placeholder()

""
" @public
" Generates a comment based on a given pattern.
function! doge#pattern#generate(pattern) abort
  " Assuming multiline function expressions won't be longer than 15 lines.
  let l:lines_raw = getline('.', line('.') + 15)
  let l:lines = map(l:lines_raw, { key, line ->
        \ substitute(line, b:doge_pattern_single_line_comment, '' ,'g') })

  " Skip if the cursor doesn't start with text.
  if empty(doge#helpers#trim(l:lines[0]))
    return 0
  endif

  " Check if a generator is available. Otherwise we do a fallback on the regex.
  let l:use_generator = has_key(a:pattern, 'generator')
  if l:use_generator
    let l:tokens = doge#helpers#generator(a:pattern['generator'])
    if type(l:tokens) != v:t_dict
      return 0
    endif
  else
    " Skip if the current line does not match the main pattern.
    let l:glue = has_key(a:pattern, 'normalize')
          \ && a:pattern['normalize'] == v:false ? "\n" : ' '
    let l:curr_line_raw = escape(doge#helpers#trim(join(l:lines, l:glue)), '\')
    if l:curr_line_raw !~# a:pattern['match']
      return 0
    endif

    " Remove comments to ensure we can match
    " our patterns with and without comments.
    let l:curr_line = substitute(
          \ l:curr_line_raw,
          \ b:doge_pattern_multi_line_comment,
          \ '',
          \ 'g'
          \ )

    " Extract the primary tokens.
    let l:tokens = get(doge#token#extract(
          \ l:curr_line,
          \ a:pattern['match'],
          \ a:pattern['tokens']
          \ ), 0, {})
  endif

  try
    let l:preprocess_fn = printf('doge#preprocessors#%s#tokens', doge#helpers#get_filetype())
    call function(l:preprocess_fn)(l:tokens)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

  " Split the 'parameters' token value into a list.
  if has_key(a:pattern, 'parameters') && has_key(l:tokens, 'parameters')
    let l:params_dict = a:pattern['parameters']
    let l:params = l:tokens['parameters']

    " Go through each parameter, match the regex, extract the token values and
    " replace the 'parameters' key with the formatted version.
    let l:formatted_params = []

    let l:param_tokens = l:use_generator ? l:params : doge#token#extract(
          \ l:params,
          \ l:params_dict['match'],
          \ l:params_dict['tokens']
          \ )

    " Preprocess the extracted parameter tokens.
    try
      let l:preprocess_fn = printf('doge#preprocessors#%s#parameter_tokens', doge#helpers#get_filetype())
      call function(l:preprocess_fn)(l:param_tokens)
    catch /^Vim\%((\a\+)\)\=:E117/
    endtry

    " Some values may contain pipe characters as input. This will happen in
    " typed languages where the type hint allows multiple types.
    " JavaScript/TypeScript Example: function test($p1: string, p2: Foo | Bar | Baz) { ... }
    " Therefore, we have to escape the pipe characters in the input.
    let l:param_tokens = doge#helpers#deepsubstitute(l:param_tokens, '\m|', '<Bar>', 'g')

    for l:param_token in l:param_tokens
      let l:format = doge#token#replace(
            \ l:param_token,
            \ l:params_dict['format']
            \ )
      if type(l:format) == v:t_list
        call add(l:formatted_params, join(l:format, "\n"))
      else
        call add(l:formatted_params, l:format)
      endif
    endfor
    let l:tokens['parameters'] = l:formatted_params
  endif

  " Create the comment by replacing the tokens in the template with their
  " corresponding values.
  let l:comment = []
  for l:line in a:pattern['template']
    " If empty lines are present, just append them to ensure a whiteline is
    " inserted rather then completely removed. This allows us to insert some
    " whitelines in the comment template.
    let l:line_replaced = doge#token#replace(l:tokens, l:line)
    if empty(l:line) || empty(l:line_replaced)
      call add(l:comment, '')
      continue
    elseif l:line_replaced ==# '-'
      continue
    endif

    for l:replaced in split(l:line_replaced, "\n")
      call add(l:comment, substitute(l:replaced, '\C\\t', repeat(' ', shiftwidth()), 'g'))
    endfor
  endfor

  if a:pattern['insert'] ==# 'below'
    let l:comment_lnum_insert_position = line('.')
    let l:comment_lnum_inherited_indent = line('.') + 1
  else
    let l:comment_lnum_inherited_indent = line('.')
    let l:comment_lnum_insert_position = line('.') - 1
  endif

  try
    let l:preprocess_fn = printf('doge#preprocessors#%s#insert_position', doge#helpers#get_filetype())
    let l:preprocessed_insert_position = function(l:preprocess_fn)(l:comment_lnum_insert_position)
    let l:comment_lnum_insert_position = l:preprocessed_insert_position

    " Update the inherited_indent variable based on the new insert position.
    " For now we only have to do this for languages like Python where we insert
    " below the declaration.
    if a:pattern['insert'] ==# 'below'
      let l:comment_lnum_inherited_indent = l:comment_lnum_insert_position + 1
    endif
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

  " vint: next-line -ProhibitUnusedVariable
  let l:Indent = function('doge#indent#add', [l:comment_lnum_inherited_indent])

  " Indent the comment.
  let l:comment = map(l:comment, { k, line -> l:Indent(line) })

  " Write the comment.
  call append(l:comment_lnum_insert_position, l:comment)

  " Enable interactive mode.
  if g:doge_comment_interactive == v:true
    if a:pattern['insert'] ==# 'below'
      let l:todo_match = search(s:comment_placeholder, 'nW', l:comment_lnum_insert_position + len(l:comment))
    else
      let l:todo_match = search(s:comment_placeholder, 'bnW', l:comment_lnum_insert_position + 1)
    endif
    if l:todo_match != 0
      let l:todo_count = doge#helpers#count(
            \ s:comment_placeholder,
            \ (l:comment_lnum_insert_position + 1),
            \ (l:comment_lnum_insert_position + len(l:comment))
            \ )
      if l:todo_count > 0
        let b:doge_interactive = {
              \ 'comment': l:comment,
              \ 'lnum_comment_start_pos': (l:comment_lnum_insert_position + 1),
              \ 'lnum_comment_end_pos': (l:comment_lnum_insert_position + len(l:comment)),
              \ }
        " Go to the top of the comment and select the first TODO.
        exe l:comment_lnum_insert_position + 1
        call search(s:comment_placeholder, 'W')
        call execute("normal! gno\<C-g>", 'silent!')
      endif
    endif
  endif

  " Return 1 to indicate we have succesfully inserted the comment.
  return 1
endfunction

""
" @public
" Generates a template for a custom doc standard, and places it in
" after/ftplugin/{&ft}.vim
function! doge#pattern#custom(name) abort
  if &filetype ==# ''
    echo '[DoGe] A filetype is required in order to create a custom pattern.'
    return 0
  endif

  let l:this_ft = &filetype

  " Maybe there aren't available doc standards for this filetype.
  if !exists('b:doge_patterns')
    let b:doge_patterns = {}
    let l:unsupported_filetype = 1
    let l:comment = substitute(escape(&commentstring, '\/*.~$'), '%s', '.\\{-}', '')
    let l:comment = string(printf('\m%s$', l:comment))
  else
    let l:unsupported_filetype = 0
  endif

  " If the given name is an existing doc standard, use it as base for our
  " template, otherwise create an empty one.
  if has_key(b:doge_patterns, a:name)
    let l:template = deepcopy(b:doge_patterns[a:name][0])
    let l:name = a:name . '_custom'
  else
    let l:template = {
          \   'match': '',
          \   'tokens': ['parameters'],
          \   'template': [],
          \   'insert': 'above',
          \   'parameters': {
          \     'match': '',
          \     'tokens': '',
          \     'format': '',
          \   },
          \ }
    let l:name = a:name
  endif

  " Get the path for the after/ftplugin/ file and open it if it exists,
  " otherwise create a new file with an appropriate path.
  let l:path = ''
  for l:p in ['~/.vim', '~/vimfiles']
    if isdirectory(expand(l:p))
      let l:path = expand(l:p)
      break
    endif
  endfor
  if has('nvim') && empty(l:path)
    let l:path = stdpath('config')
  endif
  if !empty(l:path)
    try
      if !exists(l:path . '/after/ftplugin/')
        call mkdir(l:path . '/after/ftplugin/', 'p')
      endif
      catch /^Vim\%((\a\+)\)\=:E739/
    endtry
    let l:path .= '/after/ftplugin/' . l:this_ft . '.vim'
  endif
  if filereadable(l:path)
    let l:cmd = &showtabline ? 'tabedit' : 'split'
    call execute(l:cmd . fnameescape(l:path), 'silent!')
    return 1
  elseif bufexists(l:path)
    call execute('drop ' . fnameescape(l:path), 'silent!')
  else
    call execute(&showtabline ? 'tabnew' : 'new', 'silent!')
    setfiletype vim
    if !empty(l:path)
      call execute('file ' . fnameescape(l:path), 'silent!')
    endif
  endif

  " Generate the template and paste it at the top of the file.
  let l:doc = []
  call add(l:doc, '" Preserve existing doge settings.')
  call add(l:doc, "let b:doge_patterns = get(b:, 'doge_patterns', {})")
  call add(l:doc, "let b:doge_supported_doc_standards = get(b:, 'doge_supported_doc_standards', [])")
  call add(l:doc, "if index(b:doge_supported_doc_standards, '" . l:name . "') < 0")
  call add(l:doc, "call add(b:doge_supported_doc_standards, '" . l:name . "')")
  call add(l:doc, 'endif')
  call add(l:doc, '')
  if l:unsupported_filetype
    call add(l:doc, '" DoGe uses these patterns to identify comments, change if needed.')
    call add(l:doc, 'let b:doge_pattern_single_line_comment = ' . l:comment)
    call add(l:doc, 'let b:doge_pattern_multi_line_comment = ' . l:comment)
    call add(l:doc, '')
  endif
  call add(l:doc, '" Set the new doc standard as default.')
  call add(l:doc, "let b:doge_doc_standard = '" . l:name . "'")
  call add(l:doc, '')
  call add(l:doc, '" Ensure we do not overwrite an existing doc standard.')
  call add(l:doc, "if !has_key(b:doge_patterns, '" . l:name . "')")
  call add(l:doc, "let b:doge_patterns['" . l:name . "'] = [")
  call add(l:doc, "\\  {")
  call add(l:doc, "\\    'match': " . string(l:template.match) . ',')
  call add(l:doc, "\\    'tokens': " . string(l:template.tokens) . ',')
  for l:key in l:template.tokens
    if has_key(l:template, l:key)
      call add(l:doc, "\\    '" . l:key . "': {")
      call add(l:doc, "\\      'match': " . string(l:template[l:key].match) . ',')
      call add(l:doc, "\\      'tokens': " . string(l:template[l:key].tokens) . ',')
      call add(l:doc, "\\      'format': " . string(l:template[l:key].format) . ',')
      call add(l:doc, '\    },')
    endif
  endfor
  call add(l:doc, "\\    'insert': " . string(l:template.insert) . ',')
  call add(l:doc, "\\    'template': [")
  for l:line in l:template.template
    call add(l:doc, '\      ' . string(l:line) . ',')
  endfor
  call add(l:doc, '\    ],')
  call add(l:doc, '\  },')
  call add(l:doc, '\]')
  call add(l:doc, 'endif')
  call setreg('"', l:doc)
  1
  call execute("normal! \"\"P'[=']Gdipgg", 'silent!')
  call execute('w', 'silent!')
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
