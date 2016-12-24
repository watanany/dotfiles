" vimfiler表示の際は行番号を付けない
autocmd Filetype vimfiler setlocal nonumber
autocmd Filetype vimfiler setlocal norelativenumber

" ダブルクリックでファイルを開けるようにする
" autocmd Filetype vimfiler nmap <buffer> <2-LeftMouse> <Plug>(vimfiler_edit_file)

" ファイルリスト
nnoremap <silent>,f :VimFiler -split -simple -toggle -winwidth=35 -no-quit<CR>

" VimFilerをデフォルトのファイルエクスプローラーにする
let g:vimfiler_as_default_explorer = 1

" タブで開くようにする
" let g:vimfiler_edit_action = 'tabopen'
