#! /bin/bash
#
# autosvn.sh
# Copyright (C) 2019 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#
# 在subversion中自动化代码format、check、review、commit等功能

SVN_BIN_PATH="/"

SVN_DIR="${PWD}"
SVN_URL=

REVIEW_USERNAME=
REVIEW_PASSWORD=
REVIEW_REPO=

create_review() {
    return 0
}

update_review() {
    return 0
}

close_review() {
    return 0
}

list_reviews() {
    return 0
}

get_review() {
    return 0
}

create_repo() {
    return 0
}

update_repo() {
    return 0
}

delete_repo() {
    return 0
}

get_repo() {
    return 0
}

list_repos() {
    return 0
}

commit() {
    return 0
}


get_dir_svn_repo() {
    local svn_dir=$1
    local svn_url=

    if [[  ! -d "${svn_dir}" ]]; then
        echo "code dir(${svn_dir}) not found"
        return 1
    fi

    svn_url=$($SVN_BIN_PATH info "${svn_dir}")
    if [[ $? -ne 0 ]]; then
        echo "dir(${svn_dir}) code repo url not found"
        return 1
    fi

    echo "$svn_url"
    return 0
}

load_review_repo() {
    return 0
}

input_review_repo() {
    return 0
}

cmd_create_review() {
    # 获取代码的repo信息
    local review_repo=

    review_repo=$(get_dir_svn_repo "${PWD}")
    if [[ $? -ne 0 ]]; then
        echo "get dir(${PWD}) svn repo failed"
        return 1
    fi

    # 查看repo对应的review配置，不存在时由用户配置
    load_review_repo
    if [[ $? -ne 0 ]]; then
        # 由用户输入信息，必须正确
        input_review_repo
    fi

    # 生成review使用的diff文件

    # 生成reivew请求模板文件

    # 用户编辑review信息

    # 生成review请求参数

    # 提交review请求

    # 输出review请求信息

    return 0
}

main() {
    local cmd=$1

    case $cmd in
        create_review )
            cmd_create_review "${@:1}"
            ;;
    esac

    return 0
}

main "$@"
