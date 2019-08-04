
function! tdd#event#emitter() abort
    let emitter = {}

    function! emitter.finish_job(id) abort
        execute 'doautocmd User TDDJobFinished:' . a:id
    endfunction

    return emitter
endfunction
