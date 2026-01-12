# Dotfiles TODO

현재 컴퓨터 설정을 분석한 결과, 추가할 수 있는 항목들입니다.

## 현재 상태

### 완료됨
- [x] 기본 zshrc 설정 (history, completion, keybindings)
- [x] Git 기본 설정
- [x] Git aliases (oh-my-zsh 스타일)
- [x] Modern CLI tools aliases (eza, bat, fd, rg, lazygit)
- [x] Homebrew 자동 설치
- [x] 기본 패키지 설치 스크립트
- [x] AstroNvim 설치 스크립트
- [x] 프로필 전환 (work/personal)

## High Priority

### ~~Starship 설정 추가~~ ✅
- [x] `home/dot_config/starship.toml` 추가됨

### Git 설정 개선
기존 `~/dotfiles/gitconfig`에서 가져올 설정들:
- [ ] `push.autoSetupRemote = true`
- [ ] `diff.algorithm = histogram`
- [ ] `branch.sort = -committerdate`
- [ ] `fetch.prune = true`
- [ ] `rebase.autosquash = true`
- [ ] `help.autocorrect = prompt`
- [ ] Git template (ctags hooks)
- [ ] Commit message template (`gitmessage`)

### Tmux 설정 추가
기존 `~/dotfiles/tmux.conf` 활용
```
home/dot_tmux.conf
```
- Vim 키바인딩
- Ctrl+s prefix
- 256 color 지원

## Medium Priority

### Mise 설정 추가
현재 `~/.config/mise/config.toml`:
```toml
[tools]
node = "22"
python = "3.14"
ruby = "3.3"
```

### Ghostty 터미널 설정
현재 설정 없음 - 새로 생성 필요
```
home/dot_config/ghostty/config
```
- 폰트: Hack Nerd Font
- 테마 설정
- 키바인딩

### Karabiner 설정
현재 `~/.config/karabiner/karabiner.json` 있음
- 외장 키보드 Ctrl/Cmd 스왑
- 한영 전환 키 매핑

### lazygit 설정
```
home/dot_config/lazygit/config.yml
```

## Low Priority

### Brewfile 추가
설치할 패키지들을 Brewfile로 관리
```bash
# Formulas
brew "starship"
brew "zoxide"
brew "fzf"
brew "eza"
brew "bat"
brew "fd"
brew "ripgrep"
brew "mise"
brew "neovim"
brew "lazygit"
brew "tmux"

# Casks (macOS only)
cask "ghostty"
cask "raycast"
cask "rectangle"
cask "stats"
cask "alt-tab"
cask "orbstack"
```

### SSH config 템플릿
```
home/dot_ssh/config.tmpl
```
- GitHub/GitLab 설정
- 회사별 설정

### Zsh 함수들 추가
기존 `~/dotfiles/zsh/functions/`에서:
- `g` - git with hub
- `mcd` - mkdir && cd
- `v` - vim with fzf
- `tat` - tmux attach

### 기타
- [ ] `.hushlogin` - 로그인 메시지 숨김
- [ ] `.gitignore` global
- [ ] `.editorconfig`
- [ ] Warp 터미널 설정

## 참고: 현재 설치된 주요 도구들

### CLI Tools (Homebrew)
- bat, fd, ripgrep, eza
- fzf, zoxide
- lazygit, gh
- mise (asdf 대체)
- neovim, tmux

### GUI Apps (Cask)
- ghostty (터미널)
- raycast (런처)
- rectangle (윈도우 관리)
- stats (시스템 모니터)
- alt-tab (윈도우 스위처)
- orbstack (Docker)
- obsidian (노트)

### 개발 환경
- Node.js, Python, Ruby (mise로 관리)
- AWS CLI, Azure CLI, gcloud
- Docker (orbstack)
