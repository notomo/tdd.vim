
function! tdd#command#shell#bash#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'bash'
    endfunction

    function! command.args_for_file() abort
        return [expand('%:t')]
    endfunction

    function! command.cd() abort
        return expand('%:p:h')
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'run'
    endfunction

    return command
endfunction
