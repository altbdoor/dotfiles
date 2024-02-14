# os check
# ========================================
is_windows=0
if [[ -d '/c/Windows/' ]]; then
    is_windows=1
fi

# bells
# ========================================
if [[ ${is_windows} == 1 && ! -f "$HOME/.inputrc" ]]; then
    echo "set bell-style none" > "$HOME/.inputrc"
fi

# alias
# ========================================
alias ls="ls -Ah --color=auto"
alias ll="ls -l"
alias loadprofile="source ~/.bash_profile"

# bash
# ========================================
export CLICOLOR=1
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

shopt -s histappend
shopt -s cmdhist
shopt -s no_empty_cmd_completion
shopt -s checkwinsize
bind 'set completion-ignore-case on'
bind "set menu-complete-display-prefix on"
# bind "set show-all-if-ambiguous on"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
# bind 'TAB:menu-complete'

# path
# ========================================
# export_paths=(
#     "/foo"
# )

# for i in ${export_paths[@]}; do
#     export PATH="${PATH}:${i}"
# done

# pyenv
# ========================================
has_pyenv=0
export PYENV_ROOT="$HOME/.pyenv"

if [[ -d "$PYENV_ROOT" ]]; then
    has_pyenv=1
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1

    eval "$(pyenv init -)"
    if [[ $(pyenv commands | grep virtualenv) ]]; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

# nvm
# ========================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# golang
# ========================================
export GOPATH="$HOME/go"
if [[ -d "$GOPATH" ]]; then
    export PATH="$GOPATH/bin:$PATH"
fi

# git stuff
# ========================================
# if you need the git prompt script
# curl -OL 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash'
# curl -OL 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh'
# chmod +x git-*.sh

if [[ -f "$HOME/git-prompt.sh" ]]; then
    source "$HOME/git-prompt.sh"
fi

if [[ -f "$HOME/git-completion.bash" ]]; then
    source "$HOME/git-completion.bash"
fi

export GIT_MERGE_AUTOEDIT=no

# playstation with rgb
# ========================================
function check_pyenv {
    venv_name="$(pyenv version-name)"
    glob_venv_name="$(pyenv global)"

    if [[ "$venv_name" == "" || "$venv_name" == "$glob_venv_name" ]]; then
        echo ""
    else
        echo " ($venv_name)"
    fi
}

_PS1_PREFIX="\[\033[91m\][\u]"
if [[ ${is_windows} == 1 ]]; then
    _PS1_PREFIX="\[\033[94m\][\u]"
fi

if [[ ${has_pyenv} == 1 ]]; then
    export PS1="\n${_PS1_PREFIX} \[\033[32m\]\w\[\033[36m\]\`__git_ps1\`\[\033[35m\]\`check_pyenv\` \[\033[0m\]\n\\$ "
else
    export PS1="\n${_PS1_PREFIX} \[\033[32m\]\w\[\033[36m\]\`__git_ps1\` \[\033[0m\]\n\\$ "
fi
