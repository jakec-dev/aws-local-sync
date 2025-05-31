# Contributing to aws-local-sync

Thanks for your interest in contributing to **aws-local-sync**! This guide outlines the basics for setting up your development environment, understanding the project structure, and contributing effectively.

## Development Setup

1. **Clone the repo**

   ```sh
   git clone https://github.com/jakec-dev/aws-local-sync.git
   cd aws-local-sync
   ```

2. **Build the CLI**

  ```sh
  go build -o bin/aws-local-sync ./cmd/aws-local-sync
  ```

3. **Run it**

  ```sh
  ./bin/aws-local-sync
  ```

4. **Run tests**

  (Test suite coming soon)

## Contributing Guidelines

- Feature requests and bug reports are welcome via GitHub Issues.
- Follow idiomatic Go and ensure your code passes go fmt.
- Use semantic commits (e.g., feat: add support for S3 source).
- Prefer small, focused pull requests with clear descriptions.

## Project Structure

```text
cmd/aws-local-sync/     # CLI entry point (main.go) using Cobra
internal/               # Core logic (sync engine, providers, targets)
  ├── sync/             # Sync manager and orchestration
  ├── providers/        # AWS service-specific data exporters
  ├── targets/          # Local import destinations (e.g. Docker, dir)
  └── config/           # YAML parsing, validation, and discovery
pkg/                    # Optional: shared libraries (exported APIs)
scripts/                # Dev scripts and tooling
testdata/               # Synthetic data for testing
```

## Thanks!

Your contributions help make aws-local-sync better for everyone. Whether it's fixing bugs, suggesting features, or improving docs — you're appreciated.
