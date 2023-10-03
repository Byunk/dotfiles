# environmental alias
alias pip='pip3'
alias python='python3'
alias vim='nvim'
alias vi='nvim'
alias k='kubectl'
alias g++='g++ -std=c++17'
alias t='todo.sh'

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# shell
bindkey "^[^[[D" forward-word
bindkey "^[C" backward-word

# custom commands
alias l='ls -A -l -h --color=auto' # All file except . and .., list view, display unit suffix for the size
alias cl='clear'
alias weather="curl 'https://wttr.in'"

alias dot="cd \"$DOT_DIR\""

# custom functions
mkcd() { mkdir -p $1; cd $1 }
