let g:unite_source_file_mru_limit = 300
" バッファリスト
nnoremap <silent>,b :Unite -toggle buffer<CR>
" 最近使ったファイル
nnoremap <silent>,m :Unite -toggle file_mru<CR>

" Ruby on Rails
nnoremap <silent>,rc :Unite -toggle rails/controller<CR>
nnoremap <silent>,rm :Unite -toggle rails/model<CR>
nnoremap <silent>,rv :Unite -toggle rails/view<CR>
nnoremap <silent>,rC :Unite -toggle rails/config<CR>
nnoremap <silent>,rd :Unite -toggle rails/db<CR>
