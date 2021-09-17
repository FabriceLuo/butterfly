#
# download-install.mk
# fabriceluo, 2021-09-17 22:18
#
#
REPO            ?=

PATH_USER       ?= fabrice
PREFIX_DIR      ?= /opt
DOWNLOAD_URL    ?=
DOWNLOAD_ROOT   ?= ./download
DOWNLOAD_NAME   ?= $(REPO)
DOWNLOAD_FILE    = $(DOWNLOAD_ROOT)/$(DOWNLOAD_NAME)
BINARY_RELATIVE ?= bin
INSTALL_ROOT    ?= $(PREFIX_DIR)/$(REPO)

.PHONY: download install

download:
	mkdir -p "$(DOWNLOAD_ROOT)"
	curl -L -s "$(DOWNLOAD_URL)" -o "$(DOWNLOAD_FILE)" 

install:
	mkdir -p "$(INSTALL_ROOT)"
	tar -xf "$(DOWNLOAD_FILE)" --strip-components 1 -C "$(INSTALL_ROOT)"
	echo "export PATH=$(INSTALL_ROOT)/$(BINARY_RELATIVE):$$PATH" >> /home/$(PATH_USER)/.bashrc

all: download install
	@echo "download-install.mk $(REPO) success"


# vim:ft=make
#
