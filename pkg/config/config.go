package config

import (
	"fmt"
	"os"
	"path"
)

const (
	TypeBinary  = "binary"
	TypeSource  = "source"
	TypePackage = "package"
	TypePip     = "pip"
)

var (
	BinDir = os.ExpandEnv("$HOME/.local/bin")
	TmpDir = path.Join(os.TempDir(), "dotfiles")
)

// TODO: add support for other package managers
var SupportedPackageManagers = [...]string{"apt", "brew", "zypper"}

type InstallerConfig struct {
	// Name of the package
	// Usually the name of the executable
	Name string `yaml:"name"`

	// Desired version of the package
	Version string `yaml:"version"`

	// Type of the installer
	// binary installs a binary from a URL
	// source installs a tarball from a URL
	// package installs a package from a package manager
	// pip installs a package from pip
	Type string `yaml:"type"`

	// URL to download the package
	URL string `yaml:"url"`

	// Command to check the version of the installed package
	VersionCmd string `yaml:"versionCmd"`

	// Command to install the package with the package manager
	InstallCmd map[string]string `yaml:"installCmd"`

	// default: $HOME/.local/bin
	Target string `yaml:"targetDir"`

	// TODO: dependencies (For nvim)
	// TODO: exclude specific os or arch (For example, docker buildx should not be installed in macOS)
}

func (c *InstallerConfig) TargetDir() string {
	if c.Target == "" {
		return BinDir
	}
	return os.ExpandEnv(c.Target)
}

// Validate checks if the configuration is valid
func (c *InstallerConfig) Validate() error {
	err := shouldNotEmpty(c.Name, c.Type, c.VersionCmd)
	if err != nil {
		return err
	}

	switch c.Type {
	case TypeBinary:
		return c.validateBinary()
	case TypeSource:
		return c.validateSource()
	case TypePackage:
		return c.validatePackage()
	case TypePip:
		return c.validatePip()
	default:
		return fmt.Errorf("unsupported type: %s", c.Type)
	}
}

func (c *InstallerConfig) validateBinary() error {
	return shouldNotEmpty(c.URL)
}

func (c *InstallerConfig) validateSource() error {
	return shouldNotEmpty(c.URL)
}

func (c *InstallerConfig) validatePackage() error {
	// Keys in the InstallCmd should be one of the SupportedPackageManagers
	for k := range c.InstallCmd {
		found := false
		for _, v := range SupportedPackageManagers {
			if k == v {
				found = true
				break
			}
		}
		if !found {
			return fmt.Errorf("unsupported package manager: %s", k)
		}
	}

	return nil
}

func (c *InstallerConfig) validatePip() error {
	return nil
}
