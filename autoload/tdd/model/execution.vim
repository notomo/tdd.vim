
function! tdd#model#execution#from_command(command, target) abort
    if a:target ==# 'file' && has_key(a:command, 'args_for_file')
        let args = a:command.args_for_file()
    elseif a:target ==# 'project'  && has_key(a:command, 'args_for_project')
        let args = a:command.args_for_project()
    elseif a:target ==# 'near'  && has_key(a:command, 'args_for_near')
        let args = a:command.args_for_near()
    else
        let args = a:command.args()
    endif
    let cmd = [a:command.executable()] + args

    if a:target ==# 'file' && has_key(a:command, 'cd_for_file')
        let cd = a:command.cd_for_file()
    elseif a:target ==# 'project'  && has_key(a:command, 'cd_for_project')
        let cd = a:command.cd_for_project()
    elseif a:target ==# 'near'  && has_key(a:command, 'cd_for_near')
        let cd = a:command.cd_for_near()
    else
        let cd = a:command.cd()
    endif

    return tdd#model#execution#new(cmd, cd)
endfunction

function! tdd#model#execution#new(cmd, cd) abort
    return {
        \ 'cmd': a:cmd,
        \ 'cd': a:cd,
    \ }
endfunction
