package cli

import "github.com/spf13/cobra"

func RegisterCommands(rootCmd *cobra.Command) {
	rootCmd.AddCommand(NewVersionCommand(rootCmd.OutOrStdout()))
}
