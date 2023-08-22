SHELL = /bin/bash

define newsetting
@read -p "$(1) [$(3)]: " thisset ; [[ -z "$$thisset" ]] && echo "$(2) $(3)" >> $(4) || echo "$(2) $$thisset" | sed 's/\/$$//g' >> $(4)
endef

define getsetting
$$(grep "^$(2)[ \t]*" $(1) | sed 's/^$(2)[ \t]*//g')
endef

all:
	@echo "usage:  make <config | install>"

tmp:
	@[[ ! -d tmp ]] && mkdir tmp

tmp/settings: tmp
	$(call newsetting,Specify install base directory,BASEDIR,/usr/local,tmp/settings)

config: tmp/settings

install: tmp/settings
	@sudo -v
	sudo cp fwcli $(call getsetting,tmp/settings,BASEDIR)/bin
	sudo cp fwcli.rc $(call getsetting,tmp/settings,BASEDIR)/share
	sudo chmod +x $(call getsetting,tmp/settings,BASEDIR)/bin/fwcli

clean:
	rm -rf tmp
