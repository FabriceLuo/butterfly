#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2022 fabriceluo <fabriceluo@outlook.com>
#
# Distributed under terms of the MIT license.

"""
生成v2ray的配置文件
"""
import requests
import yaml
import json
import sys

template_config_file='./v2ray.template'
config_file='./v2ray.json'
default_url = 'https://sub.fnff.one/link/GFeitcgtM1XfHz8B?clash=1'

fnf_url = default_url
if len(sys.argv)> 1:
    fnf_url = sys.argv[1]

def get_vmess_oco_template():
    return {
        "vnext": [
            {
                "address": "127.0.0.1",
                "port": 37192,
                "users": [
                    {
                        "id": "27848739-7e62-4138-9fd3-098a63964b6b",
                        "alterId": 4,
                        "security": "auto",
                        "level": 0

                    }

                ]

            }

        ]

    }

def get_vmess_outbound_template():
    return {
        "tag": "v2ray-out",
        "protocol": "vmess",
        "settings": {},
        "streamSettings": {
            "network": "tcp",
            "security": "auto",
            "tlsSettings": None,
            "tcpSettings": {},
            "kcpSettings": None,
            "wsSettings": None,
            "httpSettings": None,
            "quicSettings": None

        },
        "mux": {
            "enabled": True,
            "concurrency": 8
        }
    }

def get_fnf_proxies():
    rsp = requests.get(fnf_url)
    rsp.raise_for_status()

    data = yaml.load(rsp.text, Loader=yaml.Loader)
    return data['proxies']

def get_proxies_by_types(proxies, types=['vmess']):
    return [p for p in proxies if p.get('type', None) in types]

def get_proxies():
    proxies = get_fnf_proxies()

    return get_proxies_by_types(proxies)

def get_vmess_oco(proxy):
    """
    根据proxy配置生成OutboundConfigurationObject
    """
    oco = get_vmess_oco_template()

    server_obj = oco['vnext'][0]
    server_obj['address'] = proxy['server']
    server_obj['port'] = proxy['port']

    user_obj = server_obj['users'][0]
    user_obj['id'] = proxy['uuid']
    user_obj['alterId'] = proxy['alterId']
    user_obj['security'] = proxy['cipher']
    user_obj['level'] = 0

    return oco

def gen_outbound(proxy):
    outbound = get_vmess_outbound_template()
    oco = get_vmess_oco(proxy)

    outbound['tag'] = 'out' + '-' + proxy['server']
    outbound['settings'] = oco

    return outbound

def gen_outbounds(proxies):
    return [gen_outbound(p) for p in proxies]

def refresh_outbounds_in_config(outbounds):
    with open(template_config_file, 'r') as fp:
        template = json.load(fp)

    template['outbounds'].extend(outbounds)

    with open(config_file, 'w+') as fp:
        json.dump(template, fp, indent=4)

def main():
    proxies = get_proxies();

    outbounds = gen_outbounds(proxies)

    refresh_outbounds_in_config(outbounds)

if __name__ == "__main__":
    main()
