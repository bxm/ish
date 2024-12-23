let session_file = stdpath('data') . '/session.vim'

" Automatically save the session on exit
autocmd VimLeavePre * execute 'mksession!' session_file

" Automatically load the last session on startup if no file is specified
autocmd VimEnter * if argc() == 0 && filereadable(session_file) | execute 'source' session_file | endif
