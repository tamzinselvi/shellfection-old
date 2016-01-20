# Helpers for formatting

textwrap() {
  words=$2
  count=0
  iter=0
  for word in $words; do
    wordlen=$( expr "${word}" : '.*' )
    if [ $iter == 0 ]; then
      msg=$word
      let count=count+wordlen
    else
      if [ $( expr $count + 1 + $wordlen ) -gt $DividerWidth ]; then
        $1 "$msg"
        count=$wordlen
        msg=$word
      else
        let count=count+wordlen+1
        msg=$( printf "$msg $word" )
      fi
    fi
    let iter=iter+1
  done
  $1 "$msg"
}

center() {
  msg=$1
  msglen=$( expr "${msg}" : '.*' )
  let msglen=DividerWidth/2-msglen/2
  eval "printf ' %.0s' {1..$msglen}"
  printf "$msg\n"
}

nl() {
  printf "\n"
}
