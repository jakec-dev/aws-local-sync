package version

//nolint:gochecknoglobals // required for version injection via ldflags
var (
	version   = "dev"
	gitCommit = "none"
	buildTime = "unknown"
)

type Info struct {
	Version   string
	GitCommit string
	BuildTime string
}

func Get() Info {
	return Info{
		Version:   version,
		GitCommit: gitCommit,
		BuildTime: buildTime,
	}
}
