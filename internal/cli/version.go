package cli

import (
	"fmt"
	"io"

	"github.com/spf13/cobra"

	"github.com/jakec-dev/aws-local-sync/internal/version"
)

func NewVersionCommand(out io.Writer) *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Show detailed build and version information",
		Long: `Display the current version of aws-local-sync, including build metadata.

This includes the Git tag, commit hash, and build timestamp.
Useful for debugging or verifying which version of the CLI is running.`,

		Run: func(_ *cobra.Command, _ []string) {
			v := version.Get()
			fmt.Fprintf(out, "Version:     %s\n", v.Version)
			fmt.Fprintf(out, "Git commit:  %s\n", v.GitCommit)
			fmt.Fprintf(out, "Built at:    %s\n", v.BuildTime)
		}}
}
