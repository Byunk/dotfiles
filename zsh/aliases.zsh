# environmental alias
alias pip='pip3'
alias python='python3'
alias vim='nvim'
alias vi='nvim'
alias k='kubectl'

export NVM_DIR="$HOME/.nvm"
if [[ "${OSTYPE}" != "darwin"* ]]; then
	[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
	[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

# shell
bindkey "^[^[[D" forward-word
bindkey "^[C" backward-word

# custom commands
alias l='ls -A -l -h --color=auto' # All file except . and .., list view, display unit suffix for the size
alias cl='clear'
alias gs="git status"
alias ga="git add"
alias vf="vi \$(fzf)" 

alias dot="cd \"$DOT_DIR\""

# custom functions
mkcd() { mkdir -p $1; cd $1 }
