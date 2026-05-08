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

autocmd FileType gitcommit call AutoInsertJiraToBody()

function! GetJira()
  let branch = system("git branch --show-current")->trim()

  if v:shell_error != 0 || branch ==# ''
    return ''
  endif

  let jira = matchstr(branch, '[A-Z]\+-\d\+')
  return jira
endfunction

function! AutoInsertJiraToBody()
  let jira = GetJira()
  if jira ==# ''
    return
  endif

  " empty title and body
  if getline(1) ==# "" && getline(2) =~# '^#'
    let jira_tag = "[J:" . jira . "]"
    call append(1, ["", "- " . jira_tag])
  endif
endfunction

function! InsertJiraToBody()
  let jira = GetJira()
  if jira ==# ''
    return
  endif

  let jira_tag = "- [J:" . jira . "]"
  let lnum = 1
  let max = line('$')
  let insert_at = -1

  while lnum <= max
    let line = getline(lnum)

    " comment
    if line =~# '^#'
      let insert_at = lnum - 1
      break
    endif

    " exact jira already present
    if line ==# jira_tag
      echoerr "Jira tag already exists in commit body"
      return
    endif

    " first bullet
    if insert_at == -1 && line[0] ==# '-'
      let insert_at = lnum - 1
    endif

    let lnum += 1
  endwhile

  if insert_at == -1
    call append(max, ["", jira_tag])
  else
    call append(insert_at, jira_tag)
  endif
endfunction
