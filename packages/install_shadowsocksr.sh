#!/usr/bin/env bash

PACKAGE=shadowsocksr
BRANCH=manyuser
URL=https://github.com/shadowsocksr-backup/shadowsocksr
DST=$HOME/Downloads/Github

if [[ -d $DST ]]; then
    mkdir -p $DST
fi

cd $DST
git clone $URL -b $BRANCH


