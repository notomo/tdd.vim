if exists('g:loaded_tdd')
    finish
endif
let g:loaded_tdd = 1

command! -nargs=* TDDTest call tdd#default_test(<f-args>)
