#! /bin/sh
#
# snail.sh
# Copyright (C) 2019 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

SNAIL_ADDRESS=
SNAIL_PASSWORD=
SNAIL_USERNAME=
SNAIL_CONFIG_PATH=
SNAIL_CONFIG_CONTENT=

load_config() {
    SNAIL_CONFIG_CONTENT=$(cat "${SNAIL_CONFIG_PATH}")

    return $?
}

update_environment() {
    local name=$1
    local value=$2

    export "${name}"="${value}"

    return 0
}

append_environment() {
    local name=$1
    local value=$2

    # 不存在，直接更新；存在了已经包含，不再设置；否则进行追加
    if [[ -z "${!name}" ]]; then
        update_environment "${name}" "${value}"
        return $?
    fi

    # 检查是否已经包含
    if [[ "${!name}" =~ ;${value}; ]]; then
        return 0
    fi

    export "${name}"="${!name};${value}"

    return 0
}

init_environments() {
    local env_count=
    local env_index=0

    local env_type=
    local env_name=
    local env_value=

    env_count=$(echo "${SNAIL_CONFIG_CONTENT}" | jq ".environments | length")

    ## 没有环境变量需要初始化，直接返回
    #if [[ x"$env_count" == x"0" ]]; then
    #    return 0
    #fi
    while [[ $env_index < $env_count ]]; do
        env_type=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".environments[${env_index}].type" )
        env_name=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".environments[${env_index}].name" )
        env_value=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".environments[${env_index}].value" )

        if [[ $env_type == "append" ]]; then
            append_environment "${name}" "${value}"
        elif [[ $env_type == "update" ]]; then
            update_environment "${name}" "${value}"
        else
            :
        fi

        env_index=$(env_count + 1)
    done

    return 0
}

init_utils() {
    local util_count=
    local util_index=0

    local util_name=
    local util_des=
    local util_src=
    local util_perms=

    util_count=$(echo "${SNAIL_CONFIG_CONTENT}" | jq ".utils| length")

    while [[ $util_index < $util_count ]]; do
        util_des=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".utils[${util_index}].des" )
        util_src=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".utils[${util_index}].src" )

        util_name=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".utils[${util_index}].name" )
        util_perms=$(echo "${SNAIL_CONFIG_CONTENT}" | jq -r ".utils[${util_index}].permissions" )

        synchronize_utils "${util_name}" "${util_src}" "${util_des}" "${util_perms}"
        if [[ $? -ne 0 ]]; then
            echo "synchronize util(${util_name}) failed"
        fi
    done

    return 0
}

synchronize_utils() {
    local util_name=$1
    local util_des=$2
    local util_src=$3
    local util_perms=$4

    local util_src_path=$(get_src_file_path "${util_src}")
    local util_des_path=$(get_des_file_path "${util_des}")

    compare_file "${util_des_path}" "${util_src_path}"
    if [[ $? -eq 0 ]]; then
        echo "file(${util_name}) no need to synchronize"
        return 0
    fi

    copy_file "${util_src_path}" "${util_des_path}"
    if [[ $? -ne 0 ]]; then
        echo "copy util(${util_name}) from($util_src_path) to($util_des_path) failed"
        return 1
    fi

    change_permissions "${util_des_path}"
    if [[ $? -ne 0 ]]; then
        echo "change util(${util_name}) file(${util_des_path}) permission(${util_perms}) failed"
        return 1
    fi

    return 0
}

copy_file() {
    return 0
}

compare_file() {
    return 0
}

change_permissions() {
    return 0
}

get_src_file_path() {
    return 0
}

get_des_file_path() {
    return 0
}

exec_command_on_source() {
    return 0
}

main() {
    load_config
    if [[ $? -ne 0 ]]; then
        echo "load snail config failed"
        return 1
    fi

    init_environments

    init_utils

    return 0
}

main "$@"
