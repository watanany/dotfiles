" Maintainer:   Watanabe Shingo <s1170087@gmail.com>
" Last change:  2019 Aug 4
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if has("vms")  " for OpenVMS OS
    set nobackup        " do not keep a backup file, use versions instead
else
    "set backup     " keep a backup file (restore to previous version)
    set undodir=$HOME/.vim/undodir
    set undofile        " keep an undo file (undo changes after closing)
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    " 検索結果をハイライト表示
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype off
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

    autocmd VimEnter,ColorScheme * :highlight IndentGuidesOdd  ctermbg=235
    autocmd VimEnter,ColorScheme * :highlight IndentGuidesEven ctermbg=237

    " JSON編集時にconceal機能を無効化
    autocmd Filetype json setlocal conceallevel=0
    " .rbファイル読み込み時にファイルタイプにrubyをセットする
    autocmd BufRead,BufNewFile *.rb setf ruby
    " .scssファイル読み込み時にファイルタイプにsassをセットする
    autocmd BufRead,BufNewFile *.scss setf sass
    " .exsファイル読み込み時にファイルタイプをelixirにセットする
    autocmd BufRead,BufNewFile *.exs setf elixir
    " .jbuilderファイル読み込み時にファイルタイプをrubyにセットする
    autocmd BufRead,BufNewFile *.jbuilder setf ruby
    " .vppファイル読み込み時にファイルタイプにvppをセットする
    autocmd BufRead,BufNewFile *.vpp setf vpp
    " .vdmppファイル読み込み時にファイルタイプにvppをセットする
    autocmd BufRead,BufNewFile *.vdmpp setf vpp
    " vimfiler表示の際は行番号を付けない
    autocmd Filetype vimfiler setlocal nonumber
    autocmd Filetype vimfiler setlocal norelativenumber
    " 保存時に末尾の空白を除去
    " autocmd BufWritePre * :%s/\s\+$//ge
    autocmd BufWritePre * StripWhitespace
    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

    " Indentation Width
    autocmd FileType ruby setlocal ts=2 et sw=2 sts=2

    " See https://github.com/posva/vim-vue#my-syntax-highlighting-stops-working-randomly
    autocmd FileType vue syntax sync fromstart

    autocmd BufWrite *.hs :Autoformat
    " Don't automatically indent on save, since vim's autoindent for haskell is buggy
    autocmd FileType haskell let b:autoformat_autoindent=0
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

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif

" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" インデントをTabではなくスペース2つで揃える
" タブを画面で表示する際の幅(ts)
set tabstop=4
" タブを挿入する際、半角スペースに変換(et)
set expandtab
" インデント時に使用されるスペースの数(sw)
set shiftwidth=4
" タブ入力時その数値分だけ半角スペースを挿入する(sts)
set softtabstop=4

" 環境設定系
" エンコード
set encoding=utf-8
" ファイルエンコード
set fileencoding=utf-8
" スクロールする時に下が見えるようにする
set scrolloff=5
" .swapファイルを作らない
set noswapfile
" バックアップファイルを作らない
set nowritebackup
" バックアップをしない
set nobackup
" バックスペースで各種消せるようにする
set backspace=indent,eol,start
" ビープ音を消す
set vb
set t_vb=
set noerrorbells
" 行番号を表示
set number
" 右下に表示される行・列の番号を表示する
set ruler
" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline
" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
" 対応括弧の表示秒数を3秒にする
set matchtime=3
" ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
" set wrap
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
" インクリメンタルサーチを行う
set incsearch
" コマンド、検索パターンを10000個まで履歴に残す
set history=10000
" xtermとscreen対応
set ttymouse=xterm2
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
" カーソルラインの強調表示を有効化(CUI環境だと重い)
"set cursorline
" 外部でファイルに変更がされた場合は読みなおす
set autoread
" カーソル移動の動作を変更
set whichwrap=b,s,h,l,<,>,[,]

if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
else
    set clipboard& clipboard+=unnamed,autoselect
endif

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cnoremap w!! w !sudo tee % > /dev/null
" 入力モード中に素早くJJと入力した場合はESCとみなす
inoremap jj <Esc>
" ESCを二回押すことでハイライトを消す
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
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
" キー配置に合わせて1で行頭、0で行末に移動
" nnoremap 1 0
" nnoremap 0 $
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" T + 一文字 で各種設定をトグル
nnoremap <silent> Ts :setlocal spell!     spell?<CR>
nnoremap <silent> Tl :setlocal list!      list?<CR>
nnoremap <silent> Tn :setlocal number!    number?<CR>
nnoremap <silent> Tt :setlocal expandtab! expandtab?<CR>
nnoremap <silent> Tw :setlocal wrap!      wrap?<CR>
nnoremap <silent> Tp :setlocal paste!     paste?<CR>

" /{pattern}の入力中は「/」をタイプすると自動で「\/」が、
" ?{pattern}の入力中は「?」をタイプすると自動で「\?」が 入力されるようになる
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" 画面切り替え
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" vAで全選択
vnoremap A <Esc>ggVG


" ======================================================================
" * NeoBundleの設定
" ======================================================================
if has('vim_starting')
  " Required:
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('$HOME/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" vimproc
NeoBundle 'Shougo/vimproc.vim', {
\     'build' : {
\         'windows' : 'tools\\update-dll-mingw',
\         'cygwin' : 'make -f make_cygwin.mak',
\         'mac' : 'make',
\         'linux' : 'make',
\         'unix' : 'gmake',
\     },
\ }

" 補完プラグイン
NeoBundle 'Shougo/neocomplcache'
" コメントアウト
NeoBundle 'scrooloose/nerdcommenter'
" f + 一文字で検索
NeoBundle 'rhysd/clever-f.vim'
" ステータスバーのプラグイン
NeoBundle 'itchyny/lightline.vim'
" カラースキーム
NeoBundle 'w0ng/vim-hybrid'
" ステータスバー用のhybridのcolorscheme
NeoBundle 'cocopon/lightline-hybrid.vim'
" テキストを整列させるプラグイン
NeoBundle 'godlygeek/tabular'
" indentの深さに色をつける
NeoBundle 'nathanaelkane/vim-indent-guides'
" カーソル移動加速プラグイン
NeoBundle 'rhysd/accelerated-jk'

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimfiler.vim'

" 行末の不要な半角スペースを可視化
NeoBundle 'ntpeters/vim-better-whitespace'

" text-objectを囲むプラグイン(ys + text-object)
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'

" ユーザー定義のテキストオブジェクトを作成する
NeoBundle 'kana/vim-textobj-user'
" 現在の行に似たようなインデント構造を持つテキストオブジェクトを作成する
NeoBundle 'kana/vim-textobj-indent'

" vimからctagsを使う
NeoBundle 'szw/vim-tags'
" タブ作成・移動・削除
NeoBundle 'watanany/vim-tabs'

" 対応する括弧を自動入力
NeoBundle 'Townk/vim-autoclose'

" 自動フォーマット(外部プログラムを使用 例: stylish-haskell)
NeoBundle 'Chiel92/vim-autoformat'

NeoBundle 'othree/html5.vim'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'dag/vim2hs'
NeoBundle 'vmchale/dhall-vim'
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'racer-rust/vim-racer'
NeoBundle 'ElmCast/elm-vim'
NeoBundle "vim-scripts/vpp.vim"
NeoBundle 'JuliaEditorSupport/julia-vim'

NeoBundleLazy 'vim-scripts/jQuery', {
\     'autoload': { 'filetypes': ['html', 'javascript'] }
\ }

NeoBundleLazy 'mattn/jscomplete-vim', {
\     'autoload': { 'filetypes': ['html', 'javascript'] }
\ }

NeoBundle "posva/vim-vue"

" 対応する`end`を自動で入力する
NeoBundleLazy 'tpope/vim-endwise', {
\     'autoload': { 'filetypes': ['ruby', 'eruby', 'slim'] }
\ }

NeoBundleLazy 'tpope/vim-rails', {
\     'autoload': { 'filetypes': ['ruby', 'eruby', 'slim'] }
\ }

NeoBundleLazy 'tpope/vim-bundler', {
\     'autoload': { 'filetypes': ['ruby', 'eruby', 'slim'] }
\ }

NeoBundleLazy 'basyura/unite-rails', {
\     'autoload': { 'filetypes': ['ruby', 'eruby', 'slim'] }
\ }

NeoBundleLazy 'scrooloose/syntastic', {
\     'autoload': { 'filetypes': ['ruby', 'eruby', 'slim'] }
\ }

" Required:
call neobundle#end()

" Required:
filetype off
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" ======================================================================

" カラースキームをhybridに変える
set background=dark
colorscheme hybrid

" Light line
let g:lightline = {}
let g:lightline.colorscheme = 'hybrid'

" J, Kでの移動を加速する
nmap j      <Plug>(accelerated_jk_gj)
nmap k      <Plug>(accelerated_jk_gk)
nmap <DOWN> <Plug>(accelerated_jk_gj)
nmap <UP>   <Plug>(accelerated_jk_gk)

" CTags
let g:vim_tags_auto_generate = 0

" インデントの深さに色をつける
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_color_change_percent = 20
let g:indent_guides_guide_size = 1
let g:indent_guides_space_guides = 1

" nerdcommenterの設定「,,」でコメントON/OFF切り替え
" let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

" Unite
nnoremap <silent>,b :Unite -toggle buffer<CR>
nnoremap <silent>,m :Unite -toggle file_mru<CR>
nnoremap <silent>,f :VimFiler -split -simple -toggle -winwidth=35 -no-quit<CR>

" VimFilerをデフォルトのファイルエクスプローラーにする
let g:vimfiler_as_default_explorer = 1

" ======================================================================
" neocomplcache
" ======================================================================
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
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

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
\     'default' : '',
\     'vimshell' : $HOME.'/.vimshell_hist',
\     'scheme' : $HOME.'/.gosh_completions'
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
" ======================================================================

let g:haskell_conceal = 0


" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif
