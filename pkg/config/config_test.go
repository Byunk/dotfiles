package config

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestInstallerConfig_Validate(t *testing.T) {
	tests := []struct {
		name    string
		config  InstallerConfig
		wantErr bool
	}{
		{
			name: "valid binary config",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypeBinary,
				VersionCmd: "example --version",
				URL:        "https://example.com/download",
			},
			wantErr: false,
		},
		{
			name: "invalid binary config missing URL",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypeBinary,
				VersionCmd: "example --version",
			},
			wantErr: true,
		},
		{
			name: "valid source config",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypeSource,
				VersionCmd: "example --version",
				URL:        "https://example.com/source",
			},
			wantErr: false,
		},
		{
			name: "invalid source config missing URL",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypeSource,
				VersionCmd: "example --version",
			},
			wantErr: true,
		},
		{
			name: "valid package config",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypePackage,
				VersionCmd: "example --version",
				InstallCmd: map[string]string{"apt": "sudo apt install example"},
			},
			wantErr: false,
		},
		{
			name: "invalid package config unsupported package manager",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypePackage,
				VersionCmd: "example --version",
				InstallCmd: map[string]string{"unsupported": "install example"},
			},
			wantErr: true,
		},
		{
			name: "valid pip config",
			config: InstallerConfig{
				Name:       "example",
				Type:       TypePip,
				VersionCmd: "example --version",
			},
			wantErr: false,
		},
		{
			name: "invalid config unsupported type",
			config: InstallerConfig{
				Name:       "example",
				Type:       "unsupported",
				VersionCmd: "example --version",
			},
			wantErr: true,
		},
		{
			name: "invalid config missing name",
			config: InstallerConfig{
				Type:       TypeBinary,
				VersionCmd: "example --version",
				URL:        "https://example.com/download",
			},
			wantErr: true,
		},
		{
			name: "invalid config missing type",
			config: InstallerConfig{
				Name:       "example",
				VersionCmd: "example --version",
				URL:        "https://example.com/download",
			},
			wantErr: true,
		},
		{
			name: "invalid config missing version command",
			config: InstallerConfig{
				Name: "example",
				Type: TypeBinary,
				URL:  "https://example.com/download",
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := tt.config.Validate()
			if tt.wantErr {
				require.Error(t, err, "name", tt.name, "config", tt.config, "wantErr", tt.wantErr)
			} else {
				require.NoError(t, err, "name", tt.name, "config", tt.config, "wantErr", tt.wantErr)
			}
		})
	}
}
