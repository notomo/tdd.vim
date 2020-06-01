
function! s:load_commands() abort
    let pattern = 'autoload/tdd/command/**/**.vim'
    let paths = globpath(&runtimepath, pattern, v:true, v:true)
    call map(paths, { _, p -> fnamemodify(p, ':gs?\?/?:s?^.*\/autoload\/tdd\/command\/??:r')})
    call filter(paths, { _, p -> !empty(p) && p[0] !=# '_' })
    let commands = {}
    for path in paths
        let f = {'name': printf('tdd#command#%s#new', substitute(path, '\/', '#', 'g'))}
        function! f.get(params) abort
            return call(self.name, [a:params])
        endfunction
        let commands[path] = copy(f)
    endfor
    return commands
endfunction

function! tdd#command#reset() abort
    let s:commands = s:load_commands()
    let s:options = {}
    let s:filetype_commands = {
        \ 'vim': ['vim/themis', 'vim/source', 'vim/execute', 'vim/vim', 'vim/nvim'],
        \ 'lua': ['lua/vusted', 'lua/busted', 'lua/lua', 'lua/source'],
        \ 'javascript': ['javascript/jest', 'javascript/node'],
        \ 'typescript': ['javascript/jest', 'typescript/tsnode'],
        \ 'typescript.tsx': ['javascript/jest'],
        \ 'typescriptreact': ['javascript/jest'],
        \ 'go': ['go/gotest', 'go/go'],
        \ 'python': ['python/pytest', 'python/python'],
        \ 'ruby': ['ruby/ruby'],
        \ 'rust': ['rust/cargotest', 'rust/cargo'],
        \ 'sh': ['sh/sh'],
        \ '_': ['make'],
    \ }
endfunction

call tdd#command#reset()

function! tdd#command#factory(names, type, args) abort
    let filetype = &filetype
    if !empty(a:names)
        let names = a:names
    elseif has_key(s:filetype_commands, filetype)
        let names = s:filetype_commands[filetype]
    else
        let names = s:filetype_commands['_']
    endif

    let exactly_one = len(names) == 1
    for name in names
        if has_key(s:options, name)
            let alias = s:commands[name].get({})
            let params = s:options[name]
            let command = tdd#command#_alias#new(alias, params)
        elseif has_key(s:commands, name)
            let command = s:commands[name].get({})
        else
            return [v:null, printf('not found command: %s', name)]
        endif

        if !empty(command) && (exactly_one || command.match_type(a:type))
            if !empty(a:args)
                let command = tdd#command#_alias#new(command, {'args': a:args})
            endif
            return [command, '']
        endif
    endfor

    return [v:null, printf('not found available command: filetype=%s', filetype)]
endfunction

function! tdd#command#names() abort
    return keys(s:commands)
endfunction

function! tdd#command#filetype(filetype, command_names) abort
    if type(a:filetype) != v:t_string
        throw printf('filetype must be a string')
    endif
    if type(a:command_names) != v:t_list
        throw printf('command_names must be a list')
    endif
    let s:filetype_commands[a:filetype] = a:command_names
endfunction

function! tdd#command#alias(name, base_name) abort
    if !has_key(s:commands, a:base_name)
        throw printf('not found base command: %s', a:base_name)
    endif

    let f = {'base_name': a:base_name}
    function! f.get(params) abort
        let alias = s:commands[self.base_name].get(a:params)
        return tdd#command#_alias#new(alias, a:params)
    endfunction

    let s:commands[a:name] = f
endfunction

function! tdd#command#args(name, args) abort
    if !has_key(s:commands, a:name)
        throw printf('not found command: %s', a:name)
    endif
    if type(a:args) != v:t_list
        throw printf('args must be a list, but actual: %s', a:args)
    endif
    if !has_key(s:options, a:name)
        let s:options[a:name] = {}
    endif
    let s:options[a:name]['args'] = a:args
endfunction
