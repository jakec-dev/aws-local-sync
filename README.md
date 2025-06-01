# aws-local-sync

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/jakec-dev/aws-local-sync/badge)](https://scorecard.dev/viewer/?uri=github.com/jakec-dev/aws-local-sync)

**aws-local-sync** is a high-performance CLI tool that syncs data from AWS services into your local development environment. It's designed to be **simple**, **fast**, **reliable**, and **developer-friendly**, with support for plugins, caching, and seamless workflow integration.

Key features:

- ⚡ Zero-config for common syncs
- 🔁 Reliable with retries, caching, and recovery
- 🔌 Extensible architecture (providers & targets)
- 🧠 Developer-friendly CLI with helpful commands
- 📦 Node.js wrapper for easy cross-platform installs

> This project is currently in active development. Expect rapid iteration, breaking changes, and new modules as core components are implemented.

## Getting Started

### Option 1: Install with Go

```sh
go install github.com/jakec-dev/aws-local-sync/cmd/aws-local-sync@latest

# Then use it from anywhere:
aws-local-sync
```

### Option 2: Run from source

```sh
# Clone the repo
git clone https://github.com/jakec-dev/aws-local-sync.git
cd aws-local-sync

# Build the CLI
go build -o bin/aws-local-sync ./cmd/aws-local-sync

# Run the CLI
./bin/aws-local-sync
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines. 

## License

This project is licensed under the [MIT License](LICENSE).
