package command

import "github.com/akaspin/cut"

type Reload struct {
	*cut.Environment
}

func (c *Reload) Run(args ...string) (err error) {
	err = RunSystemdCmd("reload", args...)
	return
}
