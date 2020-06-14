
function! tdd#command#lua#busted#new(params) abort
    let command = tdd#command#_default#new(a:params)

    function! command.executable() abort
        return 'busted'
    endfunction

    function! command.args_for_file() abort
        let pattern = printf('^%s', expand('%:t:r'))
        return ['--pattern=' .. pattern, expand('%:p:h')]
    endfunction

    function! command.cd() abort
        let git_path = tdd#util#search_parent_recursive('.git', './')
        return fnamemodify(git_path, ':h:h')
    endfunction

    return command
endfunction
