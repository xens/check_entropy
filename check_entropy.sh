#!/bin/bash
###########
# 2015.06.02 romain.aviolat@nagra.com - initial file creation
# check the amount of entropy available on the system

entropy_pool="/proc/sys/kernel/random/entropy_avail"

help="Usage: $0 -c <critical> -w <warning>"

while getopts 'c:w:' opt; do
  case $opt in
    c)
      critical="${OPTARG}"
      ;;
    w)
      warning="${OPTARG}"
      ;;
    \?|:)
      echo ${help}
      exit 3
      ;;
  esac
done

# standard Icinga / Nagios plugin return codes.
STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_UNKNOWN=3

value=$(cat $entropy_pool)

# check that critical and warning values where correctly set
if [ -z ${warning} ] || [ -z ${critical} ]  || [ "$critical" -gt "$warning" ] ; then
  echo ${help}
  exit 3
fi

# compare the entropy to the critical and warning values
if [ "$value" -lt "$warning" ]; then
 
  if [ "$value" -lt "$critical" ]; then
    echo "CRITICAL - entropy is $value|entropy=$value;;;;"
    exit 2
 
  else
    echo "WARNING - entropy is $value|entropy=$value;;;;"
    exit 1
  fi  

else
  echo "OK - Entropy is $value|entropy=$value;;;;"
  exit 0

fi

