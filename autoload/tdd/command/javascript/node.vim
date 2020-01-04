
function! tdd#command#javascript#node#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'node'
    endfunction

    function! command.args() abort
        return [expand('%:p')]
    endfunction

    function! command.args_for_file() abort
        return self.args()
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'run'
    endfunction

    return command
endfunction
