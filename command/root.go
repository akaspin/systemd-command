package command

import (
	"github.com/akaspin/cut"
	"github.com/spf13/cobra"
	"io"
)

type SystemdCommand struct {
	*cut.Environment
}

func (c *SystemdCommand) Bind(cc *cobra.Command) {
	cc.Use = "systemd-command"
}

func Run(stderr, stdout io.Writer, stdin io.Reader, args ...string) (err error) {
	env := &cut.Environment{
		Stderr: stderr,
		Stdin:  stdin,
		Stdout: stdout,
	}

	cmd := cut.Attach(
		&SystemdCommand{env}, []cut.Binder{env},
		cut.Attach(
			&Restart{env}, []cut.Binder{},
		),
		cut.Attach(
			&Stop{env}, []cut.Binder{},
		),
	)
	cmd.SetArgs(args)
	cmd.SetOutput(stderr)
	cmd.SilenceUsage = true
	cmd.SilenceErrors = true
	err = cmd.Execute()
	return
}
