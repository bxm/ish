let g:currentmode={
       \ 'n'  : 'NORM',
       \ 'v'  : 'VIS',
       \ 'V'  : 'V·Line',
       \ "\<C-V>" : 'V·Blk',
       \ 'i'  : 'INS',
       \ 'R'  : 'Rep',
       \ 'r'  : 'Rep',
       \ 'Rv' : 'V·Rep',
       \ 'c'  : 'Cmd',
       \}
let space=' '
set statusline=%t   " shortname
set statusline+=:%l " line
set statusline+=%{space}

set statusline+=%{&modified?'[+]':'[\=]'}
set statusline+=%{space}

set statusline+=%{tolower(g:currentmode[mode()])}

set statusline+=%{&paste?'-pst':''}

