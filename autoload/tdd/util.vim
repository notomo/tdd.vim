
function! tdd#util#search_parent_recursive(file_name_pattern, start_path) abort
    let path = fnamemodify(a:start_path, ':p')
    while path !=? '//'
        let files = glob(path . a:file_name_pattern, v:false, v:true)
        if !empty(files)
            let file = files[0]
            return isdirectory(file) ? file . '/' : file
        endif
        let path = fnamemodify(path, ':h:h') . '/'
    endwhile
    return ''
endfunction

function! tdd#util#parse_args(args) abort
    let names = []
    let options = {}
    for arg in a:args
        let [key, value] = tdd#util#parse_option(arg)
        if empty(key)
            call add(names, value)
            continue
        endif

        let options[key] = value
    endfor

    return [names, options]
endfunction

function! tdd#util#parse_option(factor) abort
    if a:factor[0] !=# '-'
        return ['', a:factor]
    endif

    let key_value = split(a:factor[1:], '=')
    if len(key_value) == 2
        return key_value
    endif

    let [key] = key_value
    return [key, v:true]
endfunction
