#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then

  source include/system_variables.sh
fi

system_status() {
  status "(*) System:"
  echo "    - User: $USER"
  echo "    - Hostname: $HOSTNAME"
  if [ $DISTRIB_DESCRIPTION -e "" ]; then
    echo "    - OS: $DISTRIB_DESCRIPTION - $DISTRIB_CODENAME"
  else
    echo "    - OS: $OS_TYPE"
  fi
  echo "    - Architecture: $OS_ARCHITECTURE"
  echo "    - Kernel: $OS_KERNEL"
}

system_status
