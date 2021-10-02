" https://jonasjacek.github.io/colors/

" builtin
highlight NonText ctermfg=242
highlight LineNr ctermfg=darkgrey ctermbg=236
highlight Folded ctermbg=237

" custom
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red ctermfg=black
autocmd ColorScheme * highlight AllTabs ctermbg=green ctermfg=black

" highlight trailing whitespace and literal tabs
autocmd BufRead * syntax match AllTabs /\t/
autocmd BufRead * syntax match ExtraWhitespace / \+$/

" trailing space  
" trailing tab	
	" other	tab
" naked space
  
