function! RemoveTrailingWhitespace()
  let save_cursor = getcurpos() " save current cursor position
  if search('\v\s+$',"n") " check for offenders, to prevent error from %s
    execute '%s/\v\s+$//g'
  endif
  call setpos('.', save_cursor) " put the cursor back where it started
endfunction

function! ProtectBashVars()
  let regex='\v(([^\\]|^)[$])([A-Za-z0-9_]+)'
  if search(regex,"n") " check for offenders, to prevent error from %s
    let save_cursor = getcurpos() " save current cursor position
    let subst='%s/' . regex . '/\1{\3}/gc'
    execute subst
    call setpos('.', save_cursor) " put the cursor back where it started
  endif
endfunction

function! SetPaste()
  if &paste
    set paste!
  else
    set paste
  endif
endfunction
