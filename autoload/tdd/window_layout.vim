
let s:layout_types = {
    \ '': 'edit | enew',
    \ 'nosplit': 'edit | enew',
    \ 'horizontal': 'botright split | enew',
    \ 'vertical': 'vsplit | enew',
    \ 'tab': 'tabedit',
\ }

function! tdd#window_layout#new(layout_type) abort
    let window_layout = {
        \ 'command': get(s:layout_types, a:layout_type, 'edit | enew'),
    \ }

    function! window_layout.execute() abort
        execute self.command
    endfunction

    return window_layout
endfunction
