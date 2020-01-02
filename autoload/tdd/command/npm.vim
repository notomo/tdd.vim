
function! tdd#command#npm#new(params) abort
    let command = tdd#command#_default#new(a:params)

    let package_json_path = tdd#util#search_parent_recursive('package.json', './')
    if empty(package_json_path)
        return v:null
    endif
    let command.package_json_path = package_json_path

    function! command.executable() abort
        return 'npm'
    endfunction

    function! command.args() abort
        return ['run', 'test']
    endfunction

    function! command.cd() abort
        return fnamemodify(self.package_json_path, ':h')
    endfunction

    return command
endfunction
