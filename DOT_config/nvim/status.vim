" https://jdhao.github.io/2019/11/03/vim_custom_statusline/
let g:modes={
       \ 'n'  : 'NORM',
       \ 'v'  : 'VIS',
       \ 'V'  : 'VLine',
       \ "\<C-V>" : 'VBlk',
       \ 'i'  : 'INS',
       \ 'R'  : 'Rep',
       \ 'r'  : 'Rep',
       \ 'Rv' : 'VRep',
       \ 'c'  : 'Cmd',
       \}
let space=' '
set statusline=
set statusline+=%1*[%t]%* " short filename
set statusline+=%3*%{&modified?'[+]':''}%* " mod'd
set statusline+=%4*%{&modified?'':'[=]'}%* " unmod'd

"set statusline+=%#Paste# " set paste

set statusline+=%= " expanding space
set statusline+=..::
set statusline+=[%{tolower(g:modes[mode()])} " mode
"set statusline+=%{&paste?'[pst]':''} " set paste
set statusline+=%{mode()=='i'?&paste?'+pst':'':''}] " paste if in insert
set statusline+=::..

set statusline+=%= " expanding space
"set statusline+=%2*[%{&ft}]%* " filetype
set statusline+=%2*%y%* " filetype
set statusline+=%3*%r%* " readonly
set statusline+=%5*[%c,%l/%L]%* " position


