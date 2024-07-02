NAME=wakeup-host
VERSION=0.0.1

DIRS=

PREFIX?=/usr/local

#
INSTALL   = $(shell command -v install)
SYSTEMCTL = $(shell command -v systemctl)
READMODE  = 644

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
    $(LOGROTATE) \
    $(LOCALBIN) \
    $(DESKTOPENTRY) \
    $(SERVICEBOOT) \
    $(SERVICESUSPEND)

# Require root privileges
ifneq ($(shell id -u),0)
  $(error This Makefile requires root privileges)
endif

# Default target
all:

# Debugging
debug:
	$(info INITSCRIPT     = $(INITSCRIPT))
	$(info CONFIGFILE     = $(CONFIGFILE))
	$(info LOGFILE        = $(LOGFILE))
	$(info LOGROTATE      = $(LOGROTATE))
	$(info LOCALBIN       = $(LOCALBIN))
	$(info DESKTOPENTRY   = $(DESKTOPENTRY))
	$(info SERVICEBOOT    = $(SERVICEBOOT))
	$(info SERVICESUSPEND = $(SERVICESUSPEND))

clean:
	$(info Target `$@` not implemented yet)

veryclean: clean
	$(info Target `$@` not implemented yet)

tag:
	git tag v$(VERSION)
	git push --tags

prerequisites:
	apt-get -qq install wakeonlan confget

enable:
	$(SYSTEMCTL) enable $(NAME)-boot $(NAME)-suspend
	$(SYSTEMCTL) daemon-reload

disable:
	$(SYSTEMCTL) disable $(NAME)-boot $(NAME)-suspend
	$(SYSTEMCTL) daemon-reload

install: prerequisites $(INSTALLFILES) $(LOGFILE) $(CONFIGFILE)
	update-desktop-database

uninstall:
	$(RM) $(INSTALLFILES)
	update-desktop-database

purge: uninstall
	$(RM) $(LOGFILE) $(CONFIGFILE)

# Install init script
$(INITSCRIPT): $(NAME)
	$(INSTALL) $< $(dir $@)

# Install logrotate configuration file
$(LOGROTATE): logrotate
	$(INSTALL) --mode=$(READMODE) $< $@

# Install local binary
$(LOCALBIN): $(NAME)-start
	$(INSTALL) $< $(dir $@)

# Install desktop entry
$(DESKTOPENTRY): $(NAME)-start.desktop
	$(INSTALL) --mode=$(READMODE) $< $(dir $@)

# Install systemd service upon boot
$(SERVICEBOOT): $(NAME)-boot.service
	$(INSTALL) --mode=$(READMODE) $< $(dir $@)

# Install systemd service upon suspend
$(SERVICESUSPEND): $(NAME)-suspend.service
	$(INSTALL) --mode=$(READMODE) $< $(dir $@)

# Create empty logfile
$(LOGFILE):
	touch $@
	chgrp users $@
	chmod 660 $@

# Create default configuration file
$(CONFIGFILE): $(NAME).conf
	$(INSTALL) --mode=$(READMODE) $< $(dir $@)

.PHONY: clean veryclean
