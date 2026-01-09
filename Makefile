.PHONY: test diff apply clean docker-build docker-test docker-shell

# Dry-run test
test:
	chezmoi apply --dry-run --verbose

# Show diff
diff:
	chezmoi diff

# Apply changes
apply:
	chezmoi apply

# Purge chezmoi state
clean:
	chezmoi purge

# =====================
# Docker testing
# =====================

# Build test image
docker-build:
	docker build -t dotfiles-test .

# Run tests in container (non-interactive)
docker-test: docker-build
	docker run --rm -v "$$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test \
		chezmoi apply --dry-run --verbose

# Interactive shell in container
docker-shell: docker-build
	docker run -it --rm -v "$$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test
