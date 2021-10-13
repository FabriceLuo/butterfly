#! /bin/bash
#
# apt-install-file.bash
# Copyright (C) 2020 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

DEPENDENCE_FILE=$1

if [[ -z $DEPENDENCE_FILE ]]; then
    echo "apt dependence file is not specifiled"
    exit 1
fi

if [[ ! -f "${DEPENDENCE_FILE}" ]]; then
    echo "apt dependence file(${DEPENDENCE_FILE}) is not found"
    exit 2
fi

export -n all_proxy http_proxy https_proxy
# 先更新下缓存
apt-get update

for dependence in $(cat "${DEPENDENCE_FILE}" | grep -v -E "^\s*#|^\s*$")
do
    apt-get -y install "${dependence}"
    if [[ $? -ne 0 ]]; then
        echo "install dependence(${dependence}) failed"
        exit 3
    fi
done

exit 0
