FROM debian:9 as base_image

ARG pkg_install="apt-get -y install"

ENV DEBIAN_FRONTEND noninteractive

LABEL "name"="base-image"
LABEL "distribution"="debian9"
LABEL "description"="common base image for develop"
LABEL "version"="1.0"

USER root:root
SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["/usr/bin/env", "LANG=en_US.UTF-8"]

# 配置默认的启动命令
CMD ["/bin/bash", "-i"]

# 使用优化后的apt源配置，加速安装速度
COPY --chown=root:root ["sources.list", "/etc/apt/sources.list"]
RUN apt-get update

RUN ${pkg_install} apt-utils

# 配置locales为en_US.UTF-8
RUN ${pkg_install} dialog locales
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN useradd -m -U mike

# 安装vim
RUN ${pkg_install} build-essential
RUN ${pkg_install} git
