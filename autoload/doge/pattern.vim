let s:save_cpo = &cpoptions
set cpoptions&vim

let s:comment_placeholder = doge#helpers#placeholder()

""
" @public
" Generates a comment based on a given pattern.
function! doge#pattern#generate(pattern) abort
  let l:tokens = doge#helpers#parser(a:pattern['nodeTypes'])
  if type(l:tokens) != v:t_dict
    return 0
  endif

  try
    let l:preprocess_fn = printf('doge#preprocessors#%s#tokens', doge#helpers#get_filetype())
    call function(l:preprocess_fn)(l:tokens)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

  for l:key in ['parameters', 'typeParameters', 'exceptions']
    if has_key(a:pattern, l:key) && has_key(l:tokens, l:key)
      let l:params = l:tokens[l:key]

      try
        " Preprocess the extracted parameter tokens.
        " Substitute the l:key from NamesLikeThis to names_like_this.
        let l:preprocess_fn = printf(
              \ 'doge#preprocessors#%s#%s_tokens',
              \ doge#helpers#get_filetype(),
              \ substitute(l:key, '\(\<\u\l\+\|\l\+\)\(\u\)', '\l\1_\l\2', 'g'),
              \)
        call function(l:preprocess_fn)(l:params)
      catch /^Vim\%((\a\+)\)\=:E117/
      endtry

      let l:formatted_params = []

      " Some values may contain pipe characters as input. This will happen in
      " typed languages where the type hint allows multiple types.
      "
      " JavaScript/TypeScript Example:
      "   function test($p1: string, p2: Foo | Bar | Baz) { ... }
      "
      " Therefore, we have to escape the pipe characters in the input.
      let l:params = doge#helpers#deepsubstitute(l:params, '\m|', '<Bar>', 'g')

      for l:param in l:params
        let l:format = doge#token#replace(
              \ l:param,
              \ a:pattern[l:key]['format']
              \ )

        if type(l:format) == v:t_list
          call add(l:formatted_params, join(l:format, "\n"))
        else
          call add(l:formatted_params, l:format)
        endif
      endfor
      let l:tokens[l:key] = l:formatted_params
    endif
  endfor

  let l:template = deepcopy(a:pattern['template'])

  " Preprocess the template.
  try
    let l:preprocess_fn = printf('doge#preprocessors#%s#template', doge#helpers#get_filetype())
    call function(l:preprocess_fn)(l:template)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

  " Create the comment by replacing the tokens in the template with their
  " corresponding values.
  let l:comment = []
  for l:line in l:template
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

  if b:doge_insert ==# 'below'
    let l:comment_indent = shiftwidth()
    let l:comment_lnum_insert_position = line('.')
  else
    let l:comment_indent = 0
    let l:comment_lnum_insert_position = line('.') - 1
  endif

  try
    let l:preprocess_fn = printf('doge#preprocessors#%s#insert_position', doge#helpers#get_filetype())
    let l:preprocessed_insert_position = function(l:preprocess_fn)(l:comment_lnum_insert_position)
    let l:comment_lnum_insert_position = l:preprocessed_insert_position
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

  " vint: next-line -ProhibitUnusedVariable
  let l:Indent = function('doge#indent#add', [l:comment_indent])

  " Indent the comment.
  let l:comment = map(l:comment, { k, line -> l:Indent(line) })

  " Write the comment.
  call append(l:comment_lnum_insert_position, l:comment)

  " Enable interactive mode.
  if g:doge_comment_interactive == v:true
    if b:doge_insert ==# 'below'
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
  if empty(&filetype)
    echo '[DoGe] A filetype is required in order to create a custom pattern.'
    return 0
  endif

  let l:this_ft = &filetype

  " Maybe there aren't available doc standards for this filetype.
  if !exists('b:doge_patterns')
    let b:doge_patterns = {}
    let l:unsupported_filetype = 1
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
          \   'parameters': {
          \     'format': '',
          \   },
          \   'template': [],
          \ }
    let l:name = a:name
  endif

  " Get the path for the after/ftplugin/ file and open it if it exists,
  " otherwise create a new file with an appropriate path.
  let l:path = ''
  for l:p in ['~/.vim', '~/vimfiles']
    let l:p = expand(l:p)
    if match(&runtimepath, l:p) >= 0
      let l:path = l:p
      break
    endif
  endfor
  if empty(l:path)
    if exists('*stdpath')
      let l:path = stdpath('config')
    else
      let l:path = getcwd()
    endif
  endif
  let l:path .= '/after/ftplugin/' . l:this_ft . '.vim'
  if filereadable(l:path)
    let l:cmd = &showtabline ? 'tabedit' : 'split'
    call execute(l:cmd . fnameescape(l:path), 'silent!')
    return 1
  elseif bufexists(l:path)
    call execute('drop ' . fnameescape(l:path), 'silent!')
  else
    call execute(&showtabline ? 'tabnew' : 'new', 'silent!')
    setfiletype vim
    call execute('file ' . fnameescape(l:path), 'silent!')
  endif

  " Generate the template and paste it at the top of the file.
  let l:doc = []
  call add(l:doc, '" Preserve existing doge settings.')
  call add(l:doc, "let b:doge_patterns = get(b:, 'doge_patterns', {})")
  call add(l:doc, "let b:doge_supported_doc_standards = get(b:, 'doge_supported_doc_standards', [])")
  call add(l:doc, "if index(b:doge_supported_doc_standards, '" . l:name . "') < 0")
  call add(l:doc, "  call add(b:doge_supported_doc_standards, '" . l:name . "')")
  call add(l:doc, 'endif')
  call add(l:doc, '')
  if l:unsupported_filetype
    call add(l:doc, "let b:doge_parser = 'PARSER_NAME_HERE'")
    call add(l:doc, "let b:doge_insert = 'above'")
    call add(l:doc, '')
  endif
  call add(l:doc, '" Set the new doc standard as default.')
  call add(l:doc, "let b:doge_doc_standard = '" . l:name . "'")
  call add(l:doc, '')
  call add(l:doc, '" Ensure we do not overwrite an existing doc standard.')
  call add(l:doc, "if !has_key(b:doge_patterns, '" . l:name . "')")
  call add(l:doc, "  let b:doge_patterns['" . l:name . "'] = [")
  call add(l:doc, "        \\  {")
  call add(l:doc, "        \\    'nodeTypes': ['NODE_TYPE_A', 'NODE_TYPE_B'],")
  call add(l:doc, "        \\    'parameters': {")
  call add(l:doc, "        \\      'format': '@param {name} !description',")
  call add(l:doc, "        \\    },")
  call add(l:doc, "        \\    'template': [")
  for l:line in l:template.template
    call add(l:doc, '        \      ' . string(l:line) . ',')
  endfor
  call add(l:doc, '        \    ],')
  call add(l:doc, '        \  },')
  call add(l:doc, '        \]')
  call add(l:doc, 'endif')
  call execute(':1,$d')
  call setreg('"', l:doc)
  1
  call execute("normal! \"\"PGdd", 'silent!')
endfunction

let &cpoptions = s:save_cpo
