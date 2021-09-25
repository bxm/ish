" https://jdhao.github.io/2019/11/03/vim_custom_statusline/
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
set statusline+=%{space}

set statusline+=[%{&modified?'+':'='}]
set statusline+=%{space}

set statusline+=%{tolower(g:currentmode[mode()])}

set statusline+=%{&paste?'-pst':''} " set paste

set statusline+=%{space}
set statusline+=(%l/%L) " line

