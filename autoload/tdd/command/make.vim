
function! tdd#command#make#new(params) abort
    let command = tdd#command#_default#new(a:params)

    let makefile_path = tdd#util#search_parent_recursive('Makefile', './')
    if empty(makefile_path)
        return v:null
    endif
    let command.makefile_path = makefile_path

    function! command.executable() abort
        return 'make'
    endfunction

    function! command.args() abort
        return ['test']
    endfunction

    function! command.cd() abort
        return fnamemodify(self.makefile_path, ':h')
    endfunction

    return command
endfunction
