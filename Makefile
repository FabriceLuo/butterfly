#
# Makefile
# luominghao, 2020-05-23 02:48
#

subdirs = vim

.PHONY: $(subdirs)

all: $(subdirs)
all_from_repo: $(subdirs)

all_from_repo: export PRIVATE_REPO_URL = http://192.168.2.1:81

$(subdirs):
	$(MAKE) -C $@ all

# vim:ft=make
#
