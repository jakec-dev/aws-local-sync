# Contributing to aws-local-sync

Thanks for your interest in contributing to **aws-local-sync**! This guide outlines the basics for setting up your development environment, understanding the project structure, and contributing effectively.

## Prerequisites

- Go 1.24.3 or later
- Make

## Development Setup

1. **Clone the repo**

   ```sh
   git clone https://github.com/jakec-dev/aws-local-sync.git
   cd aws-local-sync
   ```

2. **Install development tools**

   ```sh
   make install  # Installs all required dev tools and dependencies
   ```

   This will install:
   - golangci-lint (code linting)
   - lefthook (git hooks)
   - gitleaks (secret scanning)
   - govulncheck (vulnerability scanning)
   - staticcheck (static analysis)
   - go-licenses (license compliance)
   - goreleaser (release automation)
   - cosign (artifact signing)
   - syft (SBOM generation)

3. **Explore available commands**

   ```sh
   make help
   ```

4. **Build and run**

   ```sh
   make build    # Build with version info
   make run      # Build and execute
   ```

5. **Run tests and quality checks**

   ```sh
   make test     # Run tests with race detection and coverage
   make lint     # Run golangci-lint
   make audit    # Full audit including security scanning
   ```

## Development Workflow

### Git Hooks

This project uses [lefthook](https://github.com/evilmartians/lefthook) for Git hooks to ensure code quality:

- **Pre-commit hooks** automatically run:
  - `golangci-lint` with auto-fix for formatting issues
  - `go mod tidy` when go.mod changes are staged
- **Manual hook execution**: `make hooks-run`
- **Bypass hooks** when necessary: `git commit --no-verify`

### Making Changes

1. **Before coding**: Run `make audit` to ensure a clean baseline
2. **Format code**: Automatic via pre-commit hooks or `make lint`
3. **Test your changes**: `make test` generates coverage reports
4. **Lint check**: Automatic via pre-commit hooks or `make lint`
5. **Final audit**: `make audit` before pushing

### Useful Make Targets

- `make install` - Install all dev tools and git hooks
- `make hooks-run` - Manually run pre-commit checks
- `make tidy` - Clean up dependencies and format code
- `make clean` - Remove build artifacts
- `make upgradeable` - Check for dependency updates
- `make build-static` - Build static binary for containers
- `make release` - Create a full GitHub release (requires git tag)
- `make release-snapshot` - Test release locally without publishing
- `make licenses` - Check licenses of all dependencies

### Testing GitHub Actions Locally

You can test GitHub Actions workflows locally using [act](https://github.com/nektos/act):

```sh
act pull_request    # Simulate test workflow
act push -j goreleaser --secret-file .env    # Test release workflow (needs GITHUB_TOKEN)
```

## Contributing Guidelines

- Feature requests and bug reports are welcome via GitHub Issues
- Code must pass all linting rules (see `.golangci.yml`)
- Tests required for new functionality (aim for >80% coverage)
- Use semantic commits (e.g., `feat: add S3 bucket support`)
- Prefer small, focused pull requests with clear descriptions

## Project Structure

```text
cmd/aws-local-sync/     # CLI entry point (main.go)
internal/               # Core logic (private to this module)
  ├── config/           # Configuration handling
  ├── providers/        # AWS service-specific data exporters
  ├── sync/             # Sync manager and orchestration
  └── targets/          # Local import destinations
build/                  # Build artifacts, npm wrapper (future)
bin/                    # Compiled binaries (git-ignored)
dist/                   # GoReleaser output (git-ignored)
.github/
  ├── workflows/        # GitHub Actions CI/CD pipelines
  └── dependabot.yml    # Automated dependency updates
```

## Pull Request Process

1. Fork the repository and create your branch from `master`
2. Ensure all tests pass: `make audit`
3. Update documentation if changing functionality
4. Submit PR with clear description of changes and motivation
5. Ensure CI checks pass (uses same Make targets)

### CI/CD Pipeline

Pull requests automatically trigger GitHub Actions workflows that run:
- `make lint` - Code style and static analysis
- `make test` - Unit tests with race detection and coverage
- `make audit` - Security scanning and dependency verification
- `make build` - Binary compilation verification

Coverage reports are uploaded as artifacts for each workflow run.

## Release Process

This project follows security best practices for releases. Only authorized maintainers can create releases through our protected workflow.

### For Contributors

Contributors cannot directly create releases. The release process is:

1. **Contribute your changes** via PR to `master`
2. **Maintainers review and merge** your contributions
3. **Maintainers create releases** when appropriate

### For Maintainers

Releases are created through a secure, automated process. See [RELEASE_SETUP.md](docs/RELEASE_SETUP.md) for initial setup instructions.

1. **Prepare the release**
   - Ensure all desired changes are merged to `master`
   - Verify CI is passing on `master`
   - Review the changelog since last release

2. **Create the release**
   ```sh
   # DO NOT push tags directly - use the release workflow
   # Tags pushed directly will be rejected by branch protection rules
   ```

3. **Release via GitHub UI**
   - Go to Actions → Release Workflow → Run workflow
   - Enter the version (e.g., `v0.1.0`)
   - The workflow will:
     - Create and push the tag
     - Run all tests
     - Build multi-platform binaries
     - Create archives and checksums
     - Sign artifacts with cosign
     - Generate SBOMs and SLSA provenance
     - Create a draft GitHub release

4. **Review and publish**
   - Review the draft release in GitHub
   - Verify all artifacts are present
   - Edit release notes if needed
   - Publish when ready

### Branch and Tag Protection

- **Branch protection**: `master` requires PR reviews and passing CI
- **Tag protection**: Direct tag pushes are blocked; only the release workflow can create tags
- **Release permissions**: Only maintainers with write access can trigger releases

### Testing Releases Locally

Before triggering a real release, you can test locally:

```sh
# Test the build process without publishing
make release-snapshot

# Validate the GoReleaser configuration
goreleaser check

# Check what files would be included
goreleaser release --snapshot --clean
ls -la dist/
```

### Release Artifacts

Each release includes these security artifacts:

| Artifact | Purpose | Verification |
|----------|---------|--------------|
| `.sig` files | Signed checksums | `cosign verify-blob` |
| `.sbom.json` files | Software Bill of Materials | Dependency scanning |
| `.intoto.jsonl` files | SLSA provenance | Supply chain verification |

These artifacts ensure:
- **Integrity**: Artifacts haven't been tampered with
- **Transparency**: All dependencies are documented
- **Provenance**: Build source and process are verifiable
- **OpenSSF Compliance**: High scorecard rating

### Release Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes and minor updates

Examples: `v1.0.0`, `v1.2.3`, `v2.0.0-rc1`

## Code Style

Our `.golangci.yml` enforces comprehensive style rules. Key points:
- No global variables (use dependency injection)
- Explicit error handling (no ignored errors)
- Meaningful variable names
- Package comments required
- See full configuration in `.golangci.yml`

## Thanks!

Your contributions help make aws-local-sync better for everyone. Whether it's fixing bugs, suggesting features, or improving docs — you're appreciated.
