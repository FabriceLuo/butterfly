FROM base:1.0 as base_image

ENV dependence_build="/home/build"
ENV build_common=${dependence_build}/common
ENV build_modules=${dependence_build}/modules
ENV default_shell="/bin/bash"

ENV DEBIAN_FRONTEND noninteractive

LABEL "name"="develop-image"
LABEL "distribution"="debian9"
LABEL "description"="develop image for develop"
LABEL "version"="1.0"


RUN apt-get update
RUN apt-get -y install make

# 构建组件依赖
RUN mkdir ${dependence_build}
COPY --chown=root:root common ${build_common}
COPY --chown=root:root modules ${build_modules}
RUN env SHELL=${default_shell} BUILD_COMMON=${build_common} DEPENDENCE_INSTALL=${build_common}/install-apt-dependence.bash make -C ${build_modules}
