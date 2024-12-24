/*
Copyright © 2024 kyungho.byoun@gmail.com
*/
package cmd

import (
	"fmt"
	"log/slog"
	"os"
	"path"

	"github.com/byunk/dotfiles/internal/install"
	"github.com/byunk/dotfiles/internal/util"
	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"
)

func NewFromConfig(name string) (*install.InstallOptions, error) {
	// name should be listed in installers directory
	currPath, err := os.Getwd()
	if err != nil {
		return nil, err
	}

	f, err := os.Open(path.Join(currPath, "installers"))
	if err != nil {
		return nil, err
	}
	files, err := f.Readdir(0)
	if err != nil {
		return nil, err
	}

	config := &install.InstallerConfig{}
	for _, v := range files {
		if util.FileNameWithoutExtension(v.Name()) == name {
			slog.Info("Package found", "name", name)

			// read the config file (yaml)
			file, err := os.ReadFile(path.Join(currPath, "installers", v.Name()))
			if err != nil {
				return nil, err
			}

			// parse the config file
			err = yaml.Unmarshal(file, config)
			if err != nil {
				return nil, err
			}

			slog.Info("Parsed configuration", "name", config.Name, "version", config.Version)
			return &install.InstallOptions{
				Downloader: install.NewDownloader(),
				Name:       config.Name,
				Version:    config.Version,
				Type:       config.Type,
				URL:        config.URL,
				VersionCmd: config.VersionCmd,
			}, nil
		}
	}

	return nil, fmt.Errorf("unknown package: %s", name)
}

// installCmd represents the install command
var installCmd = &cobra.Command{
	Use:   "install",
	Short: "Install the specified package",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		if err := run(cmd, args); err != nil {
			fmt.Println(err)
			return
		}
	},
}

func init() {
	RootCmd.AddCommand(installCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// installCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// installCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

func run(cmd *cobra.Command, args []string) error {
	name := args[0]
	o, err := NewFromConfig(name)
	if err != nil {
		return err
	}

	return install.Install(o)
}
