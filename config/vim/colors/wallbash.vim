" Monochrome wallbash theme for Vim
" Pure Grayscale Aesthetic

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "wallbash"

" Basic UI
hi Normal       guifg=#eeeeee guibg=NONE    ctermfg=255 ctermbg=NONE
hi CursorLine   guibg=#222222 ctermbg=234   gui=NONE    cterm=NONE
hi LineNr       guifg=#444444 ctermfg=238
hi CursorLineNr guifg=#ffffff ctermfg=15    gui=bold    cterm=bold
hi VertSplit    guifg=#333333 guibg=NONE    ctermfg=236 ctermbg=NONE
hi StatusLine   guifg=#ffffff guibg=#333333 ctermfg=15  ctermbg=236
hi StatusLineNC guifg=#888888 guibg=#222222 ctermfg=244 ctermbg=234
hi Pmenu        guifg=#eeeeee guibg=#222222 ctermfg=255 ctermbg=234
hi PmenuSel     guifg=#111111 guibg=#ffffff ctermfg=233 ctermbg=15
hi Visual       guibg=#444444 ctermbg=238
hi Search       guifg=#111111 guibg=#cccccc ctermfg=233 ctermbg=252

" Syntax Highlighting (Monochrome)
hi Comment      guifg=#666666 ctermfg=242   gui=italic  cterm=italic
hi Constant     guifg=#ffffff ctermfg=15    gui=bold    cterm=bold
hi String       guifg=#cccccc ctermfg=252
hi Identifier   guifg=#eeeeee ctermfg=255
hi Function     guifg=#ffffff ctermfg=15    gui=bold    cterm=bold
hi Statement    guifg=#ffffff ctermfg=15    gui=bold    cterm=bold
hi PreProc      guifg=#aaaaaa ctermfg=248
hi Type         guifg=#ffffff ctermfg=15    gui=bold    cterm=bold
hi Special      guifg=#dddddd ctermfg=253
hi Underlined   guifg=#ffffff ctermfg=15    gui=underline cterm=underline
hi Error        guifg=#111111 guibg=#999999 ctermfg=233 ctermbg=246
hi Todo         guifg=#111111 guibg=#ffffff ctermfg=233 ctermbg=15 gui=bold cterm=bold
