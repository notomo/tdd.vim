
function! tdd#command#_default#new(params) abort
    let command = {}

    function! command.executable() abort
        throw 'must be implemented'
    endfunction

    function! command.args() abort
        return []
    endfunction

    function! command.cd() abort
        return '.'
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'test'
    endfunction

    return command
endfunction
