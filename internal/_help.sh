#!/bin/sh

help() {
  echo """Manage your Arrow development.

Common commands:

  arrow build <environment>
    Builds for development or production.  Defaults to development.

  arrow clean
    Cleans and removes existing files for a build.  Use -f to clean all.

  arrow help [command]
    Outputs this help, or the given command.

Available commands:
  build                 Build a new version.
  clean                 Cleans old version.
  help                  Outputs this help, or the given command.
  run                   Runs a development build of a sub-project.

Run \"arrow help <command>\" for more information about a command."""
}

help_add() {
  echo """Usage: arrow add <template>

Adds a target template to your project.

Templates:
  web_admin             Admin portal for web.
  web_client            A general purpose client.
  server_main           A general purpose server.

Run \"arrow help -v add\" for more information."""
}

help_clean() {
  echo """Usage: arrow clean <template>

Cleans a target template in your project.

Templates:
  web_admin             Admin portal for web.
  web_client            A general purpose client.
  server_main           A general purpose server.

Run \"arrow help -v clean\" for more information."""
}

help_run() {
  echo """Usage: arrow run

Runs a sub-project for development.

Run \"arrow help -v run\" for more information."""

}

case $1 in
  add)          help_add                ;;
  clean)        help_clean              ;;
  run)          help_run                ;;
  *)            help                    ;;
esac
