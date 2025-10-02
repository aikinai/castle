# ~/.zshrc

# ┌───────────────────────────────────────────────────────────────────┐
# │ P10K INSTANT PROMPT                                               │
# └───────────────────────────────────────────────────────────────────┘
# Enable Powerlevel10k instant prompt. Should stay at the very top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ┌───────────────────────────────────────────────────────────────────┐
# │ OH MY ZSH & PLUGIN CONFIGURATION                                  │
# └───────────────────────────────────────────────────────────────────┘
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"

# Set the ZSH theme.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Define plugins for Oh My Zsh to load.
# zsh-autosuggestions and zsh-syntax-highlighting are now managed here.
plugins=(
  git
  brew
  z
  macos
  zsh-vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Disable Oh My Zsh's automatic LS_COLORS handling so our dircolors setup below
# can take precedence without interference.
DISABLE_LS_COLORS=true

# Source Oh My Zsh. This must come after plugin definitions.
source "$ZSH/oh-my-zsh.sh"

# ┌───────────────────────────────────────────────────────────────────┐
# │ ENVIRONMENT & PATHS                                               │
# └───────────────────────────────────────────────────────────────────┘
# Find Homebrew's prefix dynamically.
if command -v brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"

  # Vim runtime (use version sort for robustness, e.g., 9.10 > 9.2)
  if [[ -d "$HOMEBREW_PREFIX/opt/vim/share/vim" ]]; then
    LATEST_VIM_VERSION=$(ls "$HOMEBREW_PREFIX/opt/vim/share/vim/" | sort -V | tail -n 1)
    export VIMRUNTIME="$HOMEBREW_PREFIX/opt/vim/share/vim/$LATEST_VIM_VERSION/"
  fi

fi

# ┌───────────────────────────────────────────────────────────────────┐
# │ ZSH VI MODE (ZVM)                                                 │
# └───────────────────────────────────────────────────────────────────┘
# This configuration must be sourced before ZVM is loaded by Oh My Zsh.

# Set shift-enter to 'escape' in vi mode.
ZVM_VI_ESCAPE_BINDKEY="^J"

# Let the plugin manage cursor shape.
ZVM_CURSOR_STYLE_ENABLED=true

# zvm_config() is automatically called by the plugin after it loads.
zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
}

# Wrap ZVM's cursor codes for tmux compatibility.
if [[ -n "$TMUX" ]]; then
  function zvm_tmux_cursor_wrapper() {
    printf '\ePtmux;\e%s\e\\' "$1"
  }
  zvm_cursor_style_beam() { zvm_tmux_cursor_wrapper "$ZVM_CURSOR_STYLE_BEAM_ESC"; }
  zvm_cursor_style_block() { zvm_tmux_cursor_wrapper "$ZVM_CURSOR_STYLE_BLOCK_ESC"; }
  zvm_cursor_style_underline() { zvm_tmux_cursor_wrapper "$ZVM_CURSOR_STYLE_UNDERLINE_ESC"; }
fi

# ┌───────────────────────────────────────────────────────────────────┐
# │ ALIASES & FUNCTIONS                                               │
# └───────────────────────────────────────────────────────────────────┘
# Use GNU coreutils `gcal` if available.
if command -v gcal &>/dev/null; then
  alias cal='gcal'
fi

# Setup `dircolors` for `ls` if available.
if command -v dircolors &>/dev/null; then
  if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# Custom `ls` function that respects a ~/.lsignore file.
# This function is superior to a simple alias.
ls() {
  local ignores=()
  if [[ -f ~/.lsignore ]]; then
    while IFS= read -r line; do
      [[ -n "$line" ]] && ignores+=("--ignore=$line")
    done < ~/.lsignore
  fi
  # Always pass standard flags for color and human-readable sizes.
  command ls --color=auto -h "${ignores[@]}" "$@"
}

# ┌───────────────────────────────────────────────────────────────────┐
# │ FRAMEWORKS & UI                                                   │
# └───────────────────────────────────────────────────────────────────┘
# Source Powerlevel10k configuration.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source fzf configuration.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configure fzf to use `fd` for better performance and features.
export FZF_DEFAULT_COMMAND='fd --type f --follow --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --follow --strip-cwd-prefix --hidden --exclude .git'

# Homeshick (Dotfile manager)
if [ -d ~/.homesick/repos/homeshick ]; then
  source ~/.homesick/repos/homeshick/homeshick.sh
  alias homesick="homeshick"
fi
