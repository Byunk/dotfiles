#!/bin/zsh
#
# ZSH Configuration by Byunk
#

# zmodload zsh/zprof

hasCommand () {
  command -v $1 &> /dev/null
}

mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

### History

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt GLOBDOTS

### Key Bindings

# Enable history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Option + Arrow key to move cursor
bindkey '^[f' forward-word
bindkey '^[b' backward-word

## OS Specific Configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

### Completion

FUNC_DIR="$XDG_CONFIG_HOME/site-functions"
mkdir -p "$FUNC_DIR"
FPATH="$FUNC_DIR:$FPATH"
export FPATH="$ZDOTDIR/zfunctions:$FPATH"
autoload -Uz $ZDOTDIR/zfunctions/*(.:t)

# docker
if hasCommand docker && [[ ! -f "$FUNC_DIR/_docker" ]]; then
  docker completion zsh > "$FUNC_DIR/_docker"
fi

# kubectl
if hasCommand kubectl && [[ ! -f "$FUNC_DIR/_kubectl" ]]; then
  kubectl completion zsh > "$FUNC_DIR/_kubectl"
fi

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules --exclude .venv'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if hasCommand fzf && [[ ! -f "$FUNC_DIR/_fzf" ]]; then
  source <(fzf --zsh)
fi

# helm
if hasCommand helm && [[ ! -f "$FUNC_DIR/_helm" ]]; then
  helm completion zsh > "$FUNC_DIR/_helm"
fi

# kind
if hasCommand kind && [[ ! -f "$FUNC_DIR/_kind" ]]; then
  kind completion zsh > "$FUNC_DIR/_kind"
fi

autoload -Uz compinit; compinit

### Plugins

# Load antidote plugin manager
if [[ ! -d "$ZDOTDIR/.antidote" ]]; then
  git clone https://github.com/mattmc3/antidote "$ZDOTDIR/.antidote"
fi

source "$ZDOTDIR/.antidote/antidote.zsh"
antidote load

### Program specific configurations

# nvm
if [[ "$OSTYPE" == "darwin"* ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

# zellij
# eval "$(zellij setup --generate-auto-start zsh)"

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [ -e "$HOME/.localrc" ]
then
  source "$HOME/.localrc"
fi

### Prompt

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
# Hook before every commands
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
# Only displayed in Git action like rebase, merge, cherry-pick
zstyle ':vcs_info:git:*' actionformats '[%b | %a%u%c]'

PROMPT='%K{cyan}%F{magenta}%B%n%b%f%F{black}%B@%b%f%F{red}%B%m%b%f%k %F{magenta}%B%~%b%f %F{044}%B$vcs_info_msg_0_%b%f
%F{green}>%f '

# Theo's Custom Greeting Msg
function init() {
  # Getting the battery info
  batlv=-1
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -a /sys/class/power_supply/BAT0/capacity ]]; then
      batlv=$(cat /sys/class/power_supply/BAT0/capacity)
    elif [[ -a /sys/class/power_supply/BAT1/capacity ]]; then
      batlv=$(cat /sys/class/power_supply/BAT1/capacity)
    fi
  elif command -v pmset &> /dev/null; then
    batlv=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
  fi

  # Colors
  normal='\033[0m'

  red='\033[0;31m'
  brred='\033[1;31m'
  green='\033[0;32m'
  brgreen='\033[1;32m'
  yellow='\033[0;33m'
  bryellow='\033[1;33m'
  blue='\033[0;34m'
  brblue='\033[1;34m'
  magenta='\033[0;35m'
  brmagenta='\033[1;35m'
  cyan='\033[0;36m'
  brcyan='\033[1;36m'

  # Setting battery colors
  if [[ $batlv == 1 ]]; then
    batcolo="$red"
    batlv="Error in the battery "
  elif [[ $batlv -ge 80 ]]; then
    batcolo="$brcyan"
  elif [[ $batlv -gt 40 ]]; then
    batcolo="$green"
  else
    batcolo="$red"
  fi

  # Collection of Oliver ASCII arts
  olivers=(
    '
       \/   \/
       |\__/,|     _
     _.|o o  |_   ) )
    -(((---(((--------
    ' \
    '
       \/       \/
       /\_______/\
      /   o   o   \
     (  ==  ^  ==  )
      )           (
     (             )
     ( (  )   (  ) )
    (__(__)___(__)__)
    ' \
    '
                           _
          |\      _-``---,) )
    ZZZzz /,`.-```    -.   /
         |,4-  ) )-,_. ,\ (
        `---``(_/--`  `-`\_)
    ' \
    # Thanks Jonathan for the one below
    '
          \/ \/
          /\_/\ _______
         = o_o =  _ _  \     _
         (__^__)   __(  \.__) )
      (@)<_____>__(_____)____/
        ♡ ~~ ♡ OLIVER ♡ ~~ ♡
    ' \
    '
       \/   \/
       |\__/,|        _
       |_ _  |.-----.) )
       ( T   ))        )
      (((^_(((/___(((_/
    ' \
    '
    You found the only "fish" that Oliver could not eat!
           .
          ":"
        ___:____     |"\/"|
      ,`        `.    \  /
      |  O        \___/  |
    ~^~^~^~^~^~^~^~^~^~^~^~^~
    '
  )
  # 1. RANDOM is biased toward the lower index
  # 2. Array index in ZSH starts at 1
  oliver=${olivers[ $(( RANDOM % ${#olivers[@]} + 1 )) ]}

  # Other information
  my_hostname=$(hostname -s)
  timestamp="$(date -I) $(date +"%T")"
  uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

  # Greeting msg
  echo
  echo -e "  " "$brgreen" "Welcome back $USER!"                       "$normal"
  echo -e "  " "$brred"   "$oliver"                                   "$normal"
  echo -e "  " "$yellow"  " Zsh Open:\t"   "$bryellow$timestamp"     "$normal"
  echo -e "  " "$blue"    " Hostname:\t"   "$brmagenta$my_hostname"  "$normal"
  echo -e "  " "$magenta" " Uptime  :\t"   "$brblue$uptime"          "$normal"
  echo -e "  " "$cyan"    "󱈏 Battery :\t"   "$batcolo$batlv%"         "$normal"
  echo
}

init
# zprof
