
function! tdd#complete#get(current_arg, line, cursor_position) abort
    let commands = tdd#config#get_commands()
    let names = keys(commands)
    return join(names, "\n")
endfunction
