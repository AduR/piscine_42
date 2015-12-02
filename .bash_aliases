
#
# Color definitions - for fancy prompt PS1 or colored man
#

black='\e[0;30m'
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
blue='\e[0;34m'
purple='\e[0;35m'
cyan='\e[0;36m'
white='\e[0;37m'
nc="\e[m"

#
# Colored man
#

#mb      blink     start blink
#md      bold      start bold
#me      sgr0      turn off bold, blink and underline
#so      smso      start standout (reverse video)
#se      rmso      stop standout
#us      smul      start underline
#ue      rmul      stop underline

export LESS_TERMCAP_mb=$'\E[01;31m'     # begin blinking
export LESS_TERMCAP_md=$'\E[32m'        # begin bold
#export LESS_TERMCAP_md=$'\E[01;32;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'         # end mode
export LESS_TERMCAP_se=$'\E[0m'         # end standout-mode
export LESS_TERMCAP_so=$'\E[31m'        # begin bold
#export LESS_TERMCAP_so=$'\E[01;31;5;74m'  # begin bold
export LESS_TERMCAP_ue=$'\E[0m'         # end underline
export LESS_TERMCAP_us=$'\E[34m'        # begin underline
#export LESS_TERMCAP_us=$'\E[04;34;5;146m' # begin underline

#
# Fancy prompt PS1
#

_ps1_update () {
    last_cmd_ret=$?
    PS1=""

    # window title
    PS1+=$(printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}")

    # date
    PS1+="${cyan}\t${nc} "

    # login + hostname
    tmp="${USER}@${HOSTNAME}"
    if [ "$tmp" == "nodraak@macbian8" ]; then
        PS1+="${green}$tmp${nc} "
    else
        PS1+="${yellow}$tmp${nc} "
    fi

    # last cmd ret
    if [ $last_cmd_ret -ne 0 ]; then
        PS1+="${red}$last_cmd_ret${nc} "
    fi

    # git
    tmp="$(__git_ps1 "[%s]")"
    if [ -n "$tmp" ]; then
        PS1+="${yellow}$tmp${nc} "
    fi

    # cwd
    PS1+="${blue}\w${nc} "

    # finally, new line + user/root prompt
    PS1+="\n\$"
}

PROMPT_COMMAND="_ps1_update"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto verbose git"

#
# Aliases
#

# basic
alias ll='ls -lGh'
alias la='ls -lGha'
alias lla='la'
alias grep='grep --color'

alias py='python'
alias py3='python3'
alias ipy='ipython'
alias pip3='python3 -m pip'

# dev
alias gcc='gcc -fdiagnostics-color=auto'
alias g='git'  # now this is what I call 'lazy'
complete -o default -o nospace -F _git g
alias gg='gitg'
alias sba='source ../bin/activate'
alias cc='compass compile'
complete -o nospace -F _filedir_xspec cc
alias pmr='python manage.py runserver'
alias pylint='pylint --comment=y'
complete -o nospace -F _filedir_xspec pylint
alias pylintd='pylint --load-plugins pylint_django'

cvg () {
    coverage erase
    echo "Starting tests ..."
    coverage run ./manage.py test
    echo "Generating html report ..."
    coverage html
}

# misc
alias pdflatex='pdflatex -file-line-error -halt-on-error'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
HISTIGNORE="jrnl *"
eval "$(thefuck-alias)"  # pip thefuck
bind Space:magic-space  # expand !!, ^old^new, etc

#
# Misc stuff
#

alias texspell="aspell -d en -t -c MiniProject.tex --extra-dicts=custom.rws"
# sudo aspell --lang=en create master /usr/lib/aspell/custom.rws < ./dic.txt

export EDITOR=vim  # for git, crontab, ...

o () {
    if [ $# -eq 0 ];
    then
        echo 'No arg, I need something to open.'
        exit 1
    fi

    file=$1
    ext=${file##*.}

    case $ext in
        png|jpg|jpeg )
            cmd="eog"
            ;;
        mp3|flac|mp4|mkv|avi )
            cmd="vlc"
            ;;
        pdf )
            #cmd="evince"
            cmd="zathura"
            ;;
        txt|md|tex|c|h|py|css|scss|js|json|sh )
            cmd="sublime"
            ;;
        html )
            cmd="firefox"
            ;;
        * )
            if [ $# -eq 1 ];
            then
                case $ext in
                    zip )
                        cmd="unzip"
                        ;;
                    gz )
                        cmd="tar -xzf"
                        ;;
                    * )
                        echo "unknown extension ($ext), or tricky cmd (gz, ...), using caja for opening $@"
                        cmd="caja"
                        ;;
                esac
            else
                echo "unknown extension ($ext), or tricky cmd (gz, ...), using caja for opening $@"
                cmd="caja"
            fi
            ;;
    esac

    exec $cmd $@ &

    return 0
}
complete -o nospace -F _filedir_xspec o

ssh () {
    echo -n -e "\e]0;ssh - $@\a"
    /usr/bin/ssh "$@"
}

export GOPATH=~/gopath
export PATH=$GOPATH:$GOPATH/bin:${PATH}
export DRIVE_GOMAXPROCS=8

#
# Unused
#

#alias netmap='nmap -v -sn'

# ece - fpga basys2
#alias xilinx='env WINEPREFIX="/home/nodraak/.wine" wine C:\\windows\\command\\start.exe /Unix /home/nodraak/.wine/dosdevices/c:/users/Public/Bureau/Xilinx\ \ ISE\ 9.2i.lnk &> /dev/null'
#alias tobasys='sudo djtgcfg prog -d Basys2 -i 0 -f'

#
# Tmp stuff (to be deleted at the end of the year)
#

alias gpsServer="rdesktop -u user -p user -a 16 192.168.1.104 -g 90%"
alias tamere='klog achard15'

#
# Finally, stuff that print something
#

#linuxlogo
#fortune
