#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR="$(cd "$(dirname "$0")"; pwd -P)/../"

if [[ ! -d ./pkg/lib-es5 ]]; then
  cd $ROOT_DIR/pkg
  yarn && yarn prepare
fi

cd $ROOT_DIR
node ./pkg/lib-es5/bin.js . -t node14-linux-x64,node14-macos-x64,node14-win-x64 --out-path ./bin
