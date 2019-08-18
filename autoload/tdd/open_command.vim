
let s:commands = {
    \ '': 'edit | enew',
    \ 'nosplit': 'edit | enew',
    \ 'horizontal': 'botright split | enew',
    \ 'vertical': 'vsplit | enew',
    \ 'tab': 'tabedit',
\ }

function! tdd#open_command#new(type) abort
    let command = get(s:commands, a:type, 'edit | enew')
    let open_command = {
        \ 'command': command,
    \ }

    function! open_command.execute() abort
        execute self.command
        setlocal filetype=
    endfunction

    return open_command
endfunction
