#!/bin/zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffc0cb,bold,underline"

##### Make sure "PLUGIN_DIR" env var is set (mine is in .zshrc) #####

# Double check double check
function source_file() {
  [ -f ${PLUGIN_DIR}/$1 ] && source ${PLUGIN_DIR}/$1
}

# Function to source or load a plugin
function plug() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [[ -d ${PLUGIN_DIR}/${PLUGIN_NAME} ]]; then
    source_file ${PLUGIN_NAME}/${PLUGIN_NAME}.plugin.zsh || \
    source_file ${PLUGIN_NAME}/${PLUGIN_NAME}.zsh
  else
    git clone "https://github.com/${1}.git" ${PLUGIN_DIR}/${PLUGIN_NAME}
  fi
}

function upgrade() {
  for repo in ${PLUGIN_DIR}/*
  do
    echo "refreshing ${repo}:"
    cd ${repo} && git pull && cd - > /dev/null
  done
}
