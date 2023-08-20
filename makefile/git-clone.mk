#
# git-clone.mk
# fabriceluo, 2023-07-01 16:32
#

CLONE_URL ?=

CLONE_DST_ROOT ?= 
CLONE_DST_NAME ?= 

.PHONY: clone configure

clone:
	mkdir -p $(CLONE_DST_ROOT)
	git clone --depth 1 $(CLONE_URL) $(CLONE_DST_ROOT)/$(CLONE_DST_NAME)
	@echo "Clone $(CLONE_URL) successed."

configure:
	@echo "Configure $(CLONE_URL) successed."

all: clone configure
	@echo "Clone and configure $(OWNER)/$(REPO) successed."

# vim:ft=make
#
