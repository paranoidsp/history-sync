###
# James Fraser
# <wulfgar.pro@gmail.com>
###

autoload -U colors
colors

# Kill process group on SIGTERM
#trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

ZSH_HISTORY_FILE=$HOME/.zsh_history
ZSH_HISTORY_PROJ=$HOME/.zsh_history_proj
ZSH_HISTORY_FILE_ENC=$ZSH_HISTORY_PROJ/zsh_history
GIT_COMMIT_MSG="latest $(date)"

# Backup; how about rotate?
cp -a $HOME/{.zsh_history,.zsh_history.backup}


# Pull down current history and merge; how to merge?
function history-sync-pull() {
}

# Push current history to master
history-sync-push() {
  echo -n "Please enter GPG recipient name: "
  read name

  if [[ -n $name ]]; then
    gpg -v -r $NAME --encrypt --sign --armor --output $ZSH_HISTORY_FILE_ENC $ZSH_HISTORY_FILE

    # Failed gpg
    if [[ $? != 0 ]]; then
      echo "$bold_color$fg[red]GPG failed to encrypt history file... exiting.${reset_color}"; return 
    fi

    echo -n "$bold_color$fg[yellow]Do you want to commit/push current local history file? ${reset_color}"
    read commit    
    if [[ -n $commit ]]; then
      case $commit in
        [Yy]* ) 
          cd $ZSH_HISTORY_PROJ && git commit -am $GIT_COMMIT_MSG && git push
          if [[ $? -ne 0 ]]; then 
            echo "$bold_color$fg[red]Fix your git repo...${reset_color}"; return
          fi
          ;;
        [Nn]* )
          ;;
        * )
          ;;
      esac          
    fi
  fi
}

# Function aliases
alias zhpl=history-sync-pull
alias zhps=history-sync-push
alias zhsync=history-sync-pull && history-sync-push

