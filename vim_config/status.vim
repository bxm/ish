let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 'V'  : 'V·Line ',
       \ "\<C-V>" : 'V·Block ',
       \ 'i'  : 'INSERT ',
       \ 'R'  : 'R ',
       \ 'Rv' : 'V·Replace ',
       \ 'c'  : 'Command ',
       \}

set statusline=%F=
"set statusline+=:%l
set statusline+=\ %{&modified?'[+]':'[\=]'}

set statusline+=\ %{toupper(g:currentmode[mode()])}

