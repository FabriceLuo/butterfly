#
# pypi-install.mk
# fabriceluo, 2022-01-19 15:20
#
#
.PHONY: all install

PIP ?= pip3


all: install finish


finish:
	echo "Finish install"


install:
	@echo "Install pypi package($(REPO))"
	env -u all_proxy -u http_proxy -u https_proxy $(PIP) install $(REPO)
	#bash -c "export -n all_proxy http_proxy https_proxy;$(PIP) install $(REPO)"


# vim:ft=make
#
