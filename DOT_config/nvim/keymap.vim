noremap <silent> <C-Y> :so $MYVIMRC<CR>
vnoremap <silent> <C-Y> <C-C>:so $MYVIMRC<CR>
inoremap <silent> <C-Y> <C-O>:so $MYVIMRC<CR>

noremap <silent> <Tab> gt

noremap <silent> <C-Q> :wq<CR>
vnoremap <silent> <C-Q> <C-C>:wq<CR>
inoremap <silent> <C-Q> <C-O>:wq<CR>

noremap <silent> <C-X> :q<CR>
vnoremap <silent> <C-X> <C-C>:q<CR>
inoremap <silent> <C-X> <C-O>:q<CR>

noremap <silent> <C-P> :call SetPaste()<CR>
vnoremap <silent> <C-P> <C-C>:call SetPaste()<CR>
inoremap <silent> <C-P> <C-O>:call SetPaste()<CR>

noremap <silent> s :update<CR>
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <Esc>:update<CR>
noremap <silent> <C-A> :update<CR>
vnoremap <silent> <C-A> <C-C>:update<CR>
inoremap <silent> <C-A> <C-O>:update<CR>

nnoremap <silent> <Space> :silent :nohl<CR>

"noremap  <buffer> <silent> <Up>   gk
"noremap  <buffer> <silent> <Down> gj
"noremap  <buffer> <silent> <Home> g<Home>
"noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>
