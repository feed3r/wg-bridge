#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

user_home=$HOME
conf=".wgbconf.json"
wgbconf="$user_home/$conf"
tool_dir=/opt/wg-bridge
cmd=/usr/bin/wgb

function usage(){
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help       Show this help message and exit"
  # echo "  -v, --verbose              Enable verbose mode"
  echo "  -i, --install    Install WG-Bridge software"
  echo "  -u, --uninstall  Uninstall WG-Bridge software"
  echo ""
  exit 1
}

function install_dep(){
  sudo apt update -qq
  sudo apt install -qq -y wireguard yad jq
}

function install(){
  log_info "Installing dependency . . ."
  install_dep

  log_info "Installing wg-bridge . . ."
  if [ ! -d "$tool_dir" ]; then
    sudo mkdir $tool_dir
  fi
  sudo cp ./wg-bridge.sh ./utils.sh $tool_dir
  sudo chmod 755 $tool_dir/*
  if [ ! -f $cmd ]; then
    sudo ln -s $tool_dir/wg-bridge.sh $cmd
  fi

  log_info "Installing configuration . . ."

  if [ ! -f "$wgbconf" ]; then
    log_warn "Enter the path to configuration files (or empty line to finish)"
    while true; do
      # Get the directory path from the user
      read -rp "Path: " dir

      # If the user pressed Enter without typing anything, stop the loop
      if [[ -z "$dir" ]]; then
        break
      fi

      # Append the directory path to the string, separated by a comma
      if [[ -z "$directories" ]]; then
        directories="\"$dir\""
      else
        directories="$directories,\"$dir\""
      fi
    done
    jq --argjson paths "$directories" '.conf_path += [$paths]' $conf > $wgbconf
    handle_token
  else
    mv "$wgbconf" "$wgbconf.bak"
    jq --slurpfile customer "$wgbconf.bak" '.conf_path |= (. + $customer[0].conf_path)' "$conf" > "$wgbconf"
    handle_token
  fi

  sudo chown $USER:$USER "$wgbconf"
  sudo chmod 644 "$wgbconf"

  sudo cp "wg-bridge-completion.sh" "/etc/bash_completion.d/"
  sudo chmod 755 "/etc/bash_completion.d/wg-bridge-completion.sh"

  log_info "Done"
}

function handle_token(){
  read -rp "Is it necessary to enter a token to connect? [y/N] " token
  case "${token,,}" in
    "y"|"yes")
      read -rp "Insert URI of 2FA " uri
      sudo jq --argjson value "true" '.token = $value' "$wgbconf" | sudo tee "$wgbconf.tmp" > /dev/null
      sudo jq --arg value "$uri" '.token_uri = $value' "$wgbconf.tmp" | sudo tee "$wgbconf.tmp2" > /dev/null
      sudo mv "$wgbconf.tmp2" "$wgbconf"
      sudo rm "$wgbconf.tmp"
    ;;
    *)
    ;;
  esac
}

if [ $# == 0 ]; then
  usage
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--install)
      install || exit 1
      ;;
    -u|--uninstall)
      uninstall || exit 1
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done
