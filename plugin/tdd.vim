if exists('g:loaded_tdd')
    finish
endif
let g:loaded_tdd = 1

command! TDDStartTest call tdd#default_start_test()
