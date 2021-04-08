#!/bin/sh

BASEDIR=$(dirname "$0")

rm -rf .arrow
mkdir .arrow
ln -s $BASEDIR/../modules .arrow/modules

case $1 in
  all)
    if [ -d web_client ]; then
      cd web_client && pub get && cd ..
    fi
    if [ -d web_admin ]; then
      cd web_admin && pub get && cd ..
    fi
    if [ -d server_main ]; then
      cd server_main && go get -v -d . && cd ..
    fi
    ;;

  *)
    ;;
esac

