.PHONY: help test diff apply clean docker-build docker-test docker-shell

help: ## Show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Chezmoi

test: ## Dry-run test
	chezmoi apply --dry-run --verbose

diff: ## Show diff
	chezmoi diff

apply: ## Apply changes
	chezmoi apply

clean: ## Purge chezmoi state
	chezmoi purge

##@ Docker

docker-build: ## Build test image
	docker build -t dotfiles-test .

docker-test: docker-build ## Run tests in container (non-interactive)
	docker run --rm -v "$$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test \
		sh -c 'mkdir -p ~/.config/chezmoi && printf "data:\n  name: Test User\n  email: test@example.com\n  ostype: linux\n  arch: amd64\n  isMac: false\n  isLinux: true\n  isWSL: false\n  hostname: test-container\n" > ~/.config/chezmoi/chezmoi.yaml && chezmoi apply --dry-run --verbose'

docker-shell: docker-build ## Interactive shell in container
	docker run -it --rm -v "$$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test /bin/zsh
