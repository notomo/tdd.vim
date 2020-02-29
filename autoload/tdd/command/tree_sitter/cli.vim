
function! tdd#command#tree_sitter#cli#new(params) abort
    let command = tdd#command#_default#new(a:params)
    let command.node_modules_path = tdd#util#search_parent_recursive('node_modules', './')

    function! command.executable() abort
        if filereadable(self.node_modules_path . 'tree-sitter-cli/tree-sitter')
            return self.node_modules_path . 'tree-sitter-cli/tree-sitter'
        endif
        return 'tree-sitter'
    endfunction

    function! command.args_for_file() abort
        return ['parse', expand('%:p'), '--time', '--timeout=200000']
    endfunction

    function! command.cd() abort
        if !empty(self.node_modules_path)
            return fnamemodify(self.node_modules_path, ':h:h')
        endif
        return '.'
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'run'
    endfunction

    return command
endfunction
