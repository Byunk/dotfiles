/*
Copyright © 2024 kyungho.byoun@gmail.com
*/
package cmd

import (
	"fmt"
	"log/slog"

	"github.com/byunk/dotfiles/pkg/config"
	"github.com/byunk/dotfiles/pkg/install"
	"github.com/spf13/cobra"
)

// InstallOptions represents the options for the install command
// TODO: merge with install.InstallOptions
// TODO: install all
type InstallOptions struct {
	Target  string
	Version string
	Upgrade bool
}

func NewFromConfig(name string) (*install.InstallOptions, error) {
	r := config.NewReader()
	c, err := r.GetConfig(name)
	if err != nil {
		return nil, err
	}

	slog.Info("Found configuration", "config", c)

	return install.NewForConfig(c, install.NewDownloader()), nil
}

func NewInstallCmd() *cobra.Command {
	o := &InstallOptions{}

	cmd := &cobra.Command{
		Use:   "install",
		Short: "Install the specified package",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			if err := o.Run(cmd, args); err != nil {
				fmt.Println(err)
				return
			}
		},
	}

	cmd.Flags().StringVarP(&o.Target, "target", "t", "", "Target directory to install the package")
	cmd.Flags().StringVarP(&o.Version, "version", "v", "", "Version to install")
	cmd.Flags().BoolVarP(&o.Upgrade, "upgrade", "u", false, "Upgrade the package")

	return cmd
}

func (o *InstallOptions) Run(cmd *cobra.Command, args []string) error {
	name := args[0]
	options, err := NewFromConfig(name)
	if err != nil {
		return err
	}

	if o.Target != "" {
		options.Target = o.Target
	}

	if o.Version != "" {
		options.Version = o.Version
	}

	return install.Install(options)
}
