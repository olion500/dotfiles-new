# Common aliases
alias v="nvim"
alias c="clear"

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# chezmoi shortcuts
alias cm="chezmoi"
alias cma="chezmoi apply"
alias cmd="chezmoi diff"
alias cme="chezmoi edit"
alias cmu="chezmoi update"

# ls with eza (if available)
if command -v eza &> /dev/null; then
    alias ls="eza"
    alias ll="eza -la --git"
    alias la="eza -a"
    alias lt="eza --tree --level=2"
    alias lta="eza --tree --level=2 -a"
else
    alias ll="ls -la"
    alias la="ls -a"
fi

# Modern CLI tools
if command -v bat &> /dev/null; then
    alias cat="bat --paging=never"
    alias catp="bat"
fi

if command -v fd &> /dev/null; then
    alias find="fd"
fi

if command -v rg &> /dev/null; then
    alias grep="rg"
fi

# lazygit
if command -v lazygit &> /dev/null; then
    alias lg="lazygit"
fi
