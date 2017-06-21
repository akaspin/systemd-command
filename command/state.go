package command

import (
	"github.com/spf13/cobra"
	"github.com/akaspin/cut"
	"github.com/coreos/go-systemd/dbus"
	"fmt"
	"github.com/akaspin/logx"
	"os"
)

type StateOptions struct {
	Passing []string
	Warning []string
}

func (o *StateOptions) Bind(cc *cobra.Command) {
	cc.Flags().StringArrayVarP(&o.Passing, "passing", "", []string{"active"}, "passing unit states")
	cc.Flags().StringArrayVarP(&o.Warning, "warning", "", []string{"activating","deactivating"}, "warning unit states")
}

type State struct {
	*cut.Environment
	*StateOptions
}

func (c *State) Run(args ...string) (err error) {
	if len(args) == 0 {
		err = fmt.Errorf("no unit name provided")
		return
	}
	conn, err := dbus.New()
	if err != nil {
		return
	}
	unitName := args[0]
	state, err := conn.ListUnitsByPatterns([]string{}, []string{unitName})
	conn.Close()
	if err != nil {
		return
	}
	for _, unit := range state {
		if unit.Name == unitName {
			// found
			for _, level := range c.Passing {
				if unit.ActiveState == level {
					logx.Debugf("unit %s state is passing", unitState(unit))
					return
				}
			}
			for _, level := range c.Warning {
				if unit.ActiveState == level {
					logx.Warningf("unit %s state is warning", unitState(unit))
					os.Exit(1)
				}
			}
			logx.Errorf("unit %s state is critical", unitState(unit))
			os.Exit(2)
		}
	}
	err = fmt.Errorf("unit %s is not found", unitName)
	return
}

func unitState(unit dbus.UnitStatus) (res string) {
	res = fmt.Sprintf("%s[%s %s %s]", unit.Name, unit.LoadState, unit.ActiveState, unit.SubState)
	return
}
