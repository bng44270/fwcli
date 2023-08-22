SHELL = /bin/bash

BINREQ = /usr/bin/awk /usr/bin/cat /usr/bin/wc /usr/bin/clear /usr/sbin/iptables /usr/sbin/iptables-save /usr/bin/iptables-xml /usr/sbin/ifconfig /usr/bin/netstat /usr/bin/netcat /usr/bin/ping /usr/bin/tcpdump /usr/bin/chmod /usr/bin/seq /usr/bin/bc /usr/bin/rev /usr/bin/traceroute /usr/bin/dig

define checkfile
$(if $(shell which $(1)),,$(error "Binary not found: $(1)"))
endef

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
	$(foreach thisbin,$(BINREQ),$(call checkfile,$(thisbin)))
	sudo cp fwcli $(call getsetting,tmp/settings,BASEDIR)/bin
	sudo cp fwcli.rc $(call getsetting,tmp/settings,BASEDIR)/share
	sudo chmod +x $(call getsetting,tmp/settings,BASEDIR)/bin/fwcli

clean:
	rm -rf tmp
