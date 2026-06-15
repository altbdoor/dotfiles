set number
set encoding=utf-8

syntax on
set re=0
set laststatus=2
colorscheme pablo
set background=dark
let g:loaded_matchparen=1

filetype indent plugin on
set belloff=all

" tabs and spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set shiftround
set autoindent
set smartindent

" no swap pls
set nobackup
set noswapfile

" search
set ignorecase
set smartcase

autocmd FileType gitcommit call InsertJiraToBody()

function! GetJira()
  let branch = system("git branch --show-current")->trim()

  if v:shell_error != 0 || branch ==# ''
    return ''
  endif

  let jira = matchstr(branch, '[A-Z]\+-\d\+')
  return jira
endfunction

function! InsertJiraToBody()
  let jira = GetJira()
  if jira ==# ''
    return
  endif

  let first_line = getline(1)
  let jira_tag = "[ML:" . jira . "]"

  " empty commit
  if first_line ==# ''
    call setline(1, jira_tag)
    return
  endif

  " already has tag
  if stridx(first_line, jira_tag) >= 0
    return
  endif

  " contains colon
  if first_line =~ ':'
    let patchedline = substitute(first_line, ':\s*', ': ' . jira_tag . ' ', '')
    call setline(1, patchedline)
  endif
endfunction
