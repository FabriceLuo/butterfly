#! /bin/bash
#
# prepare.bash
# Copyright (C) 2020 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

rm -rf ./modules/vim/src
if [[ $? -ne 0 ]]; then
    echo "clean source dir failed"
    exit 1
fi

cp -rf ../../../vim modules/vim/src
if [[ $? -ne 0 ]]; then
    echo "copy vim source failed"
    exit 2
fi

exit 0
