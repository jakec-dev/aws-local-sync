# ==================================================================================== #
# VARIABLES
# ==================================================================================== #

BINARY_NAME 	:= aws-local-sync
BUILD_DIR 		:= bin
MAIN_PACKAGE 	:= ./cmd/$(BINARY_NAME)

VERSION 			:= $(shell git describe --tags --always --dirty)
GIT_COMMIT 		:= $(shell git rev-parse --short HEAD)
BUILD_TIME 		:= $(shell date +%FT%T%z)

LDFLAGS := "-s -w \
    -X 'main.Version=$(VERSION)' \
    -X 'main.GitCommit=$(GIT_COMMIT)' \
    -X 'main.BuildTime=$(BUILD_TIME)'"

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

.PHONY: help
help: ## Show all available make targets with descriptions
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "  ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

# ==================================================================================== #
# SETUP
# ==================================================================================== #

.PHONY: install
install: ## Install all development dependencies, tools, and git hooks
	@echo "Installing development tools..."
	@command -v golangci-lint >/dev/null 2>&1 || \
		(echo "→ Installing golangci-lint..." && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest)
	@command -v lefthook >/dev/null 2>&1 || \
		(echo "→ Installing lefthook..." && go install github.com/evilmartians/lefthook@latest)
	@command -v gitleaks >/dev/null 2>&1 || \
		(echo "→ Installing gitleaks..." && go install github.com/zricethezav/gitleaks/v8@latest)
	@command -v govulncheck >/dev/null 2>&1 || \
		(echo "→ Installing govulncheck..." && go install golang.org/x/vuln/cmd/govulncheck@latest)
	@command -v staticcheck >/dev/null 2>&1 || \
		(echo "→ Installing staticcheck..." && go install honnef.co/go/tools/cmd/staticcheck@latest)
	@command -v go-licenses >/dev/null 2>&1 || \
		(echo "→ Installing go-licenses..." && go install github.com/google/go-licenses@latest)
	@echo "→ Installing git hooks..."
	@lefthook install
	@echo "→ Downloading Go dependencies..."
	@go mod download
	@echo "✓ All development tools and git hooks installed successfully!"

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

.PHONY: lint
lint: ## Run code linters via golangci-lint
	golangci-lint run

.PHONY: audit
audit: test ## Run full audit: verify modules, scan for issues and vulnerabilities
	go mod tidy -diff
	go mod verify
	go vet ./...
	go run honnef.co/go/tools/cmd/staticcheck@latest -checks=all,-ST1000,-U1000 ./...
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...
	@echo "→ Checking for unpinned dependencies..."
	@go list -m -json all | jq -r 'select(.Indirect != true) | select(.Main != true) | "\(.Path) \(.Version)"' || echo "No dependencies found"

.PHONY: test
test: ## Run tests with race detection and generate coverage report (HTML + out)
	go test -v -race -buildvcs -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

.PHONY: upgradeable
upgradeable: ## Show all direct dependencies with available upgrades
	@go list -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}}: {{.Version}} -> {{.Update.Version}}{{end}}' -m all

.PHONY: licenses
licenses: ## Check licenses of all dependencies
	@go-licenses report ./... 2>/dev/null || echo "No dependencies with licenses found"

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

.PHONY: tidy
tidy: ## Clean up go.mod/go.sum and format all Go source files
	go mod tidy -v
	go fmt ./...

.PHONY: build
build: ## Build the Go binary with version, commit, and build time metadata
	go build -trimpath -ldflags $(LDFLAGS) -o ${BUILD_DIR}/${BINARY_NAME} ${MAIN_PACKAGE}

.PHONY: build-static
build-static: ## Build a statically linked binary for release (CGO disabled)
	CGO_ENABLED=0 go build -trimpath -ldflags $(LDFLAGS) \
		-o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PACKAGE)

.PHONY: run
run: build ## Build and run the compiled binary
	${BUILD_DIR}/${BINARY_NAME}

.PHONY: pre-commit
pre-commit: ## Run pre-commit hooks manually on all files
	@lefthook run pre-commit

.PHONY: clean
clean: ## Remove compiled binary, coverage reports, and other build artifacts
	go clean
	rm -rf ${BUILD_DIR} coverage.out coverage.html

# ==================================================================================== #
# RELEASES
# ==================================================================================== #

.PHONY: release
release: ## Create a full GitHub release using GoReleaser (requires a git tag)
	goreleaser release --clean

.PHONY: release-snapshot
release-snapshot: ## Run a local snapshot build (no publishing, useful for testing)
	goreleaser release --snapshot --clean