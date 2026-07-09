# castle

Personal [Homeshick](https://github.com/andsens/homeshick) castle (dotfiles) for macOS.

## Layout

| Path | Role |
|------|------|
| `home/` | Linked into `~` by Homeshick |
| `config/` | Linked as `~/.config` (Karabiner, etc.) |
| `vim/` | Linked as `~/.vim` |
| `oh-my-zsh-custom/` | Linked as `~/.oh-my-zsh-custom` (plugins **cloned** by bootstrap, not vendored) |
| `Brewfile` | Homebrew packages |
| `bootstrap.sh` | Idempotent new-Mac setup |

**Not in this repo:** Oh My Zsh core (`~/.oh-my-zsh`), zsh plugins under `oh-my-zsh-custom/`, tmux TPM plugins, vim-plug `plugged/` trees. Those are installed by `bootstrap.sh` or their own tools.

## New Mac

```bash
# 1) Clone castle (or Homeshick will clone it during bootstrap)
git clone --recursive https://github.com/aikinai/castle.git ~/.homesick/repos/castle

# 2) Run bootstrap (Homebrew, packages, OMZ, plugins, link, TPM, vim, …)
bash ~/.homesick/repos/castle/bootstrap.sh
```

Then open a new terminal (or `exec zsh -l`).

## Day-to-day

```bash
homeshick pull castle
homeshick link castle
brew bundle --file ~/.homesick/repos/castle/Brewfile
```

## Design notes

- **Shell:** zsh + Oh My Zsh + Powerlevel10k + zsh-vi-mode. History is large and shared (`SHARE_HISTORY`).
- **fzf:** Loaded in `zvm_after_init` so vi-mode does not steal keybindings. Uses `fd` for file/dir search.
- **Terminal:** Ghostty config lives under `home/Library/Application Support/com.mitchellh.ghostty/`.
- **tmux:** Prefix `C-a`, vi copy mode, SSH-aware clipboard yank, TPM + themepack.
- **Local overrides:** `~/.vimrc_local` (optional, not in git).

## Optional: Ghostty / tmux terminfo on a remote host

```bash
INF=/opt/homebrew/opt/ncurses/bin/infocmp
[ -x "$INF" ] || INF=/usr/bin/infocmp

$INF -x -A "${TERMINFO}" xterm-ghostty | ssh user@server -- tic -x -
$INF -x tmux-256color | ssh user@server -- tic -x -
```

## Optional: custom ffmpeg (Apple Silicon)

Only if you need a custom build; otherwise `brew install ffmpeg` is enough for many cases.

```bash
diskutil erasevolume APFS 'RAMdisk' "$(hdiutil attach -nobrowse -nomount ram://16777216)"
cd /Volumes/RAMdisk
git clone https://github.com/Vargol/ffmpeg-apple-arm64-build.git
cd ffmpeg-apple-arm64-build && ./build.sh
sudo rsync -vaX out/* /usr/local/
```
