#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

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
  local AHEAD="%{$fg[blue]%}"
  local UNTRACKED="%{$fg[yellow]%}"
  local RESET="%{$terminfo[sgr0]%}"
  local ahead behind remote
  local -a gitstatus

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
    
    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )

        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )

        echo -n $AHEAD # set color
        
        if [[ $ahead != 0 || $behind != 0 ]]; then
            echo -n " "
        fi
        if [[ $ahead != 0 ]]; then 
            echo -n ↑$ahead
        fi
        if [[ $behind != 0 ]]; then
            echo -n ↓$behind
        fi
    fi
    
    # check if there are untracked files
    local num_untracked=$(git_num_untracked_files)
    if [[ num_untracked -ne 0 ]]; then
        echo -n $UNTRACKED
        echo -n " ⚑"
        echo -n $num_untracked
    fi

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

function git_num_untracked_files() {
  expr `git status --porcelain 2>/dev/null| grep "^??" | wc -l` 
}

bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward


function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg[white]%} [% cmd]% %{$reset_color%}"
    RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(__git_prompt)$EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

PROMPT="
$(ssh_connection)%{$fg_bold[white]%}%n%{$reset_color%}%{$fg[white]%}@%{$fg[white]%}%m %{$fg[green]%}%~
%{$fg[white]%}$ %{$fg[white]%}"

#RPROMPT='$(__git_prompt)$(__time_prompt)'
RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(__git_prompt)$EPS1"
