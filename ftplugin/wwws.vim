
" Only init once
if get(b:, 'wwws_init', 0)
    finish
endif
let b:wwws_init = 1

" ======= Commands =========================================

command! -buffer -nargs=0 Connect :call wwws#conn#Open()
command! -buffer -nargs=0 Disconnect :call wwws#conn#Close()
command! -buffer -nargs=+ Send :call wwws#conn#Send(<q-args>)


" ======= Output window prep ===============================

call wwws#EnsureOutput()

" ======= Final wwws buffer configs ========================

augroup WWWS
    autocmd!
    autocmd BufHidden <buffer> :call wwws#conn#_closed()
    autocmd BufDelete <buffer> :call wwws#conn#_closed()
    autocmd BufUnload <buffer> :call wwws#conn#_closed()
    autocmd BufWrite <buffer> :call wwws#conn#TryConnect()
augroup END

if g:wwws_auto_connect
    call wwws#conn#Open()
endif

if g:wwws_create_maps
    nnoremap <buffer> <cr> :call wwws#buffer#SendParagraph()<cr>
endif
