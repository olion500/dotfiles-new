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
sh -c "$(curl -fsLS https://raw.githubusercontent.com/olion500/dotfiles/main/scripts/install.sh)"
```

또는 chezmoi가 이미 설치되어 있다면:

```bash
chezmoi init --apply olion500
```

## 로컬 개발

```bash
git clone https://github.com/olion500/dotfiles.git ~/.dotfiles
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
├── Dockerfile              # Docker 테스트용
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

## Docker 테스트

Ubuntu 환경에서 dotfiles를 테스트할 수 있습니다.

### 빠른 테스트 (dry-run)

```bash
make docker-test
```

이 명령은:
1. Ubuntu 24.04 기반 Docker 이미지 빌드
2. chezmoi 설치
3. `chezmoi apply --dry-run` 실행하여 결과 확인

### 대화형 셸로 테스트

```bash
make docker-shell
```

컨테이너 내부에서 직접 테스트:

```bash
# 컨테이너 진입 후
chezmoi init --source=/home/testuser/.local/share/chezmoi
chezmoi apply

# 결과 확인
cat ~/.zshrc
cat ~/.gitconfig
```

### 수동 Docker 명령

```bash
# 이미지 빌드
docker build -t dotfiles-test .

# 테스트 실행
docker run --rm -v "$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test \
    chezmoi apply --dry-run --verbose

# 대화형 셸
docker run -it --rm -v "$(pwd):/home/testuser/.local/share/chezmoi" dotfiles-test
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
