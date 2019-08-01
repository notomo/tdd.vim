
function! tdd#model#test_command#new(command) abort
    let test_command = {
       \ 'command': a:command,
    \ }
    return test_command
endfunction
