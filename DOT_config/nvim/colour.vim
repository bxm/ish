" https://jonasjacek.github.io/colors/

" builtin
highlight NonText ctermfg=242
highlight LineNr ctermfg=darkgrey ctermbg=236
highlight Folded ctermbg=237

" user
highlight User1 ctermfg=0 ctermbg=133 " dull light purple
highlight User2 ctermfg=White ctermbg=DarkBlue
highlight User3 ctermfg=White ctermbg=Red
highlight User4 ctermfg=White ctermbg=DarkGreen
highlight User5 ctermfg=0 ctermbg=DarkCyan

" custom
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red ctermfg=black
autocmd ColorScheme * highlight AllTabs ctermbg=green ctermfg=black
autocmd ColorScheme * highlight Status ctermbg=green ctermfg=black
highlight StatusLine ctermfg=white ctermbg=black cterm=bold
" highlight trailing whitespace and literal tabs
autocmd BufRead * syntax match AllTabs /\t/
autocmd BufRead * syntax match ExtraWhitespace / \+$/

" trailing space  
" trailing tab	
	" other	tab
" naked space
  
