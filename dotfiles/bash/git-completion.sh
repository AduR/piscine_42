#!/usr/bin/env bash

function source_if_exists()
{
    file="$1"

    if [[ -e "$file" ]]
    then
        source "$file"
    fi
}

# depending on OS and version

# centos
source_if_exists "/etc/bash_completion.d/git"

source_if_exists "/etc/bash_completion.d/git-prompt"

source_if_exists "/usr/lib/git-core/git-sh-prompt/git-sh-prompt.sh"

source_if_exists "/usr/share/bash-completion/completions/git"

# centos
source_if_exists "/usr/share/git-core/contrib/completion/git-prompt.sh"
