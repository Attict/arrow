#!/bin/sh

BASEDIR=$(dirname "$0")

while getopts ":c:" opt; do
  case $opt in
    c)
      shift
      sh $BASEDIR/_clean.sh $@
      ;;
  esac
done

case $1 in
  server_main)
    if [ -z $2 ]; then
      cd server_main && go run main.go -e dev
    else
      cd server_main && go run main.go -e $2
    fi
    ;;
  web_admin)
    cd web_admin && webdev serve web:4900
    ;;
  web_client)
    cd web_client && webdev serve web:4800
    ;;
  *)
    sh $BASEDIR/_help.sh run
    ;;
esac
