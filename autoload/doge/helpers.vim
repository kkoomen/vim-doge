let s:save_cpo = &cpoptions
set cpoptions&vim

let s:no_trim = (has('nvim') && !has('nvim-0.3.2')) ||
      \         (!has('nvim') && (v:version < 800 || !has('patch-8.0.1630')))

""
" @public
" @function doge#helpers#count({word} [, {lnum_start}, {lnum_end} ])
" Returns the amount of occurences of a word.
"
" The 2nd and 3rd arguments, named lnum_start and lnum_end, can be used to limit
" the count in-between a range of lines. The default value for the range will be
" '%', indicating a full buffer count.
" NOTE: When lnum_start is a bigger number than lnum_end then these values
" will be flipped to ensure a correct range format.
function! doge#helpers#count(word, ...) abort
  let l:cursor_pos = getpos('.')
  let l:range = '%'
  if (type(a:1) == v:t_number && type(a:2) == v:t_number)
    if a:1 < a:2
      let l:range = printf('%s,%s', a:1, a:2)
    else
      " When a:1 is a bigger number than a:2 then these values will be flipped
      " to ensure a correct range format.
      let l:range = printf('%s,%s', a:2, a:1)
    endif
  endif

  try
    let l:cnt = execute(l:range . 's/' . a:word . '//gn', 'silent!')
  catch /^Vim\%((\a\+)\)\=:E486/
    return 0
  endtry
  call setpos('.', l:cursor_pos)
  return doge#helpers#trim(strpart(l:cnt, 0, stridx(l:cnt, ' ')))
endfunction

""
" @public
" Creates a sequence of keys which can be used as a return value for mappings.
" Useful when returning a dynamic value such as a user-configurable setting.
function! doge#helpers#keyseq(seq) abort
  let l:escaped_keyseq = printf('"%s"', escape(
        \ substitute(escape(a:seq, '\'), '<', '\\<', 'g'),
        \ '"'))
  let l:keyseq = eval(l:escaped_keyseq)
  return l:keyseq
endfunction

""
" @public
" Generate a placeholder with optionally a context. Optionally, you can pass the
" context using the following example call:
"
"   doge#helpers#placeholder('summary')
"
" The above will return:
"
"   'TODO<summary>'
"
" If no context is specified the todo-pattern is returned to search for.
function! doge#helpers#placeholder(...) abort
  if !has_key(a:, 1)
    return '\(\[TODO:[[:alnum:]-]\+\]\|TODO\)'
  else
    return printf('[TODO:%s]', a:1)
  endif
endfunction

""
" @public
" Helper for compatibility with vim versions without the trim() function.
function! doge#helpers#trim(string) abort
  let l:chars = '[ \t\n\r\x0B\xA0]*'
  return s:no_trim
        \ ? substitute(a:string, printf('\m^%s\(.\{-}\)%s$', l:chars, l:chars), '\1', '')
        \ : trim(a:string)
endfunction

""
" @public
" Run a parser which will produce all the parameters and return the output.
function! doge#helpers#parser(args) abort
  for l:executable in ['/dist/index.js', '/bin/vim-doge.exe', '/bin/vim-doge']
    let l:script_path = g:doge_dir . l:executable
    if filereadable(resolve(l:script_path))
      let l:cursor_pos = getpos('.')
      let l:current_line = l:cursor_pos[1]
      let l:tempfile = tempname()
      keepjumps call execute('%!tee ' . l:tempfile, 'silent!')
      let l:args = [l:tempfile, b:doge_parser, l:current_line] + a:args
      let l:cmd = fnamemodify(resolve(l:script_path), ':e') ==# 'js' ? 'node ' : ''
      let l:result = system(l:cmd . l:script_path . ' ' . join(l:args, ' '))

      try
        if !empty(l:result)
          return json_decode(l:result)
        endif
      catch /.*/
        echo '[DoGe] ' . b:doge_parser . ' parser failed'
        echo '[Doge] Exception: ' . v:exception
        echo l:result
      finally
        call setpos('.', l:cursor_pos)
        call delete(l:tempfile)
      endtry
    endif
  endfor

  return 0
endfunction

"" @public
" Recursively merge nested dictionaries and/or lists.
" a:1 is the base dictionary and every other parameter will be merged onto a:1.
"
" If you append '1' as the last argument then this will indicate that lists will
" be merged together instead overwritten. Example:
"
"   doge#helpers#deepextend({'a': ['foo']}, {'a': ['bar']}, 1)
"
" The above will result in: {'a': ['foo', 'bar']} instead of {'a': ['bar']}.
function! doge#helpers#deepextend(...) abort
  let l:merge_lists = type(a:000[-1]) is v:t_bool && a:000[-1] == v:true

  " Thanks to: https://vi.stackexchange.com/a/20843
  let l:args = filter(copy(a:000), 'type(v:val) == v:t_dict')
  let l:new = deepcopy(a:1)
  for l:arg in l:args
    let l:index = index(l:args, l:arg)
    if l:index == 0
      continue
    endif
    for [l:k, l:v] in items(l:arg)
      if type(l:v) is v:t_dict && type(get(l:new, l:k)) is v:t_dict
        let l:new[l:k] = doge#helpers#deepextend(l:new[l:k], l:v, l:merge_lists)
      elseif type(l:v) is v:t_list && type(get(l:new, l:k)) is v:t_list && l:merge_lists == v:true
        let l:new[l:k] = uniq(sort(extend(copy(get(l:new, l:k)), l:v)))
      else
        let l:new[l:k] = l:v
      endif
    endfor
  endfor
  return l:new
endfunction

"" @public
" Substitute input recursively.
function! doge#helpers#deepsubstitute(input, search, replacement, flags) abort
  return eval(substitute(string(a:input), a:search, a:replacement, a:flags))
endfunction

"" @public
" Get the current filetype. Returns the original filetype if the current
" filetype is an alias.
function! doge#helpers#get_filetype() abort
  for [l:ft, l:aliases] in items(get(g:, 'doge_filetype_aliases', []))
    if index(l:aliases, &filetype) >= 0
      return l:ft
    endif
  endfor
  return &filetype
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
