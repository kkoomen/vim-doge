#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
TARGET="${1:-}"

# Build the pkg lib prerequisites if needed.
if [[ ! -d $ROOT_DIR/pkg/lib-es5 ]]; then
  cd $ROOT_DIR/pkg
  npm install --no-save && npm run prepare
fi

cd $ROOT_DIR

# Build the binaries.
if [[ "$TARGET" != "" ]]; then
  BUILD_TARGETS="$TARGET"
else
  BUILD_TARGETS="node14-linux-x64,node14-macos-x64,node14-win-x64"
fi
node $ROOT_DIR/pkg/lib-es5/bin.js . -t "$BUILD_TARGETS" --out-path $ROOT_DIR/bin
chmod +x $ROOT_DIR/bin/vim-doge*
