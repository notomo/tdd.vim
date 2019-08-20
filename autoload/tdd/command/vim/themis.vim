
function! tdd#command#vim#themis#new(params) abort
    let command = {}

    function! command.executable() abort
        return 'themis'
    endfunction

    function! command.args() abort
        return [expand('%:p:h')]
    endfunction

    function! command.args_for_file() abort
        return [expand('%:p')]
    endfunction

    function! command.args_for_project() abort
        return ['.']
    endfunction

    function! command.cd() abort
        let themisrc_path = tdd#util#search_parent_recursive('\.themisrc', './')
        if !empty(themisrc_path)
            return fnamemodify(themisrc_path, ':h:h')
        endif
        return '.'
    endfunction

    return command
endfunction
