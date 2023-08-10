#
# Makefile
# luominghao, 2023-03-04 09:50
#
#


.PHONY: all clean


all: clean
	@echo "Makefile needs your attention"
	git clone git@github.com:FabriceLuo/keys.git
	python3 ./gen.py $$(cat ./keys/fnf/url.txt)

clean:
	rm -f ./v2ray.json
	rm -rf ./keys
# vim:ft=make
#
