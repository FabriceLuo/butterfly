#! /bin/bash
#
# develop.bash
# Copyright (C) 2020 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

IMAGE_NAME="develop:3.0"
CONTAINER_NAME="debian10-develop"
WORK_DIR=/home/work
LOCAL_VOLUME=/home/mike/code
REMOTE_VOLUME=/home/work
USER=mike

function start()
{
    echo "begin to start container:${CONTAINER_NAME}"
    docker start "${CONTAINER_NAME}"
    echo "start container success"
}

function stop()
{
    return 0
}

function delete()
{
    echo "begin to delete container:${CONTAINER_NAME}"
    docker container rm -f "${CONTAINER_NAME}"
    echo "delete container success"
}

function create()
{
    echo "begin to create container:${CONTAINER_NAME}"
    docker create -u "${USER}" --workdir "${WORK_DIR}" -v "${LOCAL_VOLUME}":"${REMOTE_VOLUME}" --hostname debian10 -i -t --name "${CONTAINER_NAME}" "${IMAGE_NAME}"
    echo "create container success"
}

function status()
{
    return 0
}

function is_running()
{
    return 1
}

function attach()
{
    echo "begin to attach container:${CONTAINER_NAME}"
    docker attach "${CONTAINER_NAME}"
}

function enter()
{
    is_running
    if [[ $? -ne 0 ]]; then
        delete
        create
        start
    fi

    attach
}

case $1 in
    status )
        ;;
    start )
        ;;
    stop )
        ;;
    * )
        enter
        ;;
esac
