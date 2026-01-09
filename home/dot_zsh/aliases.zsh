# Common aliases
alias v="nvim"
alias c="clear"

# Git shortcuts
alias gs="git status"
alias gp="git pull"
alias gP="git push"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gl="git log --oneline -20"

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
    alias ll="eza -la"
    alias la="eza -a"
    alias lt="eza --tree --level=2"
else
    alias ll="ls -la"
    alias la="ls -a"
fi
