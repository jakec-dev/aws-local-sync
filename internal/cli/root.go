package cli

import (
	"fmt"

	"github.com/spf13/cobra"
)

func NewRootCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "aws-local-sync",
		Short: "Sync data from AWS services to your local development environment",
		Long: `aws-local-sync is a high-performance CLI tool for syncing data from AWS services
into your local development environment.

Documentation:
  https://github.com/jakec-dev/aws-local-sync/wiki`,
		SilenceUsage:  true,
		SilenceErrors: true,
	}

	RegisterCommands(cmd)

	return cmd
}

func Execute(cmd *cobra.Command) error {
	if err := cmd.Execute(); err != nil {
		return fmt.Errorf("command execution failed: %w", err)
	}
	return nil
}
