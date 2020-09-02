#
# Makefile
# luominghao, 2020-09-02 08:23
#
#

dependence:
	@echo "build vim dependence"
	bash $(DEPENDENCE_INSTALL) ./dependence.conf

vim:
	@echo "build vim source"
	make -C src all

vim: export PRIVATE_REPO_URL = http://192.168.2.1:81

.PHONY: dependence vim

all: dependence vim

# vim:ft=make
#
