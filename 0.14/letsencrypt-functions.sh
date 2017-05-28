#!/bin/bash

function get_sections
{
  if [ ! -f $1 ]; then
    return 1
  fi

  cat $1 | while read line
  do
    if [[ $line =~ \[.*\] ]]; then
      section=${line##[}
      echo ${section%%]}
    fi
  done

  return 0
}

function get_field
{
  if [ ! -f $1 ]; then
    return 1
  fi

  in_section=0

  cat $1 | while read line
  do

    if [ "X$line" = "X[$2]" ]; then
      in_section=1
      continue
    fi

    if [ $in_section -eq 1 ]; then
      in_section=$(echo $line | awk 'BEGIN{ret=1} /^\[.*\]$/{ret=0} END{print ret}')

      if [ $in_section -ne 1 ]; then
				break
			fi

			need_ignore=$(echo $line | awk 'BEGIN{ret=0} /^#/{ret=1} /^$/{ret=1} END{print ret}')
			if [ $need_ignore -eq 1 ]; then
				continue
			fi

			field=$(echo $line | awk -F= '{sub(/^[ |\t]*/,"",$1); sub(/[ |\t]*$/,"",$1); print $1}')
			value=$(echo $line | awk -F= '{sub(/^[ |\t]*/,"",$2); sub(/[ |\t]*$/,"",$2); print $2}')

			if [ "$field" = "$3" ]; then
				echo $value
			fi

    fi

  done

  return 0
}