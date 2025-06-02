# Release Setup Guide

This guide helps maintainers set up secure release processes for the project.

## GitHub Repository Settings

### 1. Branch Protection Rules

Go to Settings → Branches → Add rule

For `master` branch:
- ✅ Require a pull request before merging
  - ✅ Require approvals (1 or more)
  - ✅ Dismiss stale pull request approvals when new commits are pushed
- ✅ Require status checks to pass before merging
  - ✅ Require branches to be up to date before merging
  - Add required status checks: `test`, `lint`, `audit`
- ✅ Require conversation resolution before merging
- ✅ Include administrators
- ✅ Restrict who can push to matching branches
  - Add specific users/teams who can merge

### 2. Tag Protection Rules (Rulesets)

Go to Settings → Rules → Rulesets → New ruleset → Tag

Create a ruleset named "Release Tags":
- **Enforcement status**: Active
- **Target tags**: `v*`
- **Rules**:
  - ✅ Restrict creations
  - ✅ Restrict deletions
  - ✅ Restrict updates
- **Bypass list**:
  - Add: `github-actions[bot]`
  - This allows only our release workflow to create tags

### 3. Actions Permissions

Go to Settings → Actions → General

- **Actions permissions**: Allow all actions and reusable workflows
- **Workflow permissions**: Read repository contents and packages
- ✅ Allow GitHub Actions to create and approve pull requests

### 4. Environments (Optional)

For additional security, create a `release` environment:

Go to Settings → Environments → New environment

- **Name**: `release`
- **Deployment branches**: Selected branches → `master`
- **Environment protection rules**:
  - ✅ Required reviewers (add maintainers)
  - ✅ Prevent self-review

Then update `release-manual.yml` to use the environment:
```yaml
jobs:
  release:
    environment: release  # Add this line
    # ... rest of job
```

## Release Workflow

### For Maintainers

1. **Prepare for release**:
   ```bash
   # Ensure you're on master with latest changes
   git checkout master
   git pull origin master
   
   # Review changes since last release
   git log --oneline $(git describe --tags --abbrev=0)..HEAD
   ```

2. **Create release**:
   - Go to Actions tab in GitHub
   - Select "Release (Manual)" workflow
   - Click "Run workflow"
   - Enter version (e.g., `v1.0.0`)
   - Choose draft option
   - Click "Run workflow"

3. **Monitor release**:
   - Watch the workflow progress
   - Check for any failures
   - Review the draft release when complete

4. **Publish release**:
   - Go to Releases tab
   - Review the draft release
   - Edit release notes if needed
   - Click "Publish release"

### Version Guidelines

Follow [Semantic Versioning](https://semver.org/):

- `v1.0.0` - First stable release
- `v1.0.1` - Patch release (bug fixes)
- `v1.1.0` - Minor release (new features, backwards compatible)
- `v2.0.0` - Major release (breaking changes)
- `v1.0.0-rc1` - Release candidate
- `v1.0.0-beta.1` - Beta release

### Emergency Procedures

If something goes wrong:

1. **Failed release workflow**:
   - Check Actions logs for errors
   - Fix issues and re-run workflow
   - If tag was created, delete it: `git push --delete origin vX.Y.Z`

2. **Wrong version released**:
   - Do NOT delete published releases
   - Create a new patch version with fixes
   - Document the issue in release notes

3. **Security issue in release**:
   - Immediately create a security advisory
   - Prepare a patch release
   - Follow responsible disclosure practices
Unexpected value 'continue-on-error'
## Monitoring

### OpenSSF Scorecard

Monitor the project's security score:
- Check: https://scorecard.dev/viewer/?uri=github.com/jakec-dev/aws-local-sync
- Key metrics:
  - Signed-Releases: Should be 10/10 with SLSA provenance
  - Branch-Protection: Should be high with proper rules
  - Token-Permissions: Should be high with minimal permissions

### Release Artifacts

Each release should include:
- Binary archives for all platforms
- `_checksums.txt` - List of SHA256 checksums
- `_checksums.txt.sig` - Cosign signature
- `_checksums.txt.pem` - Cosign certificate
- `.sbom.json` files - Software Bill of Materials
- `.intoto.jsonl` - SLSA provenance (uploaded separately)

## Troubleshooting

### Common Issues

1. **"Tag already exists" error**:
   - Someone pushed a tag manually
   - Delete the tag and use the workflow

2. **Cosign signing timeout**:
   - This happens in local testing
   - In GitHub Actions, it uses OIDC automatically

3. **Missing artifacts**:
   - Check if syft is installed
   - Verify GoReleaser configuration
   - Check workflow permissions

4. **SLSA provenance generation fails (exit code 27)**:
   - This is caused by external Rekor service unavailability
   - Our workflows use `compile-generator: true` to avoid this dependency
   - The generated provenance is still valid and secure

### Getting Help

- GoReleaser docs: https://goreleaser.com
- SLSA docs: https://slsa.dev
- OpenSSF Scorecard: https://scorecard.dev