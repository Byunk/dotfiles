## Git

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

# Prompt
PROMPT='%K{cyan}%F{magenta}%B%n%b%f%F{black}%B@%b%f%F{red}%B%m%b%f%k %F{magenta}%B%~%b%f %F{044}%B$vcs_info_msg_0_%b%f
%F{green}>%f '
