
.PHONY: install cloudflared config

DESTDIR ?=
BINDIR  := $(DESTDIR)/usr/bin
ETCDIR  := $(DESTDIR)/etc/tesseikoDNS
UNITDIR := $(DESTDIR)/etc/systemd/system
CONFIG_FILE := tesseikoDNS.conf

cloudflared:
	@cloudflared -v >/dev/null || (echo "cloudflared is not installed. please install cloudflared;";exit 1)

$(ETCDIR)/$(CONFIG_FILE): $(CONFIG_FILE) testconfig | $(ETCDIR)
	@[ -f $@ ] && mv $@ $@.old || true
	cp $(CONFIG_FILE) $@
	chmod 600 $@

config: $(CONFIG_FILE) testconfig | $(ETCDIR)
	@[ -f $(ETCDIR)/$(CONFIG_FILE) ] && mv $(ETCDIR)/$(CONFIG_FILE) $(ETCDIR)/$(CONFIG_FILE).old || true
	cp config $(ETCDIR)/$(CONFIG_FILE)
	chmod 600 $(ETCDIR)/$(CONFIG_FILE)

$(ETCDIR):
	mkdir -p $@

$(BINDIR):
	mkdir -p $@

$(UNITDIR):
	mkdir -p $@

testconfig:
	./tesseikoDNS --test-config $(CONFIG_FILE)

install: cloudflared $(ETCDIR)/$(CONFIG_FILE) tesseikoDNS tesseikoSSHDNS.service | $(BINDIR) $(UNITDIR)
	cp tesseikoDNS $(BINDIR)/tesseikoDNS
	cp tesseikoSSHDNS.service $(UNITDIR)/tesseikoSSHDNS.service
ifeq ($(DESTDIR),)
	systemctl daemon-reload
endif

