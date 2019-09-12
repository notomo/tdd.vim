
function! tdd#command#javascript#jest#new(params) abort
    let command = {}

    let node_modules_path = tdd#util#search_parent_recursive('node_modules', './')
    if empty(node_modules_path)
        return v:null
    endif
    let command.node_modules_path = node_modules_path

    function! command.executable() abort
        if filereadable(self.node_modules_path . '/.bin/jest')
            return 'npx'
        endif
        throw 'not supported global installed jest'
    endfunction

    function! command.args() abort
        return ['jest']
    endfunction

    function! command.cd() abort
        return fnamemodify(self.node_modules_path, ':h:h')
    endfunction

    return command
endfunction
