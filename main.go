package main

import (
	"github.com/akaspin/logx"
	"github.com/akaspin/systemd-unit/command"
	"os"
)

func main() {
	err := command.Run(os.Stderr, os.Stdout, os.Stdin, os.Args[1:]...)
	if err != nil {
		logx.Critical(err)
		os.Exit(2)
	}
}
