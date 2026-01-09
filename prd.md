# Dotfiles PRD (Product Requirements Document)

## 개요

chezmoi를 사용한 크로스 플랫폼 dotfiles 관리 시스템 구축

### 참고 레포지토리
- **베이스**: [shunk031/dotfiles](https://github.com/shunk031/dotfiles)
- **추가 참고**: [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles)

### 목표
- macOS + Ubuntu(WSL) 환경에서 동일한 개발 환경 유지
- 회사/개인 프로필 분리 (런타임 전환)
- 새 머신에서 한 줄 명령으로 환경 구성

---

## 사용 환경

| 항목 | 값 |
|------|-----|
| OS | macOS (Apple Silicon), Ubuntu (WSL2) |
| 쉘 | zsh |
| 에디터 | neovim |
| 터미널 | 기본 터미널 + tmux |
| 주요 도구 | git, zsh, nvim, claude CLI |

---

## 디렉토리 구조

```
dotfiles/
├── .chezmoiroot                         # "home" 지정
├── .gitignore
├── README.md
├── Makefile                             # 개발/테스트 명령어
├── Dockerfile                           # Ubuntu 테스트용
│
├── home/                                # chezmoi 소스 디렉토리
│   ├── .chezmoi.yaml.tmpl               # 초기 설정 템플릿
│   ├── .chezmoiignore                   # 무시할 파일
│   │
│   ├── dot_zshrc.tmpl                   # zsh 설정
│   ├── dot_gitconfig.tmpl               # git 설정
│   ├── dot_vimrc                        # vim 기본 설정
│   │
│   ├── dot_config/                      # ~/.config/
│   │   ├── nvim/
│   │   │   └── init.lua
│   │   ├── starship.toml
│   │   └── claude/
│   │       └── settings.json.tmpl
│   │
│   ├── dot_zsh/                         # ~/.zsh/ (커스텀 설정)
│   │   ├── aliases.zsh
│   │   ├── functions.zsh
│   │   ├── work.zsh                     # 회사 전용
│   │   └── personal.zsh                 # 개인 전용
│   │
│   └── .chezmoiscripts/                 # 설치 스크립트
│       ├── darwin/                      # macOS 전용
│       │   ├── run_once_01-install-homebrew.sh.tmpl
│       │   └── run_once_02-install-packages.sh.tmpl
│       └── linux/                       # Ubuntu 전용
│           ├── run_once_01-install-packages.sh.tmpl
│           └── run_once_02-setup-zsh.sh.tmpl
│
├── scripts/                             # 유틸리티 스크립트
│   └── install.sh                       # 원격 설치 스크립트
│
└── tests/                               # bats 테스트
    └── test_dotfiles.bats
```

---

## 핵심 파일 명세

### 1. `.chezmoiroot`

```
home
```

### 2. `home/.chezmoi.yaml.tmpl`

초기 설정 시 OS 감지 및 사용자 정보 수집

```yaml
{{- $email := promptStringOnce . "email" "이메일 주소" -}}
{{- $name := promptStringOnce . "name" "이름" -}}

sourceDir: {{ .chezmoi.sourceDir | quote }}

data:
  name: {{ $name | quote }}
  email: {{ $email | quote }}
  
  # OS 감지
  ostype: {{ .chezmoi.os | quote }}
  arch: {{ .chezmoi.arch | quote }}
  isMac: {{ eq .chezmoi.os "darwin" }}
  isLinux: {{ eq .chezmoi.os "linux" }}
  
  # WSL 감지
  isWSL: {{ and (eq .chezmoi.os "linux") (or (env "WSL_DISTRO_NAME") (env "WSLENV")) }}
  
  # 호스트명
  hostname: {{ .chezmoi.hostname | quote }}
```

### 3. `home/dot_zshrc.tmpl`

```bash
# ============================================
# 공통 설정
# ============================================
export EDITOR=nvim
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"

# ============================================
# OS별 설정
# ============================================
{{- if .isMac }}
# === macOS ===
export PATH="/opt/homebrew/bin:$PATH"
eval "$(brew shellenv)"
{{- end }}

{{- if .isLinux }}
# === Linux ===
export PATH="$HOME/.linuxbrew/bin:$PATH"
{{- end }}

{{- if .isWSL }}
# === WSL 전용 ===
alias explorer="explorer.exe"
alias code="code.exe"
{{- end }}

# ============================================
# 프롬프트 (Starship)
# ============================================
eval "$(starship init zsh)"

# ============================================
# 도구 초기화
# ============================================
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

# ============================================
# Aliases
# ============================================
source ~/.zsh/aliases.zsh

# ============================================
# 프로필 전환 함수
# ============================================
use-work() {
    export PROFILE="work"
    export GIT_AUTHOR_EMAIL="work@company.com"
    source ~/.zsh/work.zsh
    echo "🏢 회사 모드 활성화"
}

use-personal() {
    export PROFILE="personal"
    export GIT_AUTHOR_EMAIL="{{ .email }}"
    source ~/.zsh/personal.zsh
    echo "🏠 개인 모드 활성화"
}

# 기본값
use-personal
```

### 4. `home/dot_gitconfig.tmpl`

```ini
[user]
    name = {{ .name }}
    email = {{ .email }}

[core]
    editor = nvim
{{- if .isMac }}
    autocrlf = input
{{- end }}
{{- if .isWSL }}
    autocrlf = true
{{- end }}

[init]
    defaultBranch = main

[pull]
    rebase = true

[alias]
    co = checkout
    br = branch
    st = status
    lg = log --oneline --graph --decorate -20

# 디렉토리별 설정 (회사/개인 자동 전환)
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

### 5. `home/dot_zsh/aliases.zsh`

```bash
# 공통 aliases
alias v="nvim"
alias c="clear"
alias ll="eza -la"
alias la="eza -a"
alias lt="eza --tree --level=2"
alias gs="git status"
alias gp="git pull"
alias gP="git push"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gl="git log --oneline -20"

# 디렉토리 이동
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# chezmoi 단축키
alias cm="chezmoi"
alias cma="chezmoi apply"
alias cmd="chezmoi diff"
alias cme="chezmoi edit"
alias cmu="chezmoi update"
```

### 6. `home/dot_zsh/work.zsh`

```bash
# 회사 전용 설정
export WORK_DIR="$HOME/work"
alias cdw="cd $WORK_DIR"

# 프록시 설정 (필요시)
# export HTTP_PROXY="http://proxy.company.com:8080"
# export HTTPS_PROXY="http://proxy.company.com:8080"

# 회사 도구 aliases
# alias vpn="..."
# alias k="kubectl"
```

### 7. `home/dot_zsh/personal.zsh`

```bash
# 개인 전용 설정
export PROJECTS="$HOME/projects"
alias cdp="cd $PROJECTS"

# 개인 도구 aliases
alias dotfiles="chezmoi cd"
```

---

## 설치 스크립트

### 8. `home/.chezmoiscripts/darwin/run_once_01-install-homebrew.sh.tmpl`

```bash
{{- if eq .chezmoi.os "darwin" -}}
#!/bin/bash
set -euo pipefail

echo "🍺 Homebrew 설치 확인..."

if ! command -v brew &> /dev/null; then
    echo "Homebrew 설치 중..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "✅ Homebrew 준비 완료"
{{- end -}}
```

### 9. `home/.chezmoiscripts/darwin/run_once_02-install-packages.sh.tmpl`

```bash
{{- if eq .chezmoi.os "darwin" -}}
#!/bin/bash
set -euo pipefail

echo "📦 macOS 패키지 설치..."

brew install \
    git \
    neovim \
    tmux \
    ripgrep \
    fd \
    fzf \
    zoxide \
    eza \
    bat \
    starship \
    mise \
    lazygit

echo "✅ macOS 패키지 설치 완료"
{{- end -}}
```

### 10. `home/.chezmoiscripts/linux/run_once_01-install-packages.sh.tmpl`

```bash
{{- if eq .chezmoi.os "linux" -}}
#!/bin/bash
set -euo pipefail

echo "📦 Ubuntu 패키지 설치..."

sudo apt update
sudo apt install -y \
    git \
    neovim \
    tmux \
    ripgrep \
    fd-find \
    fzf \
    bat \
    zsh

# starship 설치
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# mise 설치
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
fi

# zoxide 설치
if ! command -v zoxide &> /dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# eza 설치
if ! command -v eza &> /dev/null; then
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

echo "✅ Ubuntu 패키지 설치 완료"
{{- end -}}
```

### 11. `home/.chezmoiscripts/linux/run_once_02-setup-zsh.sh.tmpl`

```bash
{{- if eq .chezmoi.os "linux" -}}
#!/bin/bash
set -euo pipefail

echo "🐚 Zsh 기본 쉘 설정..."

if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "✅ 기본 쉘이 zsh로 변경됨 (재로그인 필요)"
fi
{{- end -}}
```

---

## Neovim 설정

### 12. `home/dot_config/nvim/init.lua`

```lua
-- 기본 설정
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

-- 리더 키
vim.g.mapleader = " "

-- 키맵
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>e", ":Ex<CR>")

-- 추후 플러그인 매니저 (lazy.nvim) 설정 추가
```

---

## Starship 설정

### 13. `home/dot_config/starship.toml`

```toml
format = """
$directory\
$git_branch\
$git_status\
$python\
$nodejs\
$rust\
$golang\
$cmd_duration\
$line_break\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

[git_status]
format = '([$all_status$ahead_behind]($style) )'

[character]
success_symbol = "[❯](green)"
error_symbol = "[❯](red)"

[cmd_duration]
min_time = 2000
format = "[$duration]($style) "
```

---

## 테스트

### 14. `Dockerfile`

```dockerfile
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    zsh \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
ENV PATH="/home/testuser/.local/bin:$PATH"

CMD ["/bin/zsh"]
```

### 15. `Makefile`

```makefile
.PHONY: test diff apply docker watch clean

# dry-run 테스트
test:
	chezmoi apply --dry-run --verbose

# 변경사항 보기
diff:
	chezmoi diff

# 적용
apply:
	chezmoi apply

# Docker 테스트 환경
docker-build:
	docker build -t dotfiles-test .

docker: docker-build
	docker run -it -v "$$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test

# 파일 변경 감지 (watchexec 필요)
watch:
	watchexec -e tmpl,yaml,zsh,lua,toml -- chezmoi apply

# 정리
clean:
	chezmoi purge
```

### 16. `tests/test_dotfiles.bats`

```bash
#!/usr/bin/env bats

setup() {
    export TEST_DIR=$(mktemp -d)
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "chezmoi dry-run succeeds" {
    run chezmoi apply --dry-run --destination "$TEST_DIR"
    [ "$status" -eq 0 ]
}

@test "zshrc template renders" {
    run chezmoi execute-template < home/dot_zshrc.tmpl
    [ "$status" -eq 0 ]
}

@test "gitconfig template renders" {
    run chezmoi execute-template < home/dot_gitconfig.tmpl
    [ "$status" -eq 0 ]
}
```

---

## 설치 방법

### 원격 설치 (새 머신)

```bash
# macOS
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME

# Ubuntu/WSL
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

### 로컬 설치 (개발)

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chezmoi init --source=. --apply
```

---

## 일상 사용

```bash
# 설정 수정
chezmoi edit ~/.zshrc

# 변경사항 확인
chezmoi diff

# 적용
chezmoi apply

# 동기화 (pull + apply)
chezmoi update

# Git 커밋
chezmoi cd
git add -A && git commit -m "update" && git push
```

---

## 프로필 전환 (회사/개인)

```bash
# 터미널에서 실행
use-work      # 🏢 회사 모드
use-personal  # 🏠 개인 모드

# 현재 프로필 확인
echo $PROFILE
```

---

## 구현 체크리스트

- [ ] 기본 디렉토리 구조 생성
- [ ] `.chezmoi.yaml.tmpl` 작성
- [ ] `dot_zshrc.tmpl` 작성
- [ ] `dot_gitconfig.tmpl` 작성
- [ ] macOS 설치 스크립트 작성
- [ ] Ubuntu 설치 스크립트 작성
- [ ] Neovim 기본 설정
- [ ] Starship 설정
- [ ] aliases 정리
- [ ] 회사/개인 프로필 전환 함수
- [ ] Dockerfile 작성
- [ ] Makefile 작성
- [ ] 테스트 작성
- [ ] README.md 작성
- [ ] GitHub Actions CI 설정

---

## 참고 자료

- [chezmoi 공식 문서](https://www.chezmoi.io/)
- [shunk031/dotfiles](https://github.com/shunk031/dotfiles)
- [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles)
- [chezmoi 템플릿 가이드](https://www.chezmoi.io/user-guide/templating/)
