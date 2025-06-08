package cli_test

import (
	"bytes"
	"strings"
	"testing"

	"github.com/jakec-dev/aws-local-sync/internal/cli"
)

func executeCommand(args ...string) (string, error) {
	buf := new(bytes.Buffer)
	cmd := cli.NewRootCommand()
	cmd.SetOut(buf)
	cmd.SetErr(buf)
	cmd.SetArgs(args)

	err := cli.Execute(cmd)

	return buf.String(), err
}

func TestRootCommand(t *testing.T) {
	output, err := executeCommand()

	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
	if !strings.Contains(output, "aws-local-sync") {
		t.Errorf("Expected output to contain `aws-local-sync`, got %s", output)
	}
}

func TestUnknownCommand(t *testing.T) {
	buf := new(bytes.Buffer)
	cmd := cli.NewRootCommand()
	cmd.SilenceErrors = false
	cmd.SilenceUsage = false
	cmd.SetOut(buf)
	cmd.SetErr(buf)
	cmd.SetArgs([]string{"invalid-command"})

	err := cli.Execute(cmd)
	output := buf.String()

	if err == nil {
		t.Fatalf("Expected error for unknown command, got nil")
	}
	if !strings.Contains(output, "unknown command") {
		t.Errorf("Expected output to contain `unknown command`, got %s", output)
	}
}
