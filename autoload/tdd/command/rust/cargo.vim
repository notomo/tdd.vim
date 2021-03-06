
function! tdd#command#rust#cargo#new(params) abort
    let command = tdd#command#_default#new(a:params)

    let cargo_path = tdd#util#search_parent_recursive('Cargo.toml', './')
    if empty(cargo_path)
        return v:null
    endif
    let command.cargo_path = cargo_path

    function! command.executable() abort
        return 'cargo'
    endfunction

    function! command.args() abort
        return ['run']
    endfunction

    function! command.cd() abort
        return fnamemodify(self.cargo_path, ':h')
    endfunction

    function! command.match_type(type) abort
        return a:type ==? 'run'
    endfunction

    return command
endfunction
