#
# Makefile
# luominghao, 2020-09-05 02:12
#
#

subdirs = docker dockerd

develop:
	install -D -m 0755 develop.bash /opt/bin

$(subdirs):
	$(MAKE) -C $@ all

.PHONY: docker dockerd develop

all: docker dockerd develop
	@echo "install docker config to system success"


# vim:ft=make
#
