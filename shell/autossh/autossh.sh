#! /bin/sh
#
# autossh.sh
# Copyright (C) 2019 mike <mike@luominghao>
#
# Distributed under terms of the MIT license.
#

USER_PASSWORD=""
USER_NAME="root"
USER_HOST=""

PASSWORD_PROVIDER=""
PASSWORD_PROVIDER_USER="user"
PASSWORD_PROVIDER_DB="db"
PASSWORD_PROVIDER_AUTO="auto"
PASSWORD_PROVIDER_PUBKEY="public_key"

HOST_RECORD_EXIST=1
HOST_RECORD_ERROR=0
HOST_RECORD_INDEX=-1
HOST_RECORD_CONFIG="/etc/autossh/autossh_db.conf"
HOST_RECORD_CONFIG_TEMP="${HOST_RECORD_CONFIG}.temp"

PASSWORD_SUFFIX="sangfornetwork"
PASSWORD_APPEND_SUFFIX=1

help() {
	echo "${0} parameters error:"
	exit 1
}

init_db_config() {
	test -e $HOST_RECORD_CONFIG && return 0
	local config_dir=$(dirname $HOST_RECORD_CONFIG)
	if [[ $? -ne 0 ]]; then
		echo "Get host database config failed"
		return 1
	fi

	mkdir -p "$config_dir"
	if [[ $? -ne 0 ]]; then
		echo "Create config dir failed"
		return 1
	fi
	cat << EOF > "$HOST_RECORD_CONFIG"
{
	"PartPasswds": [
	],
	"NodeRecords": [
	]
}
EOF
	return $?
}

get_password_from_db() {
	# 数据库中不存在，不再查询直接返回
	if [[ $HOST_RECORD_EXIST -eq 0 || $HOST_RECORD_ERROR -eq 1 ]]; then
		return 1
	fi

	# 先查找主机IP，再对比用户名
	# 获取记录数量
	local record_count=$(jq '.NodeRecords|length' "$HOST_RECORD_CONFIG")
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	if [[ $record_count -eq 0 ]]; then
		HOST_RECORD_EXIST=0
		return 1
	fi

	local t_hostip=""
	local t_username=""
	local t_password=""

	# 遍历每一个主机记录，查找匹配的记录
	for i in `seq 0 $((record_count -1))`
	do
		t_hostip=$(jq ".NodeRecords | .[$i].ip" "$HOST_RECORD_CONFIG" | sed 's/"//g')
		t_username=$(jq ".NodeRecords | .[$i].username" "$HOST_RECORD_CONFIG" | sed 's/"//g')
		if [[ $t_hostip == $USER_HOST && $t_username == $USER_NAME ]]; then
			HOST_RECORD_EXIST=1
			HOST_RECORD_INDEX=$i

			t_password=$(jq ".NodeRecords | .[$i].password" "$HOST_RECORD_CONFIG" | sed 's/"//g')
			if [[ $? -ne 0 ]]; then
				return 1
			fi
			USER_PASSWORD=$t_password
			return 0
		fi
	done

	HOST_RECORD_EXIST=0
	return 1
}

create_password_db_record() {
	# 在最后增加记录
	jq ".NodeRecords |= . + [{\"username\": \"$USER_NAME\", \"password\": \"$USER_PASSWORD\", \"ip\": \"$USER_HOST\"}]" "$HOST_RECORD_CONFIG" > "$HOST_RECORD_CONFIG_TEMP" && mv -f "$HOST_RECORD_CONFIG_TEMP" "$HOST_RECORD_CONFIG"
	return $?
}

update_password_db_record() {
	# 获取索引，更新索引对应的值
	# fixme：目前只会更新和插入记录，所以索引不会变，直接更新
	jq ".NodeRecords[$i].password |= \"$USER_PASSWORD\"" "$HOST_RECORD_CONFIG" > "$HOST_RECORD_CONFIG_TEMP" && mv -f "$HOST_RECORD_CONFIG_TEMP" "$HOST_RECORD_CONFIG"
	return $?
}

set_password_to_db() {
	# fixme add lock
	# 如果数据库中索引存在，更新，否则创建
	if [[ $HOST_RECORD_EXIST -eq 1 ]]; then
		update_password_db_record
	else
		create_password_db_record
	fi
}

get_password_from_user() {
	echo "Please input password for host(${USER_HOST}) of user(${USER_NAME})"
	echo -n "Password:"
	read -se USER_PASSWORD
	return 0
}

get_password() {
	# 从数据库中获取失败，需要手动输入
	get_password_from_db
	if [[ $? -eq 0 ]]; then
		PASSWORD_PROVIDER=$PASSWORD_PROVIDER_DB
		return 0
	fi

	# 从用户输入
	get_password_from_user
	if [[ $? -eq 0 ]]; then
		PASSWORD_PROVIDER=$PASSWORD_PROVIDER_USER
		if [[ $PASSWORD_APPEND_SUFFIX -eq 1 ]]; then
			USER_PASSWORD="${USER_PASSWORD}${PASSWORD_SUFFIX}"
		fi
		return 0
	fi
	return 1
}


login_with_password() {
	sshpass -p "$USER_PASSWORD" ssh $USER_NAME@$USER_HOST
	return $?
}

login_with_public_key() {
	sshpass ssh $USER_NAME@$USER_HOST
}

auto_login() {
	# 不断获取密码，重试登录
	while true; do
		if [[ -n $USER_PASSWORD ]]; then
			PASSWORD_PROVIDER=$PASSWORD_PROVIDER_USER
		else
			get_password
		fi

		login_with_password
		local errcode=$?
		if [[ $errcode -eq 0 ]]; then
			# 成功退出后，更新密码至数据库中
			# 密码来自数据库，说明已经存在，不需要更新
			if [[ $PASSWORD_PROVIDER != $PASSWORD_PROVIDER_DB ]]; then
				set_password_to_db
			fi
			break
		else
			# 密码错误时，清理掉用户的密码，重新获取密码
			USER_PASSWORD=""
		fi

		if [[ $errcode -eq 5 && $PASSWORD_PROVIDER == $PASSWORD_PROVIDER_DB ]]; then
			HOST_RECORD_ERROR=1
		fi
	done
}

main() {
	local optstring=":p:u:h:c:d"
	OPTIND=0
	while getopts $optstring opt $@; do
		case $opt in
			'd')
				PASSWORD_APPEND_SUFFIX=0
				;;
			'p')
				USER_PASSWORD="$OPTARG"
				;;
			'u')
				USER_NAME="$OPTARG"
				;;
			'h')
				USER_HOST="$OPTARG"
				;;
			'c')
				HOST_RECORD_CONFIG="$OPTARG"
				HOST_RECORD_CONFIG_TEMP="${HOST_RECORD_CONFIG}.temp"
				;;
			':')
				;;
			'?')
				help
				;;
		esac
	done

	# 传入了密码，同时需要增加后缀
	if [[ $PASSWORD_APPEND_SUFFIX -eq 1 && -n $USER_PASSWORD ]]; then
		USER_PASSWORD="${USER_PASSWORD}${PASSWORD_SUFFIX}"
	fi
	init_db_config || exit 1
	auto_login
	return $?
}

main $@;
