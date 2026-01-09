# Dotfiles

chezmoi 기반 크로스 플랫폼 dotfiles 관리

## 지원 환경

| OS | 상태 |
|----|------|
| macOS (Apple Silicon) | O |
| Ubuntu (WSL2) | O |

## 한 줄 설치

### macOS / Linux / WSL

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/scripts/install.sh)"
```

또는 chezmoi가 이미 설치되어 있다면:

```bash
chezmoi init --apply YOUR_USERNAME
```

## 로컬 개발

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chezmoi init --source=. --apply
```

## 사용법

### 일상 명령어

```bash
# 설정 파일 수정
chezmoi edit ~/.zshrc

# 변경사항 확인
chezmoi diff

# 적용
chezmoi apply

# 원격과 동기화 (pull + apply)
chezmoi update
```

### 단축 명령어

| 명령어 | 설명 |
|--------|------|
| `cm` | chezmoi |
| `cma` | chezmoi apply |
| `cmd` | chezmoi diff |
| `cme` | chezmoi edit |
| `cmu` | chezmoi update |

### 프로필 전환

```bash
use-work      # 회사 모드
use-personal  # 개인 모드

echo $PROFILE # 현재 프로필 확인
```

## 구조

```
dotfiles/
├── .chezmoiroot
├── Makefile
├── home/
│   ├── .chezmoi.yaml.tmpl    # 초기 설정
│   ├── .chezmoiignore
│   ├── dot_zshrc.tmpl        # ~/.zshrc
│   ├── dot_gitconfig.tmpl    # ~/.gitconfig
│   └── dot_zsh/              # ~/.zsh/
│       ├── aliases.zsh
│       ├── work.zsh
│       └── personal.zsh
└── scripts/
    └── install.sh
```

## Makefile 명령어

```bash
make test   # dry-run 테스트
make diff   # 변경사항 보기
make apply  # 적용
make clean  # chezmoi 상태 초기화
```

## 커스터마이징

### 회사 설정 추가

`home/dot_zsh/work.zsh` 수정:

```bash
export WORK_DIR="$HOME/work"
export HTTP_PROXY="http://proxy.company.com:8080"
alias k="kubectl"
```

### 디렉토리별 Git 설정

`~/work/` 아래 프로젝트는 자동으로 회사 Git 설정 사용:

```bash
# ~/.gitconfig-work 파일 생성
[user]
    email = work@company.com
```

## 참고

- [chezmoi 공식 문서](https://www.chezmoi.io/)
- [chezmoi 템플릿 가이드](https://www.chezmoi.io/user-guide/templating/)
