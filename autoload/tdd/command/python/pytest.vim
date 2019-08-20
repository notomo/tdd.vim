
function! tdd#command#python#pytest#new(params) abort
    let command = {}

    function! command.executable() abort
        return 'pytest'
    endfunction

    function! command.args() abort
        return [expand('%:p')]
    endfunction

    function! command.cd() abort
        return fnamemodify(expand('%:p'), ':h')
    endfunction

    function! command.cd_for_file() abort
        let ini_path = tdd#util#search_parent_recursive('pytest\.ini', './')
        if !empty(ini_path)
            return fnamemodify(ini_path, ':h')
        endif
        return self.cd()
    endfunction

    return command
endfunction
