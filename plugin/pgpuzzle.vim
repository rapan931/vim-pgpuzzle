scriptencoding utf-8
if exists('g:loaded_pgpuzzle')
  finish
endif
let g:loaded_pgpuzzle = 1

let s:save_cpo = &cpo
set cpo&vim

" load autoloads functions (for cli mode completion used)
let g:pgpuzzle_auto_load = get(g:, "pgpuzzle_auto_load", 0)
if g:pgpuzzle_auto_load
  let a = pgpuzzle#missionaries_and_cannibals#dummy
  " let a = pgpuzzle#other#dummy
  " let a = pgpuzzle#other2#dummy
endif

let &cpo = s:save_cpo
unlet s:save_cpo
