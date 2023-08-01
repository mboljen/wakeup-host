# wakeup-host

Service to wakeup remote host during boot time.


## Installation

Clone the remote repository and change into the local repository:

```bash
$ git clone https://github.com/mboljen/wakeup-host
$ cd wakeup-host
```

Use the following command to install and uninstall this software:

```bash
$ make install
$ make uninstall
```


## Usage

Use the configuration file `/etc/wakeup-host.conf` to apply default settings:

+ `MAC`: the address of the default host (default: none)
+ `WOL`: location of the `wakeonlan` utility (default: `/usr/bin/wakeonlan`)
+ `DELAY`: number of seconds to wait until the next invocation of `wakeonlan` is launched (default: `10`)
+ `RETRY`: maximum number of retries if `wakeonlan` fails (default: `2`)
+ `LOGFILE`: location of the logfile (default: `/var/log/wakeup-host.log`)

Use the following command to issue the command `start` on `/etc/init.d/wakeup-host`:

```bash
$ wakeup-host-start
```

There is a desktop entry stored in `/usr/local/applications` that can be invoked from the menu of the desktop environment.

Use the following commands to enable and disable the automatic `systemd` service to invoke `wakeonlan` during boot and suspend times.

```bash
$ make enable
$ make disable
```

Check the contents of the logfile that is monitored using `logrotate`.


## See also

[systemd](https://www.freedesktop.org/wiki/Software/systemd), [wakeonlan](https://github.com/jpoliv/wakeonlan)


## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.


## License

[MIT](https://choosealicense.com/licenses/mit/)
