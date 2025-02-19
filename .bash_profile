# macbook and arm chips
# ========================================
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
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
    eval "$(pyenv init -)"
fi

# uv
# ========================================
if [[ "$is_windows" == "ON" && -f "$HOME/.local/bin/uv" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
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
export BUILDX_GIT_INFO="false"

# git stuff
# ========================================
# if you need the git prompt script
install_git_completion() {
    local target_dir="$HOME"
    curl -sL 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' -o "$target_dir/git-completion.bash"
    curl -sL 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh' -o "$target_dir/git-prompt.sh"
    chmod +x "$target_dir/git-completion.bash" "$target_dir/git-prompt.sh"
    source "$target_dir/git-prompt.sh"
    source "$target_dir/git-completion.bash"
}

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
    local venv_name="$(pyenv version-name)"
    local glob_venv_name="$(pyenv global)"

    if [[ "$venv_name" == "" || "$venv_name" == "$glob_venv_name" ]]; then
        echo ""
    else
        echo " ($venv_name)"
    fi
}

# https://gist.github.com/vratiu/9780109

# Reset
COLOR_OFF="\[\033[0m\]"

# Regular Colors
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"

# High Intensty
IBLACK="\[\033[0;90m\]"
IRED="\[\033[0;91m\]"
IGREEN="\[\033[0;92m\]"
IYELLOW="\[\033[0;93m\]"
IBLUE="\[\033[0;94m\]"
IPURPLE="\[\033[0;95m\]"
ICYAN="\[\033[0;96m\]"
IWHITE="\[\033[0;97m\]"

PS1="\n$IRED[\u]"
if [[ "$is_windows" == "ON" ]]; then
    PS1="\n$IBLUE[\u]"
fi

PS1+=" $GREEN\w$CYAN\`__git_ps1\`"

if [[ ${has_pyenv} == 1 ]]; then
    PS1+="$PURPLE\`check_pyenv\`"
fi

PS1+=" $COLOR_OFF\n\\$ "
export PS1

# bash env
if [[ -f "$HOME/.bash_env" ]]; then
    source "$HOME/.bash_env"
fi
