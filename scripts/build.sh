#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR=$(realpath "$(cd "$(dirname "$0")"; pwd -P)/..")

# Build the pkg lib prerequisites if needed.
if [[ ! -d $ROOT_DIR/pkg/lib-es5 ]]; then
  cd $ROOT_DIR/pkg
  npm install --no-save && npm run prepare
fi

cd $ROOT_DIR

# Build the binaries.
BUILD_TARGETS="node14-linux-x64,node14-macos-x64,node14-win-x64"
node $ROOT_DIR/pkg/lib-es5/bin.js . -t "$BUILD_TARGETS" --out-path $ROOT_DIR/bin
chmod +x $ROOT_DIR/bin/vim-doge*

# Archive the binaries.
cd $ROOT_DIR/bin
rm -f $ROOT_DIR/bin/vim-doge-{linux,macos,win.exe}.tar.gz
for file in ./vim-doge-{linux,macos,win.exe}; do
  filename=$(basename "$file")
  echo "==> Archiving $filename -> $filename.tar.gz"
  tar -czf $filename.tar.gz "$filename" > /dev/null 2>&1
done

echo "🎉  Done building vim-doge binaries"
