let s:save_cpo = &cpoptions
set cpoptions&vim

" Alter the insert position for JavaScript functions.
function! doge#preprocessors#rust#insert_position(lnum_insert_pos) abort
  " In Rust, some functions may have #[...] macros above them.
  " If this is the case we want to insert above this.
  "
  " Example:
  "   #[doc(alias = "x")]
  "   #[doc(alias = "big")]
  "   pub struct BigX;

  " Go to the beginning of the line.
  call execute('normal! ^')

  let l:offset = 1
  let l:has_macros = 0
  while doge#helpers#trim(getline(line('.') - l:offset)) =~# '\m^#['

    " Assume that a user won't have more than 20 macros on a function.
    " When we reach 20 lines or more, return and do nothing.
    if l:offset > 20
      return a:lnum_insert_pos
    endif

    let l:has_macros = 1
    let l:offset += 1

  endwhile

  return l:has_macros == v:true
        \ ? a:lnum_insert_pos - l:offset + 1
        \ : a:lnum_insert_pos
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
