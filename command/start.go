package command

import "github.com/akaspin/cut"

type Start struct {
	*cut.Environment
}

func (c *Start) Run(args ...string) (err error) {
	err = RunSystemdCmd("start", args...)
	return
}
