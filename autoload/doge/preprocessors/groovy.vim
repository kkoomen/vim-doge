let s:save_cpo = &cpoptions
set cpoptions&vim

" Alter the insert position for Groovy functions.
function! doge#preprocessors#groovy#insert_position(lnum_insert_pos) abort
  " In Groovy some functions may have '@Override' above them. If this is the case
  " we want to insert above this.
  "
  " Example:
  "   @Override
  "   public void myFunc() {}
  if doge#helpers#trim(getline(line('.') - 1)) ==? '@Override'
    return a:lnum_insert_pos - 1
  endif

  return a:lnum_insert_pos
endfunction

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#groovy#tokens(tokens) abort
  if has_key(a:tokens, 'returnType') && a:tokens['returnType'] ==# 'void'
    let a:tokens['returnType'] = ''
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
