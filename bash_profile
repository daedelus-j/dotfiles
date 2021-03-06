
#source ~/.bash/path.sh
#source ~/.bash/env.sh

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/bookmarks
source ~/.bash/functions.sh
source ~/.bash/prompt
source ~/.bash/profile
source ~/.bash/extras

export NODE_ENV=local

#function parse_git_dirty {
#  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
#}

#function parse_git_branch {
#  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
#  echo " ("${ref#refs/heads/}$(parse_git_dirty)")"
#  }

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
