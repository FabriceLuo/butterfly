#
# Makefile
# luominghao, 2020-05-11 08:57
#
#

VIM_DOWNLOAD_URL = https://codeload.github.com/vim/vim/zip/master
vim_repo_file_name = vim-latest.tar.gz
vim_src_dir = src
vim_tar_name = vim.tar.gz
vim_download_opt = -o $(vim_tar_name)
vim_config_opt = 
INSTALL_ROOT = /opt
vim_install_root = $(INSTALL_ROOT)/vim

vim_config_opt += --prefix=$(vim_install_root)
vim_config_opt += --enable-python3interp=yes
vim_config_opt += --enable-cscope
vim_config_opt += --enable-terminal
vim_config_opt += --enable-multibyte
vim_config_opt += --enable-gui=no

ifneq ($(and $(SOCKS5_HOST), $(SOCKS5_PORT)), )
	vim_download_opt += --socks5 $(SOCKS5_HOST):$(SOCKS5_PORT)
endif

ifneq ($(PRIVATE_REPO_URL), )
	VIM_DOWNLOAD_URL = $(PRIVATE_REPO_URL)/$(vim_repo_file_name)
endif

.PHONY: vim_all vim_download vim_decompress vim_configue vim_compile vim_install config clean

all: clean vim_all config
	@echo "Makefile needs your attention"

clean:
	rm -rf $(vim_src_dir)
	rm -f $(vim_tar_name)


# config: config_backup
config:
	install -D -m 0600 vimrc ~/.vimrc

config_backup:
	test -f ~/.vimrc && mv -f ~/.vimrc ~/.vimrc.back

vim_all: vim_make vim_install

vim_make: vim_download vim_decompress vim_configue vim_compile

vim_install:
	su -c "make -C $(vim_src_dir) install" root

vim_configue:
	cd $(vim_src_dir) && ./configure $(vim_config_opt)

vim_compile:
	make -C $(vim_src_dir)

vim_decompress:
	@echo "untar vim source"
	mkdir -p $(vim_src_dir)
	tar -xvf $(vim_tar_name) --strip-components 1 -C $(vim_src_dir)

vim_download:
	@echo "download vim source"
	curl $(vim_download_opt) $(VIM_DOWNLOAD_URL) 

# vim:ft=make
#
