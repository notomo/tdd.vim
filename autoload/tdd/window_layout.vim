
let s:ex_commands = {
    \ '': 'edit | enew',
    \ 'nosplit': 'edit | enew',
    \ 'horizontal': 'botright split | enew',
    \ 'vertical': 'vsplit | enew',
    \ 'tab': 'tabedit',
\ }

function! tdd#window_layout#new(layout_type) abort
    let window_layout = {
        \ 'ex_command': get(s:ex_commands, a:layout_type, 'edit | enew'),
    \ }

    function! window_layout.execute() abort
        execute self.ex_command
    endfunction

    return window_layout
endfunction
