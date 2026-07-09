# Login shells: full PATH (personal + GNU utils on top of brew shellenv).
if [[ -f "$HOME/.zsh/paths.zsh" ]]; then
  source "$HOME/.zsh/paths.zsh"
fi

export LANG=en_US.UTF-8
export EDITOR=vim
