#! /bin/sh
#
# install.sh
# Copyright (C) 2018 mike <mike@luominghao>
#
# Distributed under terms of the MIT license.
#

WORK_DIR="$HOME"
CUR_DIR=`pwd`
USER_CUR_VIMRC="$WORK_DIR/.vimrc"
USER_CUR_VIMRC_BAK="$WORK_DIR/.vimrc.bak"
CUR_VIMRC="$CUR_DIR/config/vimrc"


if [ -f  "$USER_CUR_VIMRC" ]
then
	mv "$USER_CUR_VIMRC"  "$USER_CUR_VIMRC_BAK"
fi

cp "$CUR_VIMRC" "$USER_CUR_VIMRC"
