#! /bin/bash
#
# download_github.bash
# Copyright (C) 2021 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

download_type=$1

OWNER=$2
REPO=$3
DES_FILE=$4

test -z "${OWNER}" && echo "github repo owner is NULL." && exit 2
test -z "${REPO}" && echo "github repo name is NULL." && exit 3

function download_file() {
    local url=$1

    if [[ -z "${DES_FILE}" ]]; then
        curl -O -L -s "${url}"
    else
        curl -o "${DES_FILE}" -L -s "${url}"
    fi
}

function get_latest_release() {
    local query_url="https://api.github.com/repos/${OWNER}/${REPO}/releases/latest"
    curl -s -H "Accept: application/vnd.github.v3+json" "${query_url}"
}

function get_latest_release_tarball() {
    local release=
    local tarball=
    if ! release=$(get_latest_release);then
        echo "get latest release failed"
        return 1
    fi

    if ! tarball=$(echo "${release}" | jq -r '.assets[0].browser_download_url');then
        echo "get release download tarball failed"
        return 1
    fi

    test -z "${tarball}" && echo "release tarball url error" && return 1

    echo "${tarball}"
}

function download_lastest_release() {
    local tarball=

    if ! tarball=$(get_latest_release_tarball);then
        echo "get latest release tarball url failed"
        return 1
    fi

    if ! download_file "${tarball}";then
        echo "download release tarball file failed"
        return 1
    fi

    return 0
}

function get_latest_tag() {
    local query_url="https://api.github.com/repos/${OWNER}/${REPO}/tags"
    local tags=
    local latest_tag=

    if ! tags=$(curl -s -H "Accept: application/vnd.github.v3+json" "${query_url}");then
        echo "get tags list failed"
        return 1
    fi

    echo "${tags}" | jq '.[0]'
}

function get_latest_tag_tarball() {
    local latest_tag=
    local tarball=

    if ! latest_tag=$(get_latest_tag);then
        echo "get latest tag failed"
        return 1
    fi

    if ! tarball=$(echo "${latest_tag}" | jq -r '.tarball_url');then
        echo "get latest tag tarball failed"
        return 1
    fi

    test -z "${tarball}" && echo "tag tarball url error" && return 1

    echo "${tarball}"
}

function download_lastest_tag() {
    local tarball=

    if ! tarball=$(get_latest_tag_tarball);then
        echo "get latest tag tarball url failed"
        return 1
    fi

    if ! download_file "${tarball}";then
        echo "download tag tarball file failed"
        return 1
    fi

    return 0
}

function print_usage() {
    echo "$0 latest_release|latest_tag owner repo."
    exit 1
}

case $download_type in
    latest_release)
        download_lastest_release
        ;;
    latest_tag)
        download_lastest_tag
        ;;
    *)
        print_usage
        ;;
esac
