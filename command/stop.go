package command

import "github.com/akaspin/cut"

type Stop struct {
	*cut.Environment
}

func (c *Stop) Run(args ...string) (err error) {
	err = RunSystemdCmd("stop", args...)
	return
}
