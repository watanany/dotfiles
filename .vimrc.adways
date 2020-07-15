" Maintainer:   Watanabe Shingo <s1170087@gmail.com>
" Last change:  2016 Sep 26
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

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup        " do not keep a backup file, use versions instead
else
    "set backup     " keep a backup file (restore to previous version)
    set undodir=$HOME/.vim/undodir
    set undofile        " keep an undo file (undo changes after closing)
endif
set history=50      " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

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

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif



" --------------------------------------------------
" * NeoBundleの設定
" --------------------------------------------------
if has('vim_starting')
  " Required:
  set runtimepath+=/home/$USER/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/$USER/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }
" vimproc
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

" カラースキーム
NeoBundle 'w0ng/vim-hybrid'
" NeoBundle 'altercation/vim-colors-solarized'
" NeoBundle 'vim-scripts/BusyBee'
" NeoBundle 'jonathanfilip/vim-lucius'
" NeoBundle 'vim-scripts/twilight'

" 補完プラグイン
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
" コメントアウト
NeoBundle 'scrooloose/nerdcommenter'
" 対応する括弧を自動入力
NeoBundle 'Townk/vim-autoclose'
" f + 一文字で検索
NeoBundle 'rhysd/clever-f.vim'
" s + 二文字で検索
NeoBundle 'goldfeld/vim-seek'
" ステータスバーのプラグイン
NeoBundle 'itchyny/lightline.vim'
" ステータスバー用のhybridのcolorscheme
NeoBundle 'cocopon/lightline-hybrid.vim'
" テキストを整列させるプラグイン
NeoBundle 'godlygeek/tabular'
" NeoBundle 'junegunn/vim-easy-align'
" ブラウザを開くコマンドを追加
NeoBundle 'tyru/open-browser.vim'
" indentの深さに色をつける
NeoBundle 'nathanaelkane/vim-indent-guides'
" quickrun
NeoBundle 'thinca/vim-quickrun'
" カーソル移動加速プラグイン
NeoBundle 'rhysd/accelerated-jk'

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimfiler.vim'

" reference viewer
NeoBundle 'thinca/vim-ref'

" 行末の不要な半角スペースを可視化
NeoBundle 'ntpeters/vim-better-whitespace'

" text-objectを囲むプラグイン(ys + text-object)
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'

" vimからctagsを使う
NeoBundle 'szw/vim-tags'
" タブ作成・移動・削除
NeoBundle 'watanany/vim-tabs'
" カーソル移動
" NeoBundle 'Lokaltog/vim-easymotion'
" セッション保存
NeoBundle 'tpope/vim-obsession'

" HTML ---
" HTML5 Syntax
NeoBundleLazy 'othree/html5.vim', {
\    'autoload': { 'filetypes': ['html', 'eruby'] }
\}

" HTMLのショートカットプラグイン
NeoBundleLazy 'mattn/emmet-vim', {
\    'autoload': { 'filetypes': ['html', 'eruby'] }
\}

" Markdown, reStructuredText, textile プレビュープラグイン
NeoBundleLazy 'kannokanno/previm', {
\    'autoload': { 'filetypes': ['markdown'] }
\}

NeoBundleLazy 'kannokanno/previm', {
\    'autoload': { 'filetypes': ['markdown'] }
\}

" CSS ---
NeoBundleLazy 'hail2u/vim-css3-syntax', {
\    'autoload': { 'filetypes': ['css', 'less', 'scss'] }
\}

" JavaScript ---
NeoBundleLazy 'vim-scripts/jQuery', {
\    'autoload': { 'filetypes': ['html', 'javascript'] }
\}

NeoBundleLazy 'jelera/vim-javascript-syntax', {
\    'autoload': { 'filetypes': ['html', 'javascript'] }
\}

NeoBundleLazy 'mattn/jscomplete-vim', {
\    'autoload': { 'filetypes': ['html', 'javascript'] }
\}

" CoffeeScript ---
" coffee scriptのsyntax + 自動compileのプラグイン
NeoBundleLazy 'kchmck/vim-coffee-script', {
\    'autoload': { 'filetypes': ['coffee'] }
\}

NeoBundleLazy 'digitaltoad/vim-pug', {
\    'autoload': { 'filetypes': ['pug'] }
\}

" Ruby ---
NeoBundleLazy 'vim-scripts/ruby-matchit', {
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}

NeoBundleLazy 'tpope/vim-endwise', {
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}


NeoBundleLazy 'yuku-t/vim-ref-ri', {
\    'depends': ['thinca/vim-ref'],
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}

" Ruby on Rails
NeoBundleLazy 'tpope/vim-rails', {
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}

NeoBundleLazy 'tpope/vim-bundler', {
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}

NeoBundleLazy 'basyura/unite-rails', {
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}

NeoBundleLazy 'scrooloose/syntastic', {
\    'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] }
\}


" Python ---
NeoBundleLazy 'davidhalter/jedi-vim', {
\    'autoload': { 'filetypes': ['python', 'python3'] }
\}

NeoBundleLazy 'lambdalisue/vim-pyenv', {
\    'depends': ['davidhalter/jedi-vim'],
\    'autoload': {
\      'filetypes': ['python', 'python3'],
\    }
\}

" Haskell ---
NeoBundleLazy 'kana/vim-filetype-haskell', {
\    'autoload': { 'filetypes': ['haskell'] }
\}

NeoBundleLazy 'eagletmt/ghcmod-vim', {
\    'autoload': { 'filetypes': ['haskell'] }
\}

NeoBundleLazy 'ujihisa/neco-ghc', {
\    'autoload': { 'filetypes': ['haskell'] }
\}

" NeoBundle 'osyo-manga/vim-watchdogs', {
" \    'autoload': { 'filetypes': ['haskell'] }
" \}

NeoBundleLazy 'ujihisa/ref-hoogle', {
\    'depends': ['thinca/vim-ref'],
\    'autoload': { 'filetypes': ['haskell'] }
\}

NeoBundleLazy 'ujihisa/unite-haskellimport', {
\    'depends': ['Shougo/unite.vim'],
\    'autoload': { 'filetypes': ['haskell'] }
\}

" Scala ---
NeoBundleLazy 'derekwyatt/vim-scala', {
\    'autoload': { 'filetypes': ['scala'] }
\}

" Elixir ---
NeoBundleLazy 'elixir-lang/vim-elixir', {
\    'autoload': { 'filetypes': ['elixir'] }
\}


" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" --------------------------------------------------

" カラースキームをhybridに変える
if has#colorscheme('hybrid')
    set background=dark
    colorscheme hybrid
endif

" colorscheme busybee
" colorscheme twilight256

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
" シンタックスハイライト
syntax on
" エンコード
set encoding=utf8
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
" インクリメンタルサーチを行う
set incsearch
" 検索結果をハイライト表示
set hlsearch
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
" カーソルラインの強調表示を有効化
" CUI環境だと重い
"set cursorline
" 外部でファイルに変更がされた場合は読みなおす
set autoread
" カーソル移動の動作を変更
set whichwrap=b,s,h,l,<,>,[,]

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


" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif

" /{pattern}の入力中は「/」をタイプすると自動で「\/」が、
" ?{pattern}の入力中は「?」をタイプすると自動で「\?」が 入力されるようになる
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
else
    set clipboard& clipboard+=unnamed,autoselect
endif

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

" vaで全選択
vnoremap a <Esc>ggVG

" JSON編集時にconceal機能を無効化
autocmd Filetype json setl conceallevel=0

" .scssファイル読み込み時にファイルタイプにsassをセットする
autocmd BufRead,BufNewFile *.scss setf sass

" .exsファイル読み込み時にファイルタイプをelixirにセットする
autocmd BufRead,BufNewFile *.exs setf elixir

" .jbuilderファイル読み込み時にファイルタイプをrubyにセットする
autocmd BufRead,BufNewFile *.jbuilder setf ruby

" NeoBundleプラグインの設定ファイルを読み込む
runtime! config/*.vim
