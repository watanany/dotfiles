" Rubyファイル保存時にRubocopを走らせる
" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }

let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
