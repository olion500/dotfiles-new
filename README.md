# Dotfiles

chezmoi 기반 크로스 플랫폼 dotfiles 관리

## 지원 환경

- macOS (Apple Silicon)
- Ubuntu (WSL2)

## 설치

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/olion500/dotfiles/main/scripts/install.sh)"
```

또는:

```bash
chezmoi init --apply olion500
```

## 포함 항목

- **Zsh**: history, completion, keybindings 설정
- **Git**: 기본 설정 + 디렉토리별 설정 (`~/work/`)
- **Git aliases**: oh-my-zsh 스타일 (200+ aliases)
- **Modern CLI tools**: eza, bat, fd, rg, lazygit
- **Homebrew**: 자동 설치
- **AstroNvim**: 자동 설치

## 단축 명령어

```bash
# Chezmoi
cm / cma / cmd / cme / cmu

# Git (예시)
gst   # git status
gco   # git checkout
gcm   # git checkout main
gp    # git push
gl    # git pull
glog  # git log --oneline --graph
```

## 프로필 전환

```bash
use-work      # 회사 모드
use-personal  # 개인 모드
```

## 구조

```
home/
├── .chezmoi.yaml.tmpl      # 초기 설정 (OS 감지, 사용자 정보)
├── .chezmoiscripts/        # 자동 실행 스크립트
│   ├── run_once_before_install-homebrew.sh
│   ├── run_once_install-packages.sh
│   └── run_once_after_setup-astronvim.sh
├── dot_zshrc.tmpl          # ~/.zshrc
├── dot_gitconfig.tmpl      # ~/.gitconfig
└── dot_zsh/
    ├── aliases.zsh         # 일반 alias
    ├── git.zsh             # git alias
    ├── work.zsh            # 회사 설정
    └── personal.zsh        # 개인 설정
```

## 테스트

```bash
make test         # dry-run
make diff         # 변경사항 확인
make apply        # 적용
make docker-test  # Ubuntu Docker에서 테스트
```
