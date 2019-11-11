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
    let l:cnt = execute(l:range . 's/' . a:word . '//gn')
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
    return '\(\[TODO:[[:alnum:] ]\+\]\|TODO\)'
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

function! doge#helpers#generator(path) abort
  let l:generator = g:doge_dir . '/generators/' . a:path
  if filereadable(l:generator) != v:false
    let l:result = doge#python#file(l:generator)
    try
      return json_decode(l:result)
    catch /.*/
      echo '[DoGe] ' . a:path . ' generator failed.'
      echo l:result
    endtry
  endif
  return 0
endfunction


let &cpoptions = s:save_cpo
unlet s:save_cpo
