
let s:ex_commands = {
    \ 'nosplit': 'enew',
    \ 'horizontal': 'botright split | enew',
    \ 'vertical': 'vsplit | enew',
    \ 'tab': 'tabedit',
\ }

function! tdd#window_layout#new(layout_type) abort
    if !has_key(s:ex_commands, a:layout_type)
        throw printf('not found layout type: %s', a:layout_type)
    endif

    let window_layout = {
        \ 'ex_command': s:ex_commands[a:layout_type],
    \ }

    function! window_layout.execute() abort
        execute self.ex_command
    endfunction

    return window_layout
endfunction
