package cli_test

import (
	"testing"

	"github.com/spf13/cobra"

	"github.com/jakec-dev/aws-local-sync/internal/cli"
)

func TestAllCommandsPresent(t *testing.T) {
	cmd := &cobra.Command{Use: "test"}

	cli.RegisterCommands(cmd)

	expected := map[string]bool{"version": false}
	for _, sc := range cmd.Commands() {
		if _, ok := expected[sc.Name()]; ok {
			expected[sc.Name()] = true
		}
	}
	for name, seen := range expected {
		if !seen {
			t.Errorf("Expected subcommand %q to be registered", name)
		}
	}
}
