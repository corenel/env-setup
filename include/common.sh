#!/usr/bin/env bash

COMMON_SOURCED=1

status() {
  tput setaf 6
  echo $1
  tput sgr0
}

warning() {
  tput setaf 3
  echo $1
  tput sgr0
}

error() {
  tput setaf 1
  echo $1
  tput sgr0
}

# USAGE: confirm [func] [text]
# EXAMPLE: confirm say_ok "Are you OK?"
confirm() {
  prompt_func=$1
  prompt_text=${@:2}

  if confirmation ${prompt_text}; then
    ${prompt_func}
  fi
}

# USAGE: confirm [text]
# EXAMPLE: confirmation "Are you OK?"
confirmation() {
  display_text="> $@?[y/N]"
  while true; do
    tput setaf 4
    echo -n ${display_text}
    tput sgr0

    read -p " " yn

    case ${yn} in
    [Yy]*)
      return
      break
      ;;
    "") break ;;
    [Nn]*) break ;;
    *) warning "Please answer yes or no." ;;
    esac
  done
  false
}

# USAGE: prompt [variable] [text]
prompt() {
  display_text="> ${@:2}:"

  tput setaf 4
  echo -n ${display_text}
  tput sgr0

  read -p " " $1
}

# USAGE: prompt_default [variable name] [text]
prompt_default() {
  display_text="> ${@:2}:"

  tput setaf 4
  echo -n ${display_text}
  tput sgr0

  default_value=${!1}
  read -p " " $1
  if [[ "${!1}" == "" ]]; then
    read $1 <<<"${default_value}"
  fi
}
