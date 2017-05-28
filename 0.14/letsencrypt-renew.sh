#!/bin/bash

. letsencrypt-functions.sh

CONF_FILE="/etc/letsencrypt.conf"

sections=`get_sections "$CONF_FILE"`

for section in $sections
do

  options=`get_field "$CONF_FILE" "$section" "renew"`

  if [ -z "$options" ]; then
    continue
  fi

  letsencrypt-auto certonly "$options" -n -q --agree-tos

done