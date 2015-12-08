#!/bin/bash

if ! [[ "$1" ]]; then
  printf "assembly_format.sh <input file name>, and pipe to an output if necessary\n"
  exit 1
fi

max_code_len=0

# todo put the codes into functions.
# and make it open file only one time. (probably)
while IFS='' read -r line || [[ -n "$line" ]]; do
  # calculate the max width
  # ignore all the lines that starts with ;
  if [[ "$line" =~ ^\; ]] || ! [[ "$line" == *";"* ]]; then
    continue
  fi

  code=$( echo $line | cut -d";" -f1 | sed "s/[[:space:]]*$//")
  comment=$( echo $line | cut -d";" -f2 | sed "s/^\s+//")
  code_len=${#code} 
  comment_len=${#comment} 

  if (( $max_code_len < $code_len )); then
    max_code_len=$code_len
  fi
done < "$1" 

while IFS='' read -r line || [[ -n "$line" ]]; do
  # ignore all the lines that starts with ;
  if [[ "$line" =~ ^\; ]] || ! [[ "$line" == *";"* ]]; then
    printf "$line\n"
    continue
  fi

  code=$( echo $line | cut -d";" -f1 | sed "s/[[:space:]]*$//")
  comment=$( echo $line | cut -d";" -f2 | sed "s/^\s+//")
  code_len=${#code} 
  comment_len=${#comment} 

  printf "$code"
  # echo the max_width
  typeset -i i=0
  req_len=$(( $max_code_len - $code_len + 4))
  while (( $i < $req_len )); do
    printf " "
    (( ++i ))
  done

  printf ";"
  printf "$comment"
  printf "\n"
done < "$1" 
