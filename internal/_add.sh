#!/bin/sh

BASEDIR=$(dirname "$0")

if [ -z "$1" ] || [ "$1" = "app" ] || [ ! -d "$BASEDIR/../templates/$1" ]
then
  sh $BASEDIR/_help.sh add
  exit 1
fi

cp -r $BASEDIR/../templates/$1 ./$1


