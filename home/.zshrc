# ~/.zshrc

# ┌───────────────────────────────────────────────────────────────────┐
# │ P10K INSTANT PROMPT                                               │
# └───────────────────────────────────────────────────────────────────┘
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Login shells already load this from .zprofile; tmux/non-login need it too.
[[ -f "$HOME/.zsh/paths.zsh" ]] && source "$HOME/.zsh/paths.zsh"

# ┌───────────────────────────────────────────────────────────────────┐
# │ HISTORY                                                           │
# └───────────────────────────────────────────────────────────────────┘
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY APPEND_HISTORY EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY

# ┌───────────────────────────────────────────────────────────────────┐
# │ OH MY ZSH                                                         │
# └───────────────────────────────────────────────────────────────────┘
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  brew
  z
  macos
  zsh-vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Let our dircolors setup win over OMZ's LS_COLORS handling.
DISABLE_LS_COLORS=true

# Grok CLI (fpath must be set before Oh My Zsh runs compinit).
export PATH="$HOME/.grok/bin:$PATH"
[[ -d "$HOME/.grok/completions/zsh" ]] && fpath=("$HOME/.grok/completions/zsh" $fpath)

# ┌───────────────────────────────────────────────────────────────────┐
# │ ZSH VI MODE — configure before the plugin loads                   │
# └───────────────────────────────────────────────────────────────────┘
ZVM_VI_ESCAPE_BINDKEY="^J"
ZVM_CURSOR_STYLE_ENABLED=true

zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
}

# fzf keybindings must load after zsh-vi-mode or they get overwritten.
zvm_after_init_commands+=('_castle_load_fzf')
_castle_load_fzf() {
  if [[ -f "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
  elif [[ -n "$HOMEBREW" && -f "$HOMEBREW/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "$HOMEBREW/opt/fzf/shell/completion.zsh" 2>/dev/null
    source "$HOMEBREW/opt/fzf/shell/key-bindings.zsh"
  fi
}

# Cursor shape sequences need tmux wrapping when inside tmux.
if [[ -n "$TMUX" ]]; then
  function zvm_tmux_cursor_wrapper() {
    printf '\ePtmux;\e%s\e\\' "$1"
  }
  zvm_cursor_style_beam() { zvm_tmux_cursor_wrapper "$ZVM_CURSOR_STYLE_BEAM_ESC"; }
  zvm_cursor_style_block() { zvm_tmux_cursor_wrapper "$ZVM_CURSOR_STYLE_BLOCK_ESC"; }
  zvm_cursor_style_underline() { zvm_tmux_cursor_wrapper "$ZVM_CURSOR_STYLE_UNDERLINE_ESC"; }
fi

source "$ZSH/oh-my-zsh.sh"

# ┌───────────────────────────────────────────────────────────────────┐
# │ ENVIRONMENT                                                       │
# └───────────────────────────────────────────────────────────────────┘
if [[ -n "$HOMEBREW" && -d "$HOMEBREW/opt/vim/share/vim" ]]; then
  LATEST_VIM_VERSION=$(ls "$HOMEBREW/opt/vim/share/vim/" | sort -V | tail -n 1)
  export VIMRUNTIME="$HOMEBREW/opt/vim/share/vim/$LATEST_VIM_VERSION/"
fi

# ┌───────────────────────────────────────────────────────────────────┐
# │ ALIASES & FUNCTIONS                                               │
# └───────────────────────────────────────────────────────────────────┘
if command -v dircolors &>/dev/null; then
  if [[ -f ~/.dircolors ]]; then
    eval "$(dircolors ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# GNU ls with optional ~/.lsignore patterns (requires coreutils on PATH).
ls() {
  local ignores=()
  if [[ -f ~/.lsignore ]]; then
    while IFS= read -r line; do
      [[ -n "$line" ]] && ignores+=("--ignore=$line")
    done < ~/.lsignore
  fi
  command ls --color=auto -h "${ignores[@]}" "$@"
}

# ┌───────────────────────────────────────────────────────────────────┐
# │ FRAMEWORKS & UI                                                   │
# └───────────────────────────────────────────────────────────────────┘
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export FZF_DEFAULT_COMMAND='fd --type f --follow --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --follow --strip-cwd-prefix --hidden --exclude .git'

if [[ -d ~/.homesick/repos/homeshick ]]; then
  source ~/.homesick/repos/homeshick/homeshick.sh
  alias homesick=homeshick
fi
