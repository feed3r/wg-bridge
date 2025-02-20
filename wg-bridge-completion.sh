#!/bin/bash

# Autocomplete for the Wireguard VPN connect/disconnect script
user_home=$HOME
wgbconf="$user_home/.wgbconf.json"
DIRS=("/etc/wireguard")

get_configuration(){
  while IFS= read -r item; do
    DIRS+=("$item")
  done < <(jq -r '.conf_path[]' "$wgbconf")
}

find_configs(){
  get_configuration
  sudo find "${DIRS[@]}" -type f -name "*.conf" 2>/dev/null
}

_wgb_autocomplete() {
 local cur prev opts confs flags
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Define available commands
    opts="connect disconnect list status"

    # Define available options
    flags="-v --version -h --help"

    # Define available configurations (modify the path if needed)
    confs=$(find_configs)

    if [[ $COMP_CWORD -eq 1 ]]; then
        # Suggest commands and global options at first position
        mapfile -t COMPREPLY < <(compgen -W "$opts $flags" -- "$cur")
        # COMPREPLY=( $(compgen -W "$opts $flags" -- "$cur") )
    elif [[ "$prev" == "connect" || "$prev" == "disconnect" ]]; then
        # Suggest config files for connect/disconnect
        mapfile -t COMPREPLY < <(compgen -W "$confs" -- "$cur")
        # COMPREPLY=( $(compgen -W "$confs" -- "$cur") )
    fi
}

# Register the autocomplete function
complete -F _wgb_autocomplete wgb
