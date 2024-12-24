package install

type InstallerConfig struct {
	Name       string `yaml:"name"`
	Version    string `yaml:"version"`
	Type       string `yaml:"type"`
	URL        string `yaml:"url"`
	VersionCmd string `yaml:"versionCmd"`
}
