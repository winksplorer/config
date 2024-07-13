# Just a thing for ls
alias la='exa --icons --git -a --color=auto'
alias ls='exa --icons --git --color=auto'
alias l='ls'

# short dd alias
function flash() {
    sudo dd if=$1 of=$2 status=progress
}

prompt_bottom() {
    local term_lines=$(tput lines)
    tput cup $((term_lines - 1)) 0
}

alias sudo='doas'

#grepp
alias grep='grep --color=auto'

# Useful aliases
alias clear='clear; prompt_bottom'
alias cls='clear'
alias cd..='cd ..'
alias ..='cd..'
alias ni='sudo nala install'
alias nr='sudo nala remove'
alias nu='sudo nala update'
alias nar='sudo nala autoremove'
alias ninr='sudo nala install --no-install-recommends'
alias clone='gh repo clone'
alias 7z='7zz'

# Git-clone & Change Directory
function gcd() {
    gh repo clone $1 /home/$(whoami)/repos/$(echo "$1" | awk -F'/' '{print ($2 == "" ? $1 : $2)}')
    cd /home/$(whoami)/repos/$(echo "$1" | awk -F'/' '{print ($2 == "" ? $1 : $2)}')
}

# Git-clone & Change Directory with Depth=1
function gcdd1() {
    gh repo clone $1 /home/$(whoami)/repos/$(echo "$1" | awk -F'/' '{print ($2 == "" ? $1 : $2)}') -- --depth 1
    cd /home/$(whoami)/repos/$(echo "$1" | awk -F'/' '{print ($2 == "" ? $1 : $2)}')
}

# Local Git Repository
function lgr() {
    mkdir /home/$(whoami)/repos/$1
    cd /home/$(whoami)/repos/$1
    git init
}

# Malino Project
function mp() {
    mkdir /home/$(whoami)/repos/$1
    cd /home/$(whoami)/repos/$1
    malino new $2
}

# CD's into a project directory & starts codium
function work() {
    cd /home/$(whoami)/repos/$1
    codium .
}

# Commits & pushes to remote repository, with message
function push() {
    git add .
    git commit -m "$1"
    git push
}

export PATH="$PATH:/usr/sbin:/sbin:/usr/bin/watcom/binl:/usr/local/go/bin:/home/$(whoami)/.bflat:/home/$(whoami)/.dotnet"
export WATCOM="/usr/bin/watcom"

export XDG_DATA_HOME="/home/$(whoami)/.local/share"

SBP_PATH=/home/$(whoami)/repos/sbp
source /home/$(whoami)/repos/sbp/sbp.bash

prompt_bottom
sbp set layout powerline

source ~/.local/share/blesh/ble.sh