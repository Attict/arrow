#!/bin/sh

BASEDIR=$(dirname "$0")

docker-compose down
rm -rf .arrow
arrow get && mkdir -p ./.arrow/build

# Admin dir become /public/admin if client exists

if [ -d "web_client" ]; then
  cd web_client
  pub get
  webdev build
  mv build ../.arrow/build/public
  cd ..
fi

if [ -d "web_admin" ]; then
  cd web_admin
  pub get
  webdev build
  mv build ../.arrow/build/public/admin
  cd ..
fi

cp -r $BASEDIR/../modules ./.arrow/build/modules
rm -rf ./.arrow/build/modules/*/{lib,pubspec.*}

echo "Built files successfully.  Building docker..."

docker-compose build && docker-compose up -d


