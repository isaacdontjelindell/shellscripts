#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
PROMPT="
$(ssh_connection) %{$fg_bold[white]%}%n%{$reset_color%}%{$fg[white]%}@%{$fg[white]%}%m %{$fg[green]%}%~
%{$fg[white]%}$ %{$fg[white]%}"


ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

setopt prompt_subst
autoload colors zsh/terminfo
colors
 
function __git_prompt {
  local DIRTY="%{$fg[red]%}"
  local CLEAN="%{$fg[green]%}"
  local UNMERGED="%{$fg[yellow]%}"
  local RESET="%{$terminfo[sgr0]%}"
  git rev-parse --git-dir >& /dev/null
  if [[ $? == 0 ]]
  then
    echo -n "["
    if [[ `git ls-files -u >& /dev/null` == '' ]]
    then
      git diff --quiet >& /dev/null
      if [[ $? == 1 ]]
      then
        echo -n $DIRTY
      else
        git diff --cached --quiet >& /dev/null
        if [[ $? == 1 ]]
        then
          echo -n $DIRTY
        else
          echo -n $CLEAN
        fi
      fi
    else
      echo -n $UNMERGED
    fi
    echo -n `git branch | grep '* ' | sed 's/..//'`
    echo -n $RESET
    echo -n "]"
  fi
}
 
function __time_prompt {
    echo -n "%{$fg[white]%}[%D{%-l:%M %p}]%{$reset_color%}"
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh) "
  fi
}


RPROMPT='$(__git_prompt)$(__time_prompt)'
