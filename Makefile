# tesseikoDNS - Expose SSH via Cloudflare Quick Tunnels
# Copyright (C) 2026 tesseiko
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

.PHONY: install cloudflared config

DESTDIR ?=
BINDIR  := $(DESTDIR)/usr/bin
ETCDIR  := $(DESTDIR)/etc/tesseikoDNS
UNITDIR := $(DESTDIR)/etc/systemd/system
CONFIG_FILE := tesseikoDNS.conf

cloudflared:
	@cloudflared -v >/dev/null || (echo "cloudflared is not installed. please install cloudflared;";exit 1)

$(ETCDIR)/$(CONFIG_FILE): $(CONFIG_FILE) testconfig | $(ETCDIR)
	@if [ -f $@ ]; then \
		diff $@ $(CONFIG_FILE) > /dev/null ; \
		if [ $$? -eq 1 ]; then \
			mv $@ $@.old || true; \
		fi \
	fi
	cp $(CONFIG_FILE) $@
	chmod 600 $@

config: $(CONFIG_FILE) testconfig | $(ETCDIR)
	@[ -f $(ETCDIR)/$(CONFIG_FILE) ] && mv $(ETCDIR)/$(CONFIG_FILE) $(ETCDIR)/$(CONFIG_FILE).old || true
	cp $(CONFIG_FILE) $(ETCDIR)/$(CONFIG_FILE)
	chmod 600 $(ETCDIR)/$(CONFIG_FILE)

$(ETCDIR):
	mkdir -p $@

$(BINDIR):
	mkdir -p $@

$(UNITDIR):
	mkdir -p $@

testconfig:
	@[ -f $(ETCDIR)/$(CONFIG_FILE) ] || ./tesseikoDNS --test-config $(CONFIG_FILE)

install: cloudflared $(ETCDIR)/$(CONFIG_FILE) tesseikoDNS tesseikoSSHDNS.service | $(BINDIR) $(UNITDIR)
	cp tesseikoDNS $(BINDIR)/tesseikoDNS
	cp tesseikoSSHDNS.service $(UNITDIR)/tesseikoSSHDNS.service
ifeq ($(DESTDIR),)
	systemctl daemon-reload
endif

