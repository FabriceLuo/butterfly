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
	$(PIP) install $(REPO)


# vim:ft=make
#
