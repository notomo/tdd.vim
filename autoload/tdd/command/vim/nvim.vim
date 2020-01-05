
function! tdd#command#vim#nvim#new(params) abort
    let command = tdd#command#vim#vim#new(a:params)

    function! command.executable() abort
        return 'nvim'
    endfunction

    return command
endfunction
