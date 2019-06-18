let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Generates documentation based on available patterns in b:doge_patterns.
function! doge#generate() abort
  if exists('b:doge_patterns')
    for l:pattern in get(b:, 'doge_patterns')
      if doge#generate#pattern(l:pattern) == v:false
        continue
      endif
      return 1
    endfor

    echo '[DoGe] No patterns did match L' . line('.') . '.'
    echo '--'
    echohl WarningMsg
    echo 'Is this a bug? Use the following link to quickly sent in a bug report for kkoomen/doge:'
    echohl None
    let l:issue_title = substitute(&filetype . ' expression does not generate comment', '\s\+', '+', 'g')
    echo printf('https://github.com/kkoomen/doge/issues/new?labels=bug&template=bug_report.md&title=[BUG]+%s', l:issue_title)
  else
    echo '[DoGe] b:doge_patterns variable not found for filetype "' . &filetype . '".'
    echo '--'
    echohl WarningMsg
    echo 'Should this filetype be supported? Use the following link to quickly sent in a feature request for kkoomen/doge:'
    echohl None
    let l:issue_title = substitute('Add support for ' . &filetype, '\s\+', '+', 'g')
    echo printf('https://github.com/kkoomen/doge/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=[FEATURE]+%s', l:issue_title)
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
