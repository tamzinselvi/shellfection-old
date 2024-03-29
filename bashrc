# Load aliases
source ~/.aliasrc

# {{{ bash settings
# }}}

# {{{ Prompt
# {{{ Custom symbols
POWERLINE="1"

if [ "$POWERLINE" = "1" ]; then
  LSEP1='\xee\x82\xb0' # left thick seperator
  LSEP2='\xE2\xAE\x81\x00' # left thin seperator
  RSEP1='\xee\x82\xb2' # right thick seperator
  RSEP2='\xE2\xAE\x83\x00' # right thin seperator
else
  LSEP1=''
  LSEP2=''
  RSEP1=''
  RSEP2=''
fi
# }}}

# {{{ Status info
info-status (){
  STATUS=$?
  if [ "$STATUS" == "0" ]; then
    echo -ne "\[\e[30;42m\] + \[\e[0m\]\[\e[32m\]$LSEP1"
  else
    echo -ne "\[\e[30;41m\] \[\e[0m\]\[\e[41m\]$STATUS \[\e[0m\]\[\e[31m\]$LSEP1"
  fi
}
# }}}

# {{{ User info
function info-user(){
  if [ $(id -u) != 0 ]; then
    echo -ne "\[\e[1;34m\]\u\[\e[1;30m\]@\[\e[1;34m\]\h\[\e[0m\] \[\e[30;44m\]$LSEP1 \[\e[0m\]\[\e[44m\]\W \[\e[0m\]\[\e[34m\]$LSEP1"
  else
    echo -ne "\[\e[1;31m\]\u\[\e[1;30m\]@\[\e[1;31m\]\h\[\e[0m\] \[\e[30;44m\]$LSEP1 \[\e[0m\]\[\e[44m\]\W \[\e[0m\]\[\e[34m\]$LSEP1"
  fi
}
# }}}

# {{{ Git info
function info-git(){
  branch=$(git symbolic-ref HEAD 2>/dev/null | sed "s/refs\/heads\///g")
  if [[ -n "$branch" ]]; then
    changes=$(git status --porcelain 2>/dev/null | grep '^?? ')
    commits=$(git status --porcelain 2>/dev/null | grep -v '^?? ')
    symbol=""
    if [[ -n "$commits" ]]; then
      symbol+="!"
    else
      symbol+="."
    fi
    if [[ -n "$changes" ]]; then
      symbol+="?"
    else
      symbol+="."
    fi
    if [[ -n "$symbol" ]]; then
      if [ ! "$symbol" = ".." ]; then
        echo -ne "\[\e[31m\]$RSEP1\[\e[0m\]\[\e[41m\] $symbol \[\e[0m\]\[\e[32;41m\]$RSEP1\[\e[0m\]\[\e[30;42m\] $branch "
      else
        echo -ne "\[\e[32m\]$RSEP1\[\e[0m\]\[\e[30;42m\] $branch "
      fi
    fi
  fi
}

function calculate-compensate(){
  branch=$(git symbolic-ref HEAD 2>/dev/null | sed "s/refs\/heads\///g")
  if [[ -n "$branch" ]]; then
    changes=$(git status --porcelain 2>/dev/null | grep '^?? ')
    commits=$(git status --porcelain 2>/dev/null | grep -v '^?? ')
    symbol=""
    if [[ -n "$commits" ]]; then
      symbol+="!"
    else
      symbol+="."
    fi
    if [[ -n "$changes" ]]; then
      symbol+="?"
    else
      symbol+="."
    fi
    if [[ -n "$symbol" ]]; then
      if [ ! "$symbol" = ".." ]; then
        echo 87
      else
        echo 44
      fi
    fi
  else
    echo 0
  fi
}
# }}}

function prompt_right() {
  right=$(info-git)
  echo -e "\033[0;36m$right\033[0m"
}

function prompt_left() {
  status=$(info-status)
  user=$(info-user)
  left="$status\[\e[0m\] $user\[\e[0m\]"
  echo -e "\033$left\033[0m"
}

function prompt() {
  prompt_right=$(prompt_right)
  prompt_left=$(prompt_left)
  compensate=$(calculate-compensate)
  PS1=$(printf "\n%*s\r%s\n\[\e[1;30m\]#\[\e[0m\] " "$(($(tput cols)+$compensate))" "$prompt_right" "$prompt_left")
}

PROMPT_COMMAND=prompt
# }}}

# {{{ Local
. ~/.bashrc.local
# }}}
