.PHONY: test diff apply clean

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
