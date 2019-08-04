
let s:id = 0

function! tdd#model#test#new(test_command, presenter) abort
    let s:id += 1
    let test = {
       \ 'id': s:id,
       \ 'test_command': a:test_command,
       \ 'job': tdd#model#job#new(a:test_command, a:presenter),
    \ }

    function! test.start(event_emitter) abort
        call self.job.start(a:event_emitter)
    endfunction

    function! test.has_successed() abort
        return self.job.has_successed()
    endfunction

    return test
endfunction
