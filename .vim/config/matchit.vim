let s:bundle = neobundle#get('ruby-matchit')

function! s:bundle.hooks.on_source(bundle)
    runtime macros/matchit.vim
endfunction
