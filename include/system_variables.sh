#!/usr/bin/env bash

SYSTEM_VARIABLES_SOURCED=1

#################### System ######################

# Distribute information
# - DISTRIB_ID
# - DISTRIB_RELEASE
# - DISTRIB_CODENAME
# - DISTRIB_DESCRIPTION
if [ -f /etc/lsb-release ]; then
  . /etc/lsb-release
fi

# Architecture information
OS_ARCHITECTURE=$(uname -m)
OS_KERNEL=$(uname -r)
OS_TYPE=$(uname -s)
