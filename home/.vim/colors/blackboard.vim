" Vim color scheme
"
" Name:         blackboard.vim
" Maintainer:   Ben Wyrosdick <ben.wyrosdick@gmail.com> 
" Last Change:  20 August 2009
" License:      public domain
" Version:      1.4

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let g:colors_name = "blackboard"

if has("gui_running")
  "GUI Colors
  highlight Normal guifg=White   guibg=#0B1022
  highlight Cursor guifg=Black   guibg=Yellow
  highlight CursorLine guibg=#191E2F
  highlight LineNr guibg=#323232 guifg=#888888
  highlight Folded guifg=#f1f3e8 guibg=#444444
  highlight Pmenu guibg=#84A7C1

  "General Colors
  highlight Comment guifg=#AEAEAE
  highlight Constant guifg=#CAFE1E
  highlight Keyword guifg=#FFDE00
  highlight String guifg=#00D42D
  highlight Type guifg=#84A7C1
  highlight Identifier guifg=#00D42D gui=NONE
  highlight Function guifg=#FF5600 gui=NONE
  highlight clear Search
  highlight Search guibg=#1C3B79
  highlight PreProc guifg=#FF5600
else
  set t_Co=256
  highlight Normal ctermfg=15 ctermbg=233
  highlight LineNr ctermbg=236 ctermfg=245
  highlight Comment ctermfg=244
  highlight Constant ctermfg=226
  highlight Keyword ctermfg=220
  highlight String ctermfg=40
  highlight Type ctermfg=110
  highlight Identifier ctermfg=40
  highlight Function ctermfg=202
  highlight PreProc ctermfg=202
  highlight clear Search
  highlight Search ctermbg=24
  highlight Special ctermfg=1
  highlight rubyInterpolation ctermfg=251
end

"HTML Colors
highlight link htmlTag Type
highlight link htmlEndTag htmlTag
highlight link htmlTagName htmlTag

"Ruby Colors
highlight link rubyClass Keyword
highlight link rubyDefine Keyword
highlight link rubyConstant Type
highlight link rubySymbol Constant
highlight link rubyStringDelimiter rubyString
highlight link rubyInclude Keyword
highlight link rubyAttribute Keyword
highlight link rubyInstanceVariable Normal

"Rails Colors
highlight link railsMethod Type
