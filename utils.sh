#!/bin/bash

export CYAN="\e[36m"
export YELLOW="\e[33m"
export RED="\e[31m"
export NC="\e[0m"

export user_home=$HOME
export wgbconf="$user_home/.wgbconf.json"
export DIRS=("/etc/wireguard")
export token=false
export token_uri=""


function log_error(){
  echo -e "$RED$1$NC"
}
function log_warn(){
  echo -e "$YELLOW$1$NC"
}
function log_info(){
  echo -e "$CYAN$1$NC"
}

function get_error_msg(){
  errors="$(jq -r '.error_codes' "$wgbconf")"

  echo $errors | jq -r "$1"
}

function get_configuration(){
  if [ -f "$wgbconf" ]; then
    while IFS= read -r item; do
      DIRS+=("$item")
    done < <(jq -r '.conf_path[]' "$wgbconf")
    token=$(jq -r '.token' "$wgbconf")
    token_uri=$(jq -r '.token_uri' "$wgbconf")
  else
    log_error "{000} Something goes wrong. Reinstall the tool."
    exit 1
  fi
}

function view_prompt(){
  local paths=()
  local names=()

  for i in $@; do
    paths+=("$i")
    names+=("$(basename "$i")")
  done

  yad --list --title="Select a Wireguard configuration" \
        --column="Name" --column="Path" --width=500 --height=400 --multiple $(for i in "${!paths[@]}"; do echo -e "${names[$i]}"; echo -e "${paths[$i]}"; done)
}

function find_configs(){
  sudo find "${DIRS[@]}" -type f -name "*.conf" 2>/dev/null
}
