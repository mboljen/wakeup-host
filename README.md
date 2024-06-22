# wakeup-host

Service to wakeup remote host during boot time.


## Synopsis

Use the following command to issue the command `start` on `/etc/init.d/wakeup-host`:

```console
$ wakeup-host-start
```

There is a desktop entry stored in `/usr/local/applications` that can be invoked from the menu of the desktop environment.

Use the following commands to enable and disable the automatic `systemd` service to invoke `wakeonlan` during boot and suspend times.

```console
$ make enable
$ make disable
```

Check the contents of the logfile that is monitored using `logrotate`.


## Installation

Clone the remote repository and change into the local repository:

```console
$ git clone https://github.com/mboljen/wakeup-host
$ cd wakeup-host
```

Use the following command to install and uninstall this software:

```console
$ make install
$ make uninstall
```


## Configuration

Use the configuration file `/etc/wakeup-host.conf` to apply local settings:

```ini
# The MAC address of the host to wake up
MAC=

# Location of wakeonlan command
WOL=/usr/bin/wakeonlan

# Number of seconds to wait until the next invocation of wakeonlan is issued
DELAY=10

# Maximum number of retries if wakeonlan fails
RETRY=2

# Location of the logfile
LOGFILE=/var/log/wakeup-host.log
```


## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.


## See also

[systemd](https://www.freedesktop.org/wiki/Software/systemd), [wakeonlan](https://github.com/jpoliv/wakeonlan)


## License

[MIT](https://choosealicense.com/licenses/mit/)
