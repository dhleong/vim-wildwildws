" Author: dhleong
" Description: Main entry point for the plugin: sets up settings, etc.

if exists('g:loaded_wildwildws')
    finish
endif
let g:loaded_wildwildws = 1

" ======= Settings =========================================

" Auto-connect when a wwws buffer is opened
let g:wwws_auto_connect = get(g:, 'wwws_auto_connect', 1)

" Create some helpful maps in a wwws input window
let g:wwws_create_maps = get(g:, 'wwws_create_maps', 1)


" ======= Commands =========================================

command! -nargs=+ WWWS :call wwws#OpenNew(<f-args>)
