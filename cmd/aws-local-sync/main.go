package main

import (
	"fmt"
	"os"

	"github.com/jakec-dev/aws-local-sync/internal/cli"
)

func main() {
	if err := cli.Execute(cli.NewRootCommand()); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
