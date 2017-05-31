package command

import (
	"fmt"
	"github.com/coreos/go-systemd/dbus"
)

func RunSystemdCmd(what string, unit ...string) (err error)  {
	conn, err := dbus.New()
	if err != nil {
		return
	}
	var failures []error
	for _, u := range unit {
		failure := func(u string) (err error) {
			ch := make(chan string)
			switch what {
			case "restart":
				_, err = conn.RestartUnit(u, "replace", ch)
			case "stop":
				_, err = conn.StopUnit(u, "replace", ch)
			case "start":
				_, err = conn.StartUnit(u, "replace", ch)
			case "reload":
				_, err = conn.ReloadUnit(u, "replace", ch)
			default:
				err = fmt.Errorf("unknown command %s", what)
			}
			if err != nil {
				return
			}
			<-ch
			return
		}(u)
		if failure != nil {
			failures = append(failures, failure)
		}
	}
	if len(failures) > 0 {
		err = fmt.Errorf("%v", err)
	}
	return
}
