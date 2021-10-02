" https://jonasjacek.github.io/colors/

" builtin
highlight NonText ctermfg=242
highlight LineNr ctermfg=darkgrey ctermbg=236
highlight Folded ctermbg=237

" custom
highlight ExtraWhitespace ctermbg=red ctermfg=black
highlight AllTabs ctermbg=green ctermfg=black

" highlight trailing whitespace and literal tabs
syntax match AllTabs /\t/
syntax match ExtraWhitespace /\s\+$/
