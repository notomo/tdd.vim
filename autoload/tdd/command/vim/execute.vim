
function! tdd#command#vim#execute#new(params) abort
    let command = tdd#command#_default#new(a:params)
    let command.params = a:params

    function! command.executable() abort
        " HACK
        return ''
    endfunction

    function! command.args() abort
        return get(self.params, 'args', [])
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
