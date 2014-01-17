" ~/.vimrc (configuration file for vim only)
" skeletons
function! SKEL_spec()
	language time en_US
	if $USER != ''
	    let login = $USER
	elseif $LOGNAME != ''
	    let login = $LOGNAME
	else
	    let login = 'unknown'
	endif
	let newline = stridx(login, "\n")
	if newline != -1
	    let login = strpart(login, 0, newline)
	endif
	if $HOSTNAME != ''
	    let hostname = $HOSTNAME
	else
	    let hostname = system('hostname -f')
	    if v:shell_error
		let hostname = 'localhost'
	    endif
	endif
	let newline = stridx(hostname, "\n")
	if newline != -1
	    let hostname = strpart(hostname, 0, newline)
	endif
	exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
	exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
	exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
	setf spec
endfunction
autocmd BufNewFile	*.spec	call SKEL_spec()
" filetypes
filetype plugin on
filetype indent on
" ~/.vimrc ends here
set spell
"highlight clear SpellBad
"highlight SpellBad term=reverse ctermbg=Lightgrey gui=undercurl guisp=Red
set expandtab           " enter spaces when tab is pressed
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set textwidth=77
set cino=g0
set nowrap
set modeline
set ls=2
"Markdown to HTML
nmap \md :%!/usr/local/bin/Markdown.pl --html4tags
map <F1> <Esc>
imap <F1> <Esc>
autocmd BufWritePre <buffer> :%s/\s\+$//e
"folding settings
fold
set foldmethod=indent
set nofoldenable
highlight OverLength ctermbg=118
match OverLength /\%78v.\+/
set nocp
filetype plugin on

" Set F8 to paste mode
map <F8> :set paste<CR>i
imap <F8> <ESC>:set paste<CR>i<Right>
au InsertLeave * set nopaste

" Keep blocks selected while indenting
vnoremap < <gv
vnoremap > >gv

" Yank and paste to/from the system buffer
vmap <A-c> y:call system('xclip -f -sel p \| xclip -sel c', @0)<CR>
nmap <A-v> :set paste<CR>O<Esc>:.!xclip -o -selection c<CR>:set nopaste<CR>

" Enable lazy tab completion
set wildmode=longest,list,full
set wildmenu

"Enable unlimited undoing
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

"Enable omnicopmpletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
