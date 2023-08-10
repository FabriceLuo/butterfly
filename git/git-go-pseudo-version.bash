#! /bin/bash
#
# git-go-pseudo-version.bash
# Copyright (C) 2022 fabriceluo <fabriceluo@outlook.com>
#
# Distributed under terms of the MIT license.
#

commit_id=$1

if [[ -z $commit_id ]]; then
    echo "usage: $0 commit_id"
    exit 1
fi

TZ=UTC git --no-pager show   --quiet   --abbrev=12 --date='format-local:%Y%m%d%H%M%S'   --format="%cd-%h" "${commit_id}"
