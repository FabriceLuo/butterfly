#
# make-subdirs.mk
# fabriceluo, 2022-01-20 15:44
#
#
SUBDIRS ?= $(wildcard */)

.PHONY: $(SUBDIRS)

all: $(SUBDIRS)
	@echo "make-subdirs.mk needs your attention"
	echo "$(dirnames)"

$(SUBDIRS):
	@echo "build $@"
	. $(PATHRC) && $(MAKE) -C $@ all

# vim:ft=make
#
