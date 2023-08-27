#
# Makefile
# FabriceLuo, 2021-04-28 16:01
#
#

OWNER            ?=
REPO             ?=
REPO_TYPE 	     ?= latest_release	

PATH_USER        ?= fabrice
BINARY_RELATIVE  ?= bin

BUTTERFLY_DIR    ?= ./butterfly

DOWNLOAD_ROOT    ?= ./download
COMPILE_ROOT     ?= ./compile

COMPILE_NAME     ?= $(REPO)
DOWNLOAD_NAME    ?= $(REPO).tar.gz
PREFIX_DIR       ?= /opt/$(REPO)
CONFIGURE_PARAMS ?=

DOWNLOAD_FILE = $(DOWNLOAD_ROOT)/$(DOWNLOAD_NAME)
COMPILE_DIR   = $(COMPILE_ROOT)/$(COMPILE_NAME)

.PHONY: prepare dependence download decompress configure compile install all

prepare:
	@echo "prepare before make."

dependence:
	! test -f ./dependences.txt || bash $(BUTTERFLY_DIR)/shell/utils/apt-install-file.bash ./dependences.txt

download:
	mkdir -p $(DOWNLOAD_ROOT)
	bash $(BUTTERFLY_DIR)/git/utils/download_github.bash $(REPO_TYPE) $(OWNER) $(REPO) "$(DOWNLOAD_FILE)"

decompress:
	rm -rf $(COMPILE_DIR)
	mkdir -p $(COMPILE_DIR)
	tar -xzf $(DOWNLOAD_FILE) -C $(COMPILE_DIR) --strip-components 1

configure:
	cd $(COMPILE_DIR) && ./configure --prefix=$(PREFIX_DIR) $(CONFIGURE_PARAMS)

compile:
	cd $(COMPILE_DIR) && make

install:
	cd $(COMPILE_DIR) && make install
	echo "export PATH=$(PREFIX_DIR)/$(BINARY_RELATIVE):\$$PATH" >> $(PATHRC)

finish:
	@echo "finish after make."

all: prepare dependence download decompress configure compile install finish
	@echo "Compile and install $(OWNER)/$(REPO) successed."

# vim:ft=make
#
