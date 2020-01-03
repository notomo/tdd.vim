
function! tdd#command#lua#source#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'luafile'
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

    function! command.job_type() abort
        return 'excmd'
    endfunction

    return command
endfunction
