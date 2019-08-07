
function! tdd#model#test_command#new(command, cd) abort
    let test_command = {
       \ 'command': a:command,
       \ 'cd': a:cd,
    \ }
    return test_command
endfunction
