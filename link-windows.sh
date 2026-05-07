#!/bin/bash

files="\
.bash_profile -> $HOME/.bash_profile
.vimrc -> $HOME/.vimrc
AGENTS.md -> $HOME/.config/opencode/AGENTS.md
"

while IFS='' read -r line; do
    if [[ -z "$line" || "$line" == \#* ]]; then
        continue
    fi

    src="${line%% -> *}"
    dest="${line##* -> }"

    if [[ -f "./$src" ]]; then
        cp --verbose "./$src" "$dest"
    else
        echo "Invalid source file, $src"
    fi
done <<< "$files"
