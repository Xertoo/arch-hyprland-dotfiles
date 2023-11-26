# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/abhinav/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
PS1='Abhinav [%~] '
# Show path in title
precmd() {print -Pn "\e]0;${PWD/$HOME/\~}\a"}

# Colorful messages
e_header() { echo -e "\n\033[1m$@\033[0m"; }
e_success() { echo -e " \033[1;32m✔\033[0m  $@"; }
e_error() { echo -e " \033[1;31m✖\033[0m  $@"; }

setopt auto_cd

# Load dircolors
if [ -s ${ZDOTDIR:-${HOME}}/.dircolors ]; then
  eval $(command dircolors -b ${ZDOTDIR:-${HOME}}/.dircolors)
fi

export PATH=$PATH:/home/abhinav/.spicetify

alias v="nvim"
