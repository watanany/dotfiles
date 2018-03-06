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
set runtimepath+=$XDG_CACHE_HOME/dein

" Required:
if dein#load_state('$XDG_CACHE_HOME/dein')
  call dein#begin('$XDG_CACHE_HOME/dein')
  call dein#load_toml('$XDG_CONFIG_HOME/nvim/plugins.toml')
  call dein#end()
  call dein#save_state()
endif

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


" 履歴を10000件まで取る
set history=10000
" インクリメンタルサーチをON
set incsearch
" 検索結果をハイライト
set hlsearch
" ルーラーを表示
set ruler
" タブ挿入時にshiftwidthを使うようにする
set smarttab
"
set ttyfast
"
set autoread
" undo
set undodir=$HOME/.local/share/nvim/undo
set undofile
" バックアップディレクトリ
set backupdir=$HOME/.local/share/nvim/backup
" バックアップファイルを作らない
"set nowritebackup
" バックアップをしない
"set nobackup
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
" バックスペースで改行も消せるようにする
set backspace=indent,eol,start

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
" ファイルリスト
nnoremap <silent>,f :VimFiler -split -simple -toggle -winwidth=35 -no-quit<CR>

" Highlighting
hi ExtraWhitespace ctermbg=darkred
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=237


" Global Variables
let g:deoplete#enable_at_startup = 1
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
let g:vim_tags_auto_generate=1
let g:vimfiler_as_default_explorer=1
" let g:vimfiler_edit_action = 'tabopen'
let g:table_mode_corner='|'

" deopleteで補完した後、preview windowを閉じる
autocmd CompleteDone * silent! pclose!
" JSON編集時にconceal機能を無効化
autocmd Filetype json setl conceallevel=0
" 保存時に末尾の空白を除去
autocmd BufWritePre * StripWhitespace
" .mdファイル読み込み時にテーブルモードをONにする
autocmd BufRead *.md TableModeEnable
" .scssファイル読み込み時にファイルタイプにsassをセットする
autocmd BufRead,BufNewFile *.scss setf sass
" .jbuilderファイル読み込み時にファイルタイプをrubyにセットする
autocmd BufRead,BufNewFile *.jbuilder setf ruby
" .exsファイル読み込み時にファイルタイプをelixirにセットする
autocmd BufRead,BufNewFile *.exs setf elixir
" .dart
autocmd BufWritePre *.dart DartFmt
" vimfiler表示の際は行番号を付けない
autocmd Filetype vimfiler setlocal nonumber
autocmd Filetype vimfiler setlocal norelativenumber
" ダブルクリックでファイルを開けるようにする
" autocmd Filetype vimfiler nmap <buffer> <2-LeftMouse> <Plug>(vimfiler_edit_file)
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
