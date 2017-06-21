# systemd-unit

Simple static-linked binary to execute SystemD commands via DBus. Designed to 
execute inside docker containers.

## Usage

```
$ systemd-unit start|stop|restart|state <unit>
```

`systemd-unit` uses DBus socket (`/var/run/dbus/system_bus_socket`) to 
interact systemd.

## Run in Docker

```
$ docker run -ti --rm \
    -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
    akaspin/systemd-unit:latest systemd-unit restart my.service
```