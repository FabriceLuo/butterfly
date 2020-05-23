#! /bin/bash
#
# debian.sh
# Copyright (C) 2020 luominghao <luominghao@live.com>
#
# Distributed under terms of the MIT license.
#

# Development environment vm manage utils.

vm_name=
op_command=

print_usage()
{
    cat << EOF
usage: ${0} [options]

options:
    -c status|create|export|start|stop|delete
    -n name
    -h
EOF
    return 0
}

get_vm_status()
{
    if [[ -z $vm_name ]]; then
        echo "vm name must assign"
        exit 1
    fi

    virsh list --all | grep "${vm_name}"

    return 0
}

start_vm()
{
    if [[ -z $vm_name ]]; then
        echo "vm name must assign"
        exit 1
    fi

    virsh start "${vm_name}"
    return $?
}

export_vm()
{
    return 0
}

if [[ -z "${VM_ROOT}" ]]; then
    echo "vm root is not initialized"
    exit 3
fi

if [[ $# -eq 0 ]]; then
    print_usage
    exit 2
fi

while getopts "c:n:" opt $@
do
    case $opt in
        c)
            op_command=$OPTARG
            ;;
        n)
            vm_name=$OPTARG
            ;;
        ?|*)
            print_usage
            exit 2
            ;;
    esac

done

case $op_command in
    status)
        get_vm_status
        ;;
    start)
        start_vm
        ;;
    export)
        ;;
    *)
        print_usage
        exit 2
esac

