#!/bin/bash

# Check root privileges
if [ $(id -u) -ne 0 ]; then
    echo "This script needs to be run with root privileges" 1>&2
    exit 1
fi

# Name of program
PROGNAME=wakeup-host

# Install wakeonlan
apt-get install wakeonlan confget

# Copy start/stop script to /etc/init.d
cp ${PROGNAME} /etc/init.d

# Copy default settings to /etc
cp ${PROGNAME}.conf /etc

# Copy services to /etc/systemd/system
cp ${PROGNAME}-boot.service ${PROGNAME}-suspend.service /etc/systemd/system

# Create logfile and adjust file permissions
touch /var/log/${PROGNAME}.log
chgrp users /var/log/${PROGNAME}.log
chmod 660 /var/log/${PROGNAME}.log

# Install settings for logrotate
cp logrotate /etc/logrotate.d/${PROGNAME}

# Install start command and desktop entry
cp ${PROGNAME}-start /usr/local/bin/${PROGNAME}
cp ${PROGNAME}-start.desktop /usr/local/share/applications

# Enable service
systemctl enable ${PROGNAME}-boot
systemctl enable ${PROGNAME}-suspend

# Start service
systemctl start ${PROGNAME}-boot
systemctl start ${PROGNAME}-suspend
