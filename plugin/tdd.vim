if exists('g:loaded_tdd')
    finish
endif
let g:loaded_tdd = 1

command! TDDStartTest call tdd#start_test({-> tdd#model#test_command#new(['echo'])})
