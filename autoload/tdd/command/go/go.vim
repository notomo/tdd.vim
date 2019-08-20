
function! tdd#command#go#go#new(params) abort
    let command = {}

    function! command.executable() abort
        return 'go'
    endfunction

    function! command.args() abort
        return ['test', '-v']
    endfunction

    function! command.cd() abort
        return fnamemodify(expand('%:p'), ':h')
    endfunction

    return command
endfunction
