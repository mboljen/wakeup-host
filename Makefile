NAME=wakeup-host
VERSION=0.0.1

DIRS=

PREFIX?=/usr/local

#
CP        = $(shell command -v cp)
INSTALL   = $(shell command -v install)
SYSTEMCTL = $(shell command -v systemctl)

#
INITSCRIPT     = /etc/init.d/$(NAME)
CONFIGFILE     = /etc/$(NAME).conf
LOGROTATE      = /etc/logrotate.d/$(NAME)
LOCALBIN       = $(PREFIX)/bin/$(NAME)-start
DESKTOPENTRY   = $(PREFIX)/share/applications/$(NAME)-start.desktop
LOGFILE        = /var/log/$(NAME).log
SERVICEBOOT    = /etc/systemd/system/$(NAME)-boot.service
SERVICESUSPEND = /etc/systemd/system/$(NAME)-suspend.service

#
INSTALLFILES = \
  $(INITSCRIPT) \
  $(CONFIGFILE) \
  $(LOGROTATE) \
  $(LOCALBIN) \
  $(DESKTOPENTRY) \
  $(LOGFILE) \
  $(SERVICEBOOT) \
  $(SERVICESUSPEND)

all:

clean:

tag:
	git tag v$(VERSION)
	git push --tags

prerequisites: checksudo
	apt-get -qq install wakeonlan confget

enable: checksudo
	$(SYSTEMCTL) enable $(NAME)-boot $(NAME)-suspend
	$(SYSTEMCTL) daemon-reload

disable: checksudo
	$(SYSTEMCTL) disable $(NAME)-boot $(NAME)-suspend
	$(SYSTEMCTL) daemon-reload

install: checksudo prerequisites $(INSTALLFILES)
	update-desktop-database

uninstall: checksudo
	$(RM) $(INSTALLFILES)
	update-desktop-database

checksudo:
ifneq ($(shell id -u),0)
	$(error This target requires root privileges)
endif

$(INITSCRIPT): $(NAME) checksudo
	$(INSTALL) $< $(dir $@)

$(CONFIGFILE): $(NAME).conf checksudo
	$(INSTALL) $< $(dir $@)

$(LOGFILE): checksudo
	touch $@
	chgrp users $@
	chmod 660 $@

$(LOGROTATE): logrotate checksudo
	$(INSTALL) $< $@

$(LOCALBIN): $(NAME)-start checksudo
	$(INSTALL) $< $(dir $@)

$(DESKTOPENTRY): $(NAME)-start.desktop checksudo
	$(INSTALL) $< $(dir $@)

$(SERVICEBOOT): $(NAME)-boot.service checksudo
	$(INSTALL) $< $(dir $@)

$(SERVICESUSPEND): $(NAME)-suspend.service checksudo
	$(INSTALL) $< $(dir $@)

.PHONY: clean
