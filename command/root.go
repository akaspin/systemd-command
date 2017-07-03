package command

import (
	"github.com/akaspin/cut"
	"github.com/spf13/cobra"
	"io"
)

type SystemdUnit struct {
	*cut.Environment
}

func (c *SystemdUnit) Bind(cc *cobra.Command) {
	cc.Use = "systemd-unit"
}

func Run(stderr, stdout io.Writer, stdin io.Reader, args ...string) (err error) {
	env := &cut.Environment{
		Stderr: stderr,
		Stdin:  stdin,
		Stdout: stdout,
	}
	stateEnv := &StateOptions{}

	cmd := cut.Attach(
		&SystemdUnit{env}, []cut.Binder{env},
		cut.Attach(
			&Restart{env}, []cut.Binder{},
		),
		cut.Attach(
			&Reload{env}, []cut.Binder{},
		),
		cut.Attach(
			&Stop{env}, []cut.Binder{},
		),
		cut.Attach(
			&State{env, stateEnv}, []cut.Binder{stateEnv},
		),
		cut.Attach(
			&Version{env}, []cut.Binder{},
		),
	)
	cmd.SetArgs(args)
	cmd.SetOutput(stderr)
	cmd.SilenceUsage = true
	cmd.SilenceErrors = true
	err = cmd.Execute()
	return
}
