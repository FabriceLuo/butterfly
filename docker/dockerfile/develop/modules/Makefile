#
# Makefile
# luominghao, 2020-09-02 08:23
#

subdirs = base vim

.PHONY: $(subdirs)

all: $(subdirs)

$(subdirs):
	@echo "build $@"
	$(MAKE) -C $@ all

# vim:ft=make
#
