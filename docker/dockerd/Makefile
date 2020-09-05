#
# Makefile
# luominghao, 2020-07-18 10:25
#

DAEMON_CONFIG_PATH=/etc/docker/daemon.json

install:
	install -b -D -g docker -o root -m 0660 daemon.json $(DAEMON_CONFIG_PATH)

# vim:ft=make
#
