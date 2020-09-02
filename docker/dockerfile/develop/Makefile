#
# Makefile
# luominghao, 2020-07-19 04:30
#
image_version=1.0
image_name=develop

.PHONY: prepare build

prepare:
	@echo "prepare docker build environment"
	bash ./prepare.bash

build:
	@echo "begin docker build"
	docker build -t $(image_name):$(image_version) ./
	@echo "end docker build"

all: prepare build

# vim:ft=make
#
