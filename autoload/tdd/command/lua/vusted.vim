
function! tdd#command#lua#vusted#new(params) abort
    let command = tdd#command#lua#busted#new(a:params)

    function! command.executable() abort
        return 'vusted'
    endfunction

    return command
endfunction
