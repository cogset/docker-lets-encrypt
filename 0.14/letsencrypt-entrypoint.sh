#!/bin/bash

# Uses tail as default.
if [ "${1#-}" != "$1" ]; then
	set -- tail "$@"
fi

function print_usage {
  echo
  echo "Usage:"
  echo "  [OPTIONS]"
  echo
  echo "Options:"
  echo "  -o, --obtain                    Obtain certs on container starting"
  echo
  echo "  -h, --help                      Print this message"
  echo
}

if [ "$1" != "tail" ]; then
  exec "$@"
fi

shift
OPTIONS=`getopt -o o:h --long obtain,help -n cron -- "$@"`
if [ $? -ne 0 ]; then
  print_usage
  exit 1
fi

OBTAIN=0

eval set -- "$OPTIONS"
while true; do
  case "$1" in
    -o|--obtain)      OBTAIN=1;             shift;;
    --)                                     shift; break;;
    -h|--help)        print_usage;          exit 0;;

    *)
      echo "Unexpected argument: $1"
      print_usage
      exit 1;;
  esac
done

if [ $OBTAIN -eq 1 ]; then
  letsencrypt-obtain.sh
fi

CRON_FILE="/var/log/letsencrypt/cron.log"

if [ ! -f "$CRON_FILE" ]; then
  touch "$CRON_FILE"
fi

echo "3 2 1 * * root letsencrypt-renew.sh >> $CRON_FILE" >> "/etc/crontab"

cron

tail -f "$CRON_FILE"