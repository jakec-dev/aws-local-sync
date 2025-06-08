package cli_test

import (
	"bytes"
	"strings"
	"testing"

	"github.com/spf13/cobra"

	"github.com/jakec-dev/aws-local-sync/internal/cli"
)

func TestVersionCommand(t *testing.T) {
	buf := new(bytes.Buffer)
	cmd := cobra.Command{
		Use: "test",
	}
	cmd.SetOut(buf)
	cmd.SetErr(buf)

	err := cli.NewVersionCommand(cmd.OutOrStdout()).Execute()

	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
	output := buf.String()
	if !strings.Contains(output, "Version:") {
		t.Errorf("Expected output to contain `Version:`, got %s", output)
	}
	if !strings.Contains(output, "Git commit:") {
		t.Errorf("Expected output to contain `Git commit:`, got %s", output)
	}
	if !strings.Contains(output, "Built at:") {
		t.Errorf("Expected output to contain `Built at:`, got %s", output)
	}
}
