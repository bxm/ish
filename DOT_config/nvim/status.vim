" https://jdhao.github.io/2019/11/03/vim_custom_statusline/
hi User1 ctermfg=0 ctermbg=133 " dull light purple
hi User2 ctermfg=White ctermbg=DarkBlue
hi User3 ctermfg=White ctermbg=Red
hi User4 ctermfg=White ctermbg=DarkGreen
let g:modes={
       \ 'n'  : 'NORM',
       \ 'v'  : 'VIS',
       \ 'V'  : 'VLine',
       \ "\<C-V>" : 'VBlk',
       \ 'i'  : 'INS',
       \ 'R'  : 'Rep',
       \ 'r'  : 'Rep',
       \ 'Rv' : 'V·Rep',
       \ 'c'  : 'Cmd',
       \}
let space=' '
set statusline=
set statusline+=%1*[%t]%*   " short filename
set statusline+=%3*%{&modified?'[+]':''}%* " mod'd
set statusline+=%4*%{&modified?'':'[=]'}%* " unmod'd

set statusline+=[
set statusline+=%{tolower(g:modes[mode()])} " mode

set statusline+=%{&paste?'-pst':''} " set paste
set statusline+=]

set statusline+=%2*[%{&ft}]%* " filetype
set statusline+=[%l/%L] " line


