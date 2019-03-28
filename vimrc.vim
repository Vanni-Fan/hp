"--------------------------------------------------------------------------
"       $maintainer:   vanni fan<web.cn@msn.com>
"       $Last change:  2007 July 27
"
"       $for MS-DOS and Win32:  $VIM\_vimrc (80%)
"       $for UNIX, Linux and BSD:  $VIM\.vimrc (100%)
"       $detail:        When started "gvim" or "vim" it will
"                       already have done these settings.
"
"       $other: Send bug-reports, fixes, enhancements, t-shirts, money, beer
"       to me ;)
"--------------------------------------------------------------------------


"------------------------< General >--------------------------"{{{
" => General
"-------------------------------------------------------------
"Get out of VI's compatible mode..
"设置VIM or VI兼容模式
set nocompatible
set nobomb

"Sets how many lines of history VIM har to remember
"设置命令行记录条数
set history=400

"Enable filetype plugin
"打开文件类型插件脚本
filetype plugin on

"Enable indent
"打开语法缩进
filetype indent on

"Set to auto read when a file is changed from the outside
"文件更新时自动重新读取文件
"Set to auto read when a file is changed from the outside
"文件更新时自动重新读取文件
set autoread

"Set mapleader
"使用 "mapleader" 变量的映射
let mapleader = ","
let g:mapleader = ","

"Fast saving
"快速保存，快速查找文件并打开
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>

"Show the line and column number of the cursor position
"窗口右下角显示当前光标位置
set ruler

"Show (partial) command in status line.  Set this option off if you
"窗口右下角显示未完成的命令
set showcmd

" NERDTree的配置
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '~'
map <F10> :NERDTreeToggle<CR>

"设置tags的路径
let Tlist_Use_Right_Window = 1
set tags+=./tags,./../tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags,./../../../../../../tags,./../../../../../../../tags,./../../../../../../../../tags
map <F12> :Tlist<CR>

" 设置中文在线帮助
set helplang=cn

"设置插入括号时，短暂地跳转到匹配的对应括号
set showmatch


"设置终端粘贴文本
set nopaste

set backspace=eol,start,indent

set number
set hlsearch
set incsearch
set ignorecase
map <leader>hls :set hls!<bar>set hls?<CR>
map <leader>wr :set wrap!<bar>set wrap?<CR>
map <leader>nu :set nu!<bar>set nu?<CR>
map <leader>% :echo expand("%:p")<CR>
"}}}

"------------------------< Base >--------------------------"{{{
" => Base
"----------------------------------------------------------
function! MySys()
    return "unix"
endfunction

" Function: s:InitVariable() function
" This function is used to initialise a given variable to a given value. The
" variable is only initialised if it does not exist prior
"
" Args:
"   -var: the name of the var to be initialised
"   -value: the value to initialise var to
"
" Returns:
"   1 if the var is set, 0 otherwise
function! s:InitVariable(var, value)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . "'" . a:value . "'"
        return 1
    endif
    return 0
endfunction
"}}}

"------------------------< Custom setting >--------------------------"{{{
" => Custom setting
"--------------------------------------------------------------------
"let g:ctagsdir = "ctags"
if MySys() == "win32"
    "Fast reloading of the .vimrc
    "快速加载 vimrc 文件
    map <leader>s :source $VIM/_vimrc<cr>
    "Fast editing of .vimrc
    "快速编辑 vimrc 文件
    map <leader>e :e! $VIM/_vimrc<cr>
    "When .vimrc is edited, reload it
    "如果 vimrc 做了修改自动加载文件
    autocmd! bufwritepost vimrc source $VIM/_vimrc
endif

if MySys() == "unix"
    "Fast reloading of the .vimrc
    "快速加载 vimrc 文件
    map <leader>s :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    "快速编辑 vimrc 文件
    map <leader>e :e! ~/.vimrc<cr>
    "When .vimrc is edited, reload it
    "如果 vimrc 做了修改自动加载文件
    autocmd! bufwritepost vimrc source ~/.vimrc
endif
"}}}

"------------------------< Colors and Fonts >--------------------------"{{{
" => Colors and Fonts
"----------------------------------------------------------------------
"Enable syntax hl
"打开语法高亮
syntax enable
syn on
autocmd BufEnter * :syntax sync fromstart
set guifont=Microsoft_YaHei_Mono:h9

"vim调色板
if has("gui_running")
    colo evening
else
    colo torte
endif
"Highlight current
if has("gui_running")
  set cursorline
endif
"}}}

"------------------------< General Abbrevs >-----------------------------"{{{
" => General Abbrevs
"------------------------------------------------------------------------
"Some information
iab ____name <c-r>=g:my_mame
iab ____date <c-r>=strftime("%d-%m-%y %H:%M:%S")<cr>
"}}}

"------------------------< Moving around and tabs >----------------------"{{{
" => Moving around and tabs
"------------------------------------------------------------------------
"Map space to / and c-space to ?
map 0 ^

map <space> /
map <c-space> ?

"Smart way to move btw. windows
map <c-left> <C-W>h
map <c-up> <C-W>k
map <c-down> <C-W>j map <c-right> <C-W>l

if !has("gui_running")
    map <c-h> <C-W>h
    map <c-k> <C-W>k
    map <c-j> <C-W>j
    map <c-l> <C-W>l
    map <c-w> <C-W>
endif

  """"""""""""""""""""""""""""""
  " => Tab configuration
  """"""""""""""""""""""""""""""
  map <leader>tn :tabnew %<cr>
  map <leader>te :tabedit <cr>
  map <leader>tc :tabclose <cr>
  map <leader>gf <C-W>gf <cr>
  if has("gui_running")
      map <a-right> :tabn <cr>
      imap <a-right> <esc>:tabn <cr>
      map <a-left> :tabp <cr>
      imap <a-left> <esc>:tabp <cr>
      map <a-l> :tabn <cr>
      imap <a-l> <esc>:tabn <cr>
      map <a-h> :tabp <cr>
      imap <a-h> <esc>:tabp <cr>
      map <leader>l :tabn <cr>
      map <leader>h :tabp <cr>
  else
      map <leader>l :tabn <cr>
      map <leader>h :tabp <cr>
      map <leader>1 :tabn 1 <cr>
      map <leader>2 :tabn 2 <cr>
      map <leader>3 :tabn 3 <cr>
      map <leader>4 :tabn 4 <cr>
      map <leader>5 :tabn 5 <cr>
      map <leader>6 :tabn 6 <cr>
      map <leader>7 :tabn 7 <cr>
      map <leader>8 :tabn 8 <cr>
      map <leader>9 :tabn 9 <cr>
  endif
"}}}

"------------------------< Fileencodings & Fileformats >----------------------"{{{
" => Fileencodings & Fileformats
"-----------------------------------------------------------------------------
"Favorite filetypes
set ffs=unix,dos,mac
"Set display character encoding
" 设置文本显示默认字符集
if MySys() == "win32"
    set encoding=cp936
else
    set encoding=utf-8
endif

"Sets the character encoding for the file of this buffer.
"设置默认字符集
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,latin1

" Encoding settings
if has("multi_byte")
    " Set fileencoding priority
    if getfsize(expand("%")) > 0
        set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,latin1
    else
        set fileencodings=utf-8,cp936,big5,euc-jp,euc-kr,latin1
    endif

    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
else
    echoerr "Sorry, this version of (g)vim was not compiled with multi_byte"
endif

nmap <leader>fc :se fileencoding?<cr>
nmap <leader>ut :se fileencoding=utf-8<cr>
nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>
"}}}

"------------------------< Vim userinterface >--------------------------"{{{
" => Vim userinterface
"-----------------------------------------------------------------------
"Have the mouse enabled all the time (for GUI):
"nvic模式下都显示鼠标 GUI 下可用
"set mouse=a
"Set 7 lines to the curors - when moving vertical..
set so=7


if has("gui_running")
    "打开vim是自动最大化 GUI 可用
    au GUIEnter * simalt ~x
endif

  """"""""""""""""""""""""""""""
  " => Statusline
  """"""""""""""""""""""""""""""
  "Always hide the statusline
  set laststatus=2

  function! CurDir()
     let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
     return curdir
  endfunction

  "Format the statusline
  set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ %=\ Line:\ %l/%L:%c\

  "The commandbar is 2 high
  set cmdheight=2

  "Turn on WiLd menu
  set wildmenu
"}}}

"------------------------< Buffer realted >--------------------------"{{{
" => Buffer realted
"--------------------------------------------------------------------
"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
"}}}

"------------------------< Text options >--------------------------"{{{
" => Text options
"------------------------------------------------------------------
"use blank replace tab
"用空格代替制表符
set expandtab

"用4个空格代替tab
set shiftwidth=4
set softtabstop=4
set tabstop=4

   """"""""""""""""""""""""""""""
   " => Indent
   """"""""""""""""""""""""""""""
   "Auto indent
   "自动缩进
   set autoindent

   "C-style indeting
   set cindent

   "Smart indet
   set smartindent

   "C-indenting
   "自动的 C 程序缩进
   set cin

   "Wrap lines
   set wrap
"}}}

"------------------------< Plugin configuration >--------------------------"{{{
" => Plugin configuration
"--------------------------------------------------------------------------

  """"""""""""""""""""""""""""""
  " => Tag list (ctags)
  """"""""""""""""""""""""""""""
  "打开tag窗口
  if exists("g:ctagsdir")
      let Tlist_Ctags_Cmd = g:ctagsdir
      let Tlist_Enable_Fold_Column = 0                "使taglist插件不显示左边的折叠行，
      let Tlist_WinWidth = 20                         "taglist窗口宽度
      let Tlist_Show_One_File = 1                     "taglist插件只显示当前文件的tag
      let g:Tb_ForceSyntaxEnable = 0                  "设置taglist语法高亮
      nmap <silent> <leader>tag  :TlistToggle<CR>
  endif
"}}}

"------------------------< Other >--------------------------"{{{
" => Other
"-----------------------------------------------------------
set completeopt=menu
set foldenable
set foldmethod=marker
set foldlevel=0
set nobackup
set noswapfile
set noundofile
set langmenu=enUS
let $LANG = 'enUS'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"set path+=/hp/opt/php/lib/php
"}}}

"------------------------< Plug.vim : Plugin Manguager >------------"{{{
" 安装Plug.vim : curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 安装插件(进入VIM)： :PlugInstall
" 
call plug#begin($VIM.'/plugins')
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/taglist.vim'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'terryma/vim-multiple-cursors'
Plug 'davidhalter/jedi'
Plug 'davidhalter/jedi-vim'
Plug 'Valloric/YouCompleteMe'
Plug 'Chiel92/vim-autoformat'
Plug 'kien/rainbow_parentheses.vim'
Plug 'lambdalisue/vim-fullscreen'
call plug#end()
"}}}
