export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8


ZSH_THEME="robbyrussell"

plugins=(git fzf)
source $ZSH/oh-my-zsh.sh

alias ls="colorls -lFh --color=auto"
alias bat="bat --plain --theme=ansi -n"

