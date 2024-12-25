/*
Copyright © 2024 kyungho.byoun@gmail.com
*/
package cmd

import (
	"github.com/spf13/cobra"
)

type RootOptions struct {
}

func NewRootCmd() *cobra.Command {
	// o := &RootOptions{}

	cmd := &cobra.Command{
		Use:   "dot",
		Short: "A CLI tool to manage dotfiles",
	}

	cmd.AddCommand(NewInstallCmd())
	cmd.AddCommand(NewListCmd())

	return cmd
}
