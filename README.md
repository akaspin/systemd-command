# systemd-command

Simple static-linked binary to execute SystemD commands via DBus.

## Usage

```
$ systemd-command start|stop|restart <unit>
```

`systemd-command` uses DBus socket (`/var/run/dbus/system_bus_socket`) to 
interact systemd.

## Run in Docker

```
$ docker run -ti --rm \
    -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
    akaspin/systemd-command:latest systemd-command restart my.service
```