#! /bin/bash
#
# apt-install-dir.bash
# Copyright (C) 2021 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

config_dir=$1

if [[ -z $config_dir ]]; then
    echo "config dir is null."
    exit 1
fi

if [[ -d "${config_dir}" ]]; then
    echo "${config_dir} is not a dir or not exist."
    exit 2
fi

for config_file in $config_dir/*; do
    if ! apt-install-file.bash "${config_file}";then
        echo "apt install config(${config_file}) failed"
        exit 3
    fi
done

exit 0
