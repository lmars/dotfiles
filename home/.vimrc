call pathogen#infect()

syntax enable
colors blackboard

let mapleader=','

set smartindent
set autoindent
set expandtab
set softtabstop=2
set shiftwidth=2
set hidden
set history=1000
set laststatus=2
set autoread
set nobackup       " no backup files
set nowritebackup  " only in case you don't want a backup file while editing
set noswapfile     " no swap files
set hlsearch       " highlight search matches
set pastetoggle=<F2>
set showcmd
set encoding=utf-8

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1

filetype on
filetype plugin on
filetype indent on

" close current buffer with <leader>x
map <silent> <leader>x :bd<CR>

" show whitespace with <leader>s
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" switch to previous buffer with <leader>a
map <silent> <leader>a :b#<CR>

" set lines=40 with <leader>l
map <silent> <leader>l :set lines=40<CR>

" turn on line numbers with <leader>n
map <silent> <leader>n :set invnumber<CR>

" write to file with <leader>w
map <silent> <leader>w :w<CR>

" open ctrlp with <leader>p
map <silent> <leader>p <c-p>

" open ctrlp in buffer mode with <leader>b
map <silent> <leader>b :CtrlPBuffer<CR>

" toggle highlighting with <leader>h
map <silent> <leader>h :set invhlsearch<CR>

" type :GitGrep with <leader>g
map <leader>g :GitGrep<space>

let g:ackhighlight=1

" make the checksyntax plugin automatically check ruby syntax after save
let g:checksyntax={'ruby': {'cmd': 'ruby -c', 'okrx': 'Syntax OK', 'auto': 1}}

" Customise Powerline
let g:Powerline_stl_path_style = 'short'
call Pl#Theme#InsertSegment('pwd', 'before', 'fileinfo')

" CTRL-X is Cut in Visual mode
vnoremap <C-X> "+x

" CTRL-C is Copy in Visual mode
vnoremap <C-C> "+y

" CTRL-V is Paste in Insert mode
imap <C-V>  <ESC>"+]pa

" Highlight anything past 80 characters in red
highlight OverLength ctermbg=red ctermfg=white
match OverLength /\%81v.\+/

let g:slime_target = "tmux"
