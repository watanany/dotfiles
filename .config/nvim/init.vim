
" Maintainer:   Watanabe Shingo <s1170087@gmail.com>
" Last change:  2016 Sep 26
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")
"
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        autocmd!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
    augroup END
else
    set autoindent      " always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
" function! s:ChangeCurrentDir(directory, bang)
"     if a:directory == ''
"         lcd %:p:h
"     else
"         execute 'lcd' . a:directory
"     endif
"
"     if a:bang == ''
"         pwd
"     endif
" endfunction


" --------------------------------------------------
" * dein.vimの設定
" --------------------------------------------------
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$XDG_CONFIG_HOME/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('$XDG_CONFIG_HOME/nvim/dein')
call dein#load_toml('$XDG_CONFIG_HOME/nvim/plugins.toml')
" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------


" カラースキームをhybridに変える
set background=dark
colorscheme hybrid
" colorscheme busybee
" colorscheme twilight256

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif
" show the cursor position all the time
set ruler
" display incomplete commands
set showcmd
" インデントをTabではなくスペース2つで揃える
" タブを画面で表示する際の幅(ts)
set tabstop=2
" タブを挿入する際、半角スペースに変換(et)
set expandtab
" インデント時に使用されるスペースの数(sw)
set shiftwidth=2
" タブ入力時その数値分だけ半角スペースを挿入する(sts)
set softtabstop=2

" 環境設定系
" スクロールする時に下が見えるようにする
set scrolloff=5
" .swapファイルを作らない
set noswapfile
" バックアップファイルを作らない
set nowritebackup
" バックアップをしない
set nobackup
" ビープ音を消す
set vb
set t_vb=
set noerrorbells
" 行番号を表示
set number
" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline
" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
" 対応括弧の表示秒数を3秒にする
set matchtime=3
" ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set wrap
" 入力されているテキストの最大幅を無効にする
set textwidth=0
" 不可視文字を表示
set list
" 不可視文字を表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:$
" インデントをshiftwidthの倍数に丸める
set shiftround
" 補完の際の大文字小文字の区別しない
set infercase
" 文字がない場所にもカーソルを移動できるようにする
" set virtualedit=all
" 変更中のファイルでも、保存しないで他のファイルを表示
set hidden
" 新しく開く代わりにすでに開いてあるバッファを開く
set switchbuf=useopen
" 小文字の検索でも大文字も見つかるようにする
set ignorecase
" ただし大文字も含めた検索の場合はその通りに検索する
set smartcase
" コマンドを画面最下部に表示する
set showcmd
" ステータスラインを常に表示する
set laststatus=2
" ステータスラインを2行にする
set cmdheight=2
" ステータスラインを常に表示
set statusline=%F%r%h%=
" 補完時の一覧表示機能有効化
set wildmenu wildmode=list:full
" カーソルラインの強調表示を有効化
" CUI環境だと重い
"set cursorline
" カーソル移動の動作を変更
set whichwrap=b,s,h,l,<,>,[,]

if has('conceal')
    set conceallevel=2 concealcursor=niv
endif


" Don't use Ex mode, use Q for formatting
map Q gq
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee % > /dev/null
" 入力モード中に素早くJJと入力した場合はESCとみなす
inoremap jj <Esc>
" C-jをESCに設定
imap <C-j> <Esc>
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" vを二回で行末まで選択
vnoremap v $h
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" キー配置に合わせて1で行頭、0で行末に移動
" nnoremap 1 0
" nnoremap 0 $
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" T + 一文字 で各種設定をトグル
nnoremap <silent> Ts :setl spell!     spell?<CR>
nnoremap <silent> Tl :setl list!      list?<CR>
nnoremap <silent> Tt :setl expandtab! expandtab?<CR>
nnoremap <silent> Tw :setl wrap!      wrap?<CR>
nnoremap <silent> Tp :setl paste!     paste?<CR>
" /{pattern}の入力中は「/」をタイプすると自動で「\/」が、
" ?{pattern}の入力中は「?」をタイプすると自動で「\?」が 入力されるようになる
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
" インサートモードでも移動
"inoremap <c-d> <delete>
"inoremap <c-j> <down>
"inoremap <c-k> <up>
"inoremap <c-h> <left>
"inoremap <c-l> <right>
" 画面切り替え
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
" <space>j, <space>kで画面送り
" noremap <space>j <c-f><cr><cr>
" noremap <space>k <c-b><cr><cr>
vnoremap a <Esc>ggVG
" accelerate jk --
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
nmap <DOWN> <Plug>(accelerated_jk_gj)
nmap <UP> <Plug>(accelerated_jk_gk)
" neosnippet --
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" Unite --
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
" vimfiler --
" ダブルクリックでファイルを開けるようにする
" autocmd Filetype vimfiler nmap <buffer> <2-LeftMouse> <Plug>(vimfiler_edit_file)
" ファイルリスト
nnoremap <silent>,f :VimFiler -split -simple -toggle -winwidth=35 -no-quit<CR>
" neocomplcache --
" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()


" Highlighting
hi ExtraWhitespace ctermbg=darkred
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=237


" Global Variables
let g:jscomplete_use = ['dom']
let g:lightline = {}
let g:lightline.colorscheme = 'hybrid'
" let g:lightline_hybrid_style = 'plain'
" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:unite_source_file_mru_limit = 300
let g:quickrun_config={'*': {'split': 'vertical'}}
let g:indent_guides_start_level=2
let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_color_change_percent=20
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides=1
let g:vim_tags_auto_generate = 1
let g:vimfiler_as_default_explorer = 1
" let g:vimfiler_edit_action = 'tabopen'

" neocomplcache --
" Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


" JSON編集時にconceal機能を無効化
autocmd Filetype json setl conceallevel=0
" .scssファイル読み込み時にファイルタイプにsassをセットする
autocmd BufRead,BufNewFile *.scss setf sass
" .exsファイル読み込み時にファイルタイプをelixirにセットする
autocmd BufRead,BufNewFile *.exs setf elixir
" .jbuilderファイル読み込み時にファイルタイプをrubyにセットする
autocmd BufRead,BufNewFile *.jbuilder setf ruby
" 保存時に末尾の空白を除去
autocmd BufWritePre * StripWhitespace
" vimfiler表示の際は行番号を付けない
autocmd Filetype vimfiler setlocal nonumber
autocmd Filetype vimfiler setlocal norelativenumber
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


"--------------------------------------------------------------------------------
" matchit
"--------------------------------------------------------------------------------
" runtime macros/matchit.vim
"
"--------------------------------------------------------------------------------
" vim-pyenv
"--------------------------------------------------------------------------------
" if jedi#init_python()
"   function! s:jedi_auto_force_py_version() abort
"     let major_version = pyenv#python#get_internal_major_version()
"     call jedi#force_py_version(major_version)
"   endfunction
"   augroup vim-pyenv-custom-augroup
"     autocmd! *
"     autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
"     autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
"   augroup END
" endif
