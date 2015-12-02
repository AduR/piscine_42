#!/usr/bin/env bash

# export or not export -> http://unix.stackexchange.com/questions/107851/using-export-in-bashrc

#set -u # exit when your script tries to use undeclared variables

#
# Set title of terminal, used by PS1 and some alias
#

set_xtitle () {
    case "$TERM" in
        *term* | rxvt)
            echo -en "\033]0;$@\007"
            ;;
        *)
            ;;
    esac
}

#
# Color definitions - for fancy prompt PS1 or colored man
#

# Normal Colors
Black='\e[0;30m'
Red='\e[0;31m'
Green='\e[0;32m'
Yellow='\e[0;33m'
Blue='\e[0;34m'
Purple='\e[0;35m'
Cyan='\e[0;36m'
White='\e[0;37m'

# Bold
BBlack='\e[1;30m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
BCyan='\e[1;36m'
BWhite='\e[1;37m'

# Background
On_Black='\e[40m'
On_Red='\e[41m'
On_Green='\e[42m'
On_Yellow='\e[43m'
On_Blue='\e[44m'
On_Purple='\e[45m'
On_Cyan='\e[46m'
On_White='\e[47m'

# Color Reset
NC="\e[m"

#
# Colored man
#

# mb start blink
# md start bold
# me turn off bold, blink and underline
# so start standout (reverse video)
# se stop standout
# us start underline
# ue stop underline

export LESS_TERMCAP_mb=$'\E[0m'
export LESS_TERMCAP_md=$'\E[0;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[0;31m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[0;34m'
export LESS_TERMCAP_ue=$'\E[0m'

#
# Fancy prompt PS1
#

_ps1_update () {
    local last_cmd_ret="$?"  # must be first

    local tmp
    PS1=""

    # window title
    set_xtitle "${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}"

    # date
    PS1+="${Cyan}\t${NC} "

    # login + hostname
    tmp="${USER}@${HOSTNAME}"
    if [[ "$tmp" = "nodraak@macbian8" ]]; then
        PS1+="${Green}$tmp${NC} "
    else
        PS1+="${Red}$tmp${NC} "
    fi

    # last cmd ret
    if [[ "$last_cmd_ret" != "0" ]]; then
        PS1+="${Red}$last_cmd_ret${NC} "
    fi

    # git
    if [[ "$(type -t __git_ps1)" = "" ]]; then
        PS1+="${Red}gitNotFound${NC} "
    else
        tmp="$(__git_ps1 "[%s]")"
        if [[ -n "$tmp" ]]; then
            PS1+="${Yellow}$tmp${NC} "
        fi
    fi

    # cwd
    PS1+="${Blue}\w${NC} "

    # finally, new line + user/root prompt
    PS1+="\n\\$ "

    # no "export PS1" needed
}

PROMPT_COMMAND="_ps1_update"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto verbose git"

#
# Aliases
#

# basic
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias ll='ls -lGh'
alias la='ls -lGha'
alias lla='la'
alias grep='grep --color'
alias du='du -kh'
alias df='df -khT'

alias ipy='ipython'
alias py3='python3'
alias pip3='python3 -m pip'

# dev
alias gcc='gcc -fdiagnostics-color=auto'
alias g='git'  # now this is what I call 'lazy'
complete -o default -o nospace -F _git g
alias gg='set_xtitle "gitg" ; gitg'
alias sba='source ../bin/activate'
alias cc='compass compile'
complete -o nospace -F _filedir_xspec cc
alias pmr='set_xtitle "python manage.py runserver" ; python manage.py runserver'
alias pylint='pylint --comment=y'
complete -o nospace -F _filedir_xspec pylint
alias pylintd='pylint --load-plugins pylint_django'

cvg () {
    set_xtitle "coverage"
    coverage erase
    echo "Starting tests ..."
    coverage run ./manage.py test
    echo "Generating html report ..."
    coverage html
}

# misc
_pdflatex () {
    set_xtitle "pdfLaTeX - $@"
    /usr/bin/env pdflatex -file-line-error -halt-on-error "$@"
}
alias pdflatex='_pdflatex'

HISTIGNORE='jrnl *'  # no export needed
eval "$(thefuck-alias)"  # pip thefuck
bind Space:magic-space  # expand !!, ^old^new, etc

#
# Misc stuff
#
alias htop='set_xtitle "htop - ${HOSTNAME}" ; htop'
alias texspell="aspell -d en -t -c MiniProject.tex --extra-dicts=custom.rws"
# sudo aspell --lang=en create master /usr/lib/aspell/custom.rws < ./dic.txt

export EDITOR="vim"  # for git, crontab, ...

o () {
    local cmd

    if [[ $# -eq 0 ]]; then
        echo 'Error: argument expected.'
        exit 1
    fi

    cmd=""

    case $1 in
        *.png|*.jpg|*.jpeg )
            cmd="eog"
            ;;
        *.mp3|*.flac|*.mp4|*.mkv|*.avi )
            cmd="vlc"
            ;;
        *.pdf )
            #cmd="evince"
            cmd="zathura"
            ;;
        *.txt|*.md|*.tex|*.c|*.h|*.py|*.css|*.scss|*.js|*.json|*.sh )
            cmd="sublime"
            ;;
        *.html )
            cmd="firefox"
            ;;
        * )
            if [ $# -eq 1 ];
            then
                case $1 in
                    *.tar.bz2)  cmd="tar xvjf"      ;;
                    *.tar.gz)   cmd="tar xvzf"      ;;
                    *.bz2)      cmd="bunzip2"       ;;
                    *.rar)      cmd="unrar x"       ;;
                    *.gz)       cmd="gunzip"        ;;
                    *.tar)      cmd="tar xvf"       ;;
                    *.tbz2)     cmd="tar xvjf"      ;;
                    *.tgz)      cmd="tar xvzf"      ;;
                    *.zip)      cmd="unzip"         ;;
                    *.Z)        cmd="uncompress"    ;;
                    *.7z)       cmd="7z x"          ;;
                esac
            fi
            ;;
    esac

    if [[ "$cmd" = "" ]]; then
        echo 'Error: unknown extension "$ext", using caja for opening "$@"'
        cmd="caja"
    fi

    exec "$cmd" "$@" &
}
complete -o nospace -F _filedir_xspec o

# how can I make this more generic ?
py () {
    set_xtitle "python - $@"
    /usr/bin/env python "$@"
}
ssh () {
    set_xtitle "ssh - $@"
    /usr/bin/env ssh "$@"
}
man () {
    set_xtitle "man - $@"
    /usr/bin/env man "$@"
}
sublime () {
    set_xtitle "sublime - $@"
    /usr/bin/env sublime "$@"
}

export GOPATH=~/gopath
export PATH=$GOPATH:$GOPATH/bin:${PATH}
export DRIVE_GOMAXPROCS=8

#
# Tmp / unused stuff (to be deleted at the end of the year)
#

#alias netmap='nmap -v -sn'

# ece - fpga basys2
#alias xilinx='env WINEPREFIX="/home/nodraak/.wine" wine C:\\windows\\command\\start.exe /Unix /home/nodraak/.wine/dosdevices/c:/users/Public/Bureau/Xilinx\ \ ISE\ 9.2i.lnk &> /dev/null'
#alias tobasys='sudo djtgcfg prog -d Basys2 -i 0 -f'

# aau
alias gpsServer="rdesktop -u user -p user -a 16 192.168.1.104 -g 90%"
alias tamere='klog achard15'

#
# Finally, stuff that print something
#

#linuxlogo

# Makes our day a bit more fun !
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s
fi
