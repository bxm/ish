" https://jonasjacek.github.io/colors/

" builtin override
highlight NonText ctermfg=242
highlight LineNr ctermfg=darkgrey ctermbg=236
highlight Folded ctermbg=237 ctermfg=white

highlight TabLine ctermbg=236 ctermfg=darkgrey cterm=none
highlight TabLineFill ctermbg=236 ctermfg=darkgrey cterm=none
highlight TabLineSel ctermbg=grey ctermfg=black

" builtin user defined
highlight User1 ctermfg=0 ctermbg=133 " dull light purple
highlight User2 ctermfg=255 ctermbg=DarkBlue
highlight User3 ctermfg=255 ctermbg=Red
highlight User4 ctermfg=255 ctermbg=DarkGreen
highlight User5 ctermfg=0 ctermbg=DarkCyan

" custom
"   autocmd forces our colours even if colour
"   scheme is clearing then
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red ctermfg=black
autocmd ColorScheme * highlight AllTabs ctermbg=green ctermfg=black
autocmd ColorScheme * highlight Status ctermbg=green ctermfg=black
highlight StatusLine ctermfg=white ctermbg=black cterm=bold
highlight StatusLineNC ctermfg=darkgrey ctermbg=black cterm=bold
" highlight trailing whitespace and literal tabs
autocmd BufRead * syntax match AllTabs /\t/
autocmd BufRead * syntax match ExtraWhitespace / \+$/

" trailing space  
" trailing tab	
	" other	tab
" naked space
  
