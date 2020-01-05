
function! tdd#command#vim#vim#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'vim'
    endfunction

    function! command.args() abort
        return ['-es', '-u', 'NONE', '+source ' . expand('%:p'), '+%print', '+qall!']
    endfunction

    function! command.args_for_file() abort
        return self.args()
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'run'
    endfunction

    return command
endfunction
