# macbook and arm chips
# ========================================
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi

# os check
# ========================================
is_windows="OFF"
if [[ -d '/c/Windows/' ]]; then
    is_windows="ON"
fi

# bells
# ========================================
if [[ "$is_windows" == "ON" && ! -f "$HOME/.inputrc" ]]; then
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

# node
# ========================================
export NODE_OPTIONS=--dns-result-order=ipv4first
export NPM_CONFIG_FUND="false"
export NPM_CONFIG_AUDIT="false"

if command -v fnm &> /dev/null; then
    # https://github.com/Schniz/fnm
    export FNM_DIR="$HOME/.fnm"
    eval "$(fnm env --use-on-cd)"
fi

# golang
# ========================================
export GOPATH="$HOME/go"
if [[ -d "$GOPATH" ]]; then
    export PATH="$GOPATH/bin:$PATH"
fi

# docker
# ========================================
export DOCKER_CLI_HINTS="false"

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
if [[ "$is_windows" == "ON" ]]; then
    _PS1_PREFIX="\[\033[94m\][\u]"
fi

if [[ ${has_pyenv} == 1 ]]; then
    export PS1="\n${_PS1_PREFIX} \[\033[32m\]\w\[\033[36m\]\`__git_ps1\`\[\033[35m\]\`check_pyenv\` \[\033[0m\]\n\\$ "
else
    export PS1="\n${_PS1_PREFIX} \[\033[32m\]\w\[\033[36m\]\`__git_ps1\` \[\033[0m\]\n\\$ "
fi
