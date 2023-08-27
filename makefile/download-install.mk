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

TAR_STRIP_COMPONENTS ?= 1

.PHONY: download install

download:
	mkdir -p "$(DOWNLOAD_ROOT)"
	curl -L -s "$(DOWNLOAD_URL)" -o "$(DOWNLOAD_FILE)" 

install:
	mkdir -p "$(INSTALL_ROOT)"
	tar -xf "$(DOWNLOAD_FILE)" --strip-components $(TAR_STRIP_COMPONENTS) -C "$(INSTALL_ROOT)"
	echo "export PATH=$(INSTALL_ROOT)/$(BINARY_RELATIVE):\$$PATH" >> $(PATHRC)

all: download install
	@echo "download-install.mk $(REPO) success"


# vim:ft=make
#
