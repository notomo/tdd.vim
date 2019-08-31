
function! tdd#command#python#pytest#new(params) abort
    let command = {}

    function! command.executable() abort
        return 'pytest'
    endfunction

    function! command.args() abort
        return ['--capture=no']
    endfunction

    function! command.args_for_file() abort
        return ['--capture=no', expand('%:p')]
    endfunction

    function! command.cd() abort
        let ini_path = tdd#util#search_parent_recursive('pytest\.ini', './')
        if !empty(ini_path)
            return fnamemodify(ini_path, ':h')
        endif
        return '.'
    endfunction

    return command
endfunction
