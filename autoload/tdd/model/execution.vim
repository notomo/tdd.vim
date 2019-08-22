
function! tdd#model#execution#from_command(command, args, target) abort
    if type(a:args) == v:t_list
        let args = a:args
    elseif a:target ==# 'file' && has_key(a:command, 'args_for_file')
        let args = a:command.args_for_file()
    elseif a:target ==# 'project'  && has_key(a:command, 'args_for_project')
        let args = a:command.args_for_project()
    else
        let args = a:command.args()
    endif
    let cmd = [a:command.executable()] + args

    if a:target ==# 'file' && has_key(a:command, 'cd_for_file')
        let cd = a:command.cd_for_file()
    elseif a:target ==# 'project'  && has_key(a:command, 'cd_for_project')
        let cd = a:command.cd_for_project()
    else
        let cd = a:command.cd()
    endif

    return tdd#model#execution#new(cmd, cd)
endfunction

function! tdd#model#execution#new(cmd, cd) abort
    return {
        \ 'command': a:cmd,
        \ 'cd': a:cd,
    \ }
endfunction
