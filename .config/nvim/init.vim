:set number relativenumber
:set smarttab
:set ai si
:syntax on

:inoremap " ""<left>
:inoremap ' ''<left>
:inoremap ( ()<left>
:inoremap [ []<left>
:inoremap { {}<left>
:inoremap {<CR> {<CR>}<ESC>O
:inoremap {;<CR> {<CR>};<ESC>O

call plug#begin()

call plug#end()

