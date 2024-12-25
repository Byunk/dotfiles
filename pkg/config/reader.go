package config

import (
	"fmt"
	"log/slog"
	"os"
	"path"

	"gopkg.in/yaml.v3"
)

const configDir = "installers"

// Reader reads the configuration file from the filesystem
type Reader struct {
	// Path to the dotfiles directory
	DotDir string
}

// NewReader creates a new Reader
func NewReader() *Reader {
	dotdir := os.Getenv("DOTDIR")
	if dotdir == "" {
		slog.Error("DOTDIR is not set")
		os.Exit(1)
	}

	return &Reader{
		DotDir: dotdir,
	}
}

// ConfigDir returns the directory where the configuration files are stored
func (r *Reader) ConfigDir() string {
	return path.Join(r.DotDir, configDir)
}

// TODO: validate all configuration files
func (r *Reader) ValidateConfigs() error {
	return nil
}

// AllConfigs returns all the configuration files
func (r *Reader) AllConfigs() ([]*InstallerConfig, error) {
	f, err := os.Open(r.ConfigDir())
	if err != nil {
		return nil, err
	}

	files, err := f.Readdir(0)
	if err != nil {
		return nil, err
	}

	configs := make([]*InstallerConfig, 0, len(files))
	for _, v := range files {
		// read the config file (yaml)
		file, err := os.ReadFile(path.Join(r.ConfigDir(), v.Name()))
		if err != nil {
			slog.Debug("Failed to read file", "file", v.Name())
			continue
		}

		// parse the config file
		config := &InstallerConfig{}
		err = yaml.Unmarshal(file, config)
		if err != nil {
			slog.Debug("Failed to parse file", "file", v.Name())
			continue
		}

		err = config.Validate()
		if err != nil {
			slog.Debug("Failed to validate configuration", "file", v.Name())
			continue
		}

		configs = append(configs, config)
	}

	return configs, nil
}

// GetConfig returns the configuration file for the given package name
func (r *Reader) GetConfig(name string) (*InstallerConfig, error) {
	configs, err := r.AllConfigs()
	if err != nil {
		return nil, err
	}

	for _, v := range configs {
		if v.Name == name {
			return v, nil
		}
	}

	return nil, fmt.Errorf("unknown package: %s", name)
}
