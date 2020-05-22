
function! tdd#command#lua#busted#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'busted'
    endfunction

    function! command.args_for_file() abort
        return [expand('%:p')]
    endfunction

    return command
endfunction
