/*
Copyright © 2024 kyungho.byoun@gmail.com
*/
package cmd

import (
	"fmt"
	"log/slog"
	"os"
	"path"
	"slices"

	"github.com/byunk/dotfiles/internal/util"
	"github.com/spf13/cobra"
)

// lsCmd represents the ls command
var lsCmd = &cobra.Command{
	Use:   "ls",
	Short: "List all available packages",
	Args:  cobra.ExactArgs(0),
	Run: func(cmd *cobra.Command, args []string) {
		if err := runls(cmd, args); err != nil {
			slog.Error("Failed to list installers", "error", err)
			return
		}
	},
}

func init() {
	rootCmd.AddCommand(lsCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// lsCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// lsCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

func runls(cmd *cobra.Command, args []string) error {
	currPath, err := os.Getwd()
	if err != nil {
		return err
	}

	f, err := os.Open(path.Join(currPath, "installers"))
	if err != nil {
		return err
	}
	files, err := f.Readdir(0)
	if err != nil {
		return err
	}

	names := make([]string, 0, len(files))
	for _, v := range files {
		if v.IsDir() {
			continue
		}

		names = append(names, util.FileNameWithoutExtension(v.Name()))
	}

	// sort the names
	slices.Sort(names)

	for _, v := range names {
		fmt.Println(v)
	}

	return nil
}
