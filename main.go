/*
Copyright © 2024 kyungho.byoun@gmail.com
*/
package main

import (
	"os"

	"github.com/byunk/dotfiles/cmd"
)

func main() {
	cmd := cmd.NewRootCmd()
	err := cmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}
