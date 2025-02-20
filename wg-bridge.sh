#!/bin/bash

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/utils.sh"


function usage(){
  echo "Usage: $(basename "$0") [OPTIONS] [COMMAND] <ARGUMENT>"
  echo ""
  echo "A tool to handle a Wireguard VPN"
  echo ""
  echo "Command"
  echo "  connect     [<arg>]  Connect to a specified resource (optional argument)"
  echo "  disconnect  [<arg>]  Disconnect from a specified resource (optional argument)"
  echo "  list                 List available resources"
  echo "  status               List active VPN"
  echo ""
  echo "Options:"
  echo "  -h, --help           Show this help message and exit"
  echo "  -v, --verbose        Enable verbose mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") connect /path/to/server1.conf"
  echo "  $(basename "$0") disconnect    # Disconnect without specifying a resource"
  exit 1
}


function connect(){
  local istoken=""
  local uri=""
  if [ "$1" != "" ]; then
    conf=$1
  else
    conf=$(list)
  fi
  if [ "$conf" != "" ]; then
    istoken=$(handle_token "$conf")
    sudo wg-quick up "$conf"
    if [ $istoken ]; then
      uri=$(get_uri "$conf")
      xdg-open "$uri" > /dev/null 2>&1 &
    fi
  fi
}

function disconnect(){
  if [ "$1" != "" ]; then
    conf=$1
  else
    conf=$(list)
  fi
  if [ "$conf" != "" ]; then
    wg-quick down "$conf"
  fi
}

function list(){
  choose=$(view_prompt "$(find_configs)")
  if [[ "$1" == "show" ]]; then
    exit 0
  fi
  echo $choose | cut -d "|" -f2
}

function status(){
  if [ "$VERBOSE" ]; then
    sudo wg show all
  else
    sudo wg show interfaces
  fi
}

###############################################################################
### MAIN
###############################################################################

if [ $# -eq 0 ]; then
  usage
  exit 2
fi

get_configuration

OPTIONS=vh
LONGOPTIONS=verbose,help
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")

if [ $? -ne 0 ]; then
  exit 2
fi

eval set -- "$PARSED"

while true; do
  case "$1" in
    -v|--verbose)
      export VERBOSE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 3
      ;;
  esac
done

case ${1} in
  connect)
    connect "$2" || exit 1
    ;;
  disconnect)
    disconnect "$2" || exit 1
    ;;
  list)
    list "show" || exit 1
    ;;
  status)
    status || exit 1
    ;;
  *)
    echo "unknown command $1"
    usage
    exit 3
    ;;
esac
