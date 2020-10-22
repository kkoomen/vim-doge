#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
cd $ROOT_DIR/bin

# Archive the binaries.
rm -f ./vim-doge-{linux,macos,win.exe}.tar.gz
for file in ./vim-doge-{linux,macos,win.exe}; do
  filename=$(basename "$file")
  echo "==> Archiving $filename -> $filename.tar.gz"
  tar -czf $filename.tar.gz "$filename" > /dev/null 2>&1
done

echo "🎉  Done building vim-doge binaries"
