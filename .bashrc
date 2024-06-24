# Just a thing for ls
alias la='exa --icons --git -a --color=auto'
alias ls='exa --icons --git --color=auto'
alias l='ls'

#grepp
alias grep='grep --color=auto'

# Useful aliases
alias cls='clear'
alias more='cat'
alias cd..='cd ..'
alias ni='sudo nala install'
alias nr='sudo nala remove'
alias nu='sudo nala update'
alias nar='sudo nala autoremove'
alias ninr='sudo nala install --no-install-recommends'

export PATH="$PATH:/usr/sbin:/sbin:/usr/bin/watcom/binl"
export WATCOM="/usr/bin/watcom"

SBP_PATH=/home/winksplorer/repos/sbp
source /home/winksplorer/repos/sbp/sbp.bash

sbp set layout powerline

source ~/.local/share/blesh/ble.sh
export PATH="$PATH:/home/winksplorer/.dotnet"
