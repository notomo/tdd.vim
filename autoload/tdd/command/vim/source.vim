
function! tdd#command#vim#source#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'source'
    endfunction

    function! command.args_for_file() abort
        return [expand('%:p')]
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'run'
    endfunction

    function! command.job_type() abort
        return 'excmd'
    endfunction

    return command
endfunction
