#!/bin/sh

BASEDIR=$(dirname "$0")

web_clean() {
  pub run build_runner clean
}

case $1 in
  web_admin)
    cd web_admin && web_clean
    ;;
  web_client)
    cd web_client && web_clean
    ;;
  server_main)
    sh $BASEDIR/_clean.sh db
    ;;
  db)
    dropdb arrow_api && createdb arrow_api
    ;;
  *)
    sh $BASEDIR/_help.sh clean
    ;;
esac
