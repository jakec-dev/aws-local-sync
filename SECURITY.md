# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.x.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of aws-local-sync seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### How to Report

Please report security vulnerabilities through GitHub's security advisory feature:

1. Go to the [Security tab](https://github.com/jakec-dev/aws-local-sync/security) of this repository
2. Click on "Report a vulnerability"
3. Fill out the form with details about the vulnerability

### What to Include

Please include the following information:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### Response Timeline

- We will acknowledge receipt of your vulnerability report within 48 hours
- We will send a more detailed response within 5 business days indicating the next steps
- We will keep you informed about the progress towards a fix and full announcement
- We may ask for additional information or guidance during the process

## Security Best Practices

When using aws-local-sync:

1. **AWS Credentials**: Never commit AWS credentials to version control. Use environment variables or AWS credential files
2. **IAM Permissions**: Follow the principle of least privilege when configuring IAM roles and policies
3. **Dependencies**: Keep dependencies up to date using Dependabot alerts
4. **Binary Verification**: Verify checksums of downloaded binaries when available

## Security Updates

Security updates will be released as patch versions and announced through:
- GitHub Releases
- Security Advisories on this repository

## Acknowledgments

We appreciate the security research community's efforts in helping keep aws-local-sync secure. Contributors who report valid security issues will be acknowledged in our release notes (unless they prefer to remain anonymous).