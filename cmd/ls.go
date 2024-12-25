/*
Copyright © 2024 kyungho.byoun@gmail.com
*/
package cmd

import (
	"fmt"
	"log/slog"
	"slices"

	"github.com/byunk/dotfiles/pkg/config"
	"github.com/spf13/cobra"
)

type ListOptions struct {
	Type    bool
	Version bool
}

func NewListCmd() *cobra.Command {
	o := &ListOptions{}

	cmd := &cobra.Command{
		Use:   "ls",
		Short: "List all available packages",
		Args:  cobra.ExactArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			if err := o.Run(cmd, args); err != nil {
				slog.Error("Failed to list installers", "error", err)
				return
			}
		},
	}

	cmd.Flags().BoolVarP(&o.Type, "type", "t", false, "Show the type of the packages")
	cmd.Flags().BoolVarP(&o.Version, "version", "v", false, "Show versions of the packages")

	return cmd
}

func (o *ListOptions) Run(cmd *cobra.Command, args []string) error {
	r := config.NewReader()
	configs, err := r.AllConfigs()
	if err != nil {
		return err
	}

	slices.SortFunc(configs, func(a, b *config.InstallerConfig) int {
		if a.Name < b.Name {
			return -1
		} else if a.Name > b.Name {
			return 1
		} else {
			return 0
		}
	})

	for _, v := range configs {
		out := v.Name
		if o.Version {
			if v.Version == "" {
				out += " (latest)"
			} else {
				out += fmt.Sprintf(" (%s)", v.Version)
			}
		}
		if o.Type {
			out += fmt.Sprintf(" (%s)", v.Type)
		}
		fmt.Println(out)
	}

	return nil
}
