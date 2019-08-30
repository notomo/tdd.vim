
function! tdd#command#python#pytest#new(params) abort
    let command = {}

    function! command.executable() abort
        return 'pytest'
    endfunction

    function! command.args() abort
        return []
    endfunction

    function! command.args_for_file() abort
        return [expand('%:p')]
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
