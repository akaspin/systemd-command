package command

import "github.com/akaspin/cut"

type Restart struct {
	*cut.Environment
}

func (c *Restart) Run(args ...string) (err error) {
	err = RunSystemdCmd("restart", args...)
	return
}
