#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

echo "System info:"
uname -a

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
OUTFILE="${1:-}"

cd $ROOT_DIR
[[ ! -d ./bin ]] && mkdir ./bin
[[ -e ./bin/vim-doge ]] && rm -f ./bin/vim-doge

# Build the binary.
npx caxa --input "$ROOT_DIR/build" --output "./bin/vim-doge" -- "{{caxa}}/node_modules/.bin/node" "{{caxa}}/index.js"

# Archive the binary.
if [[ "$OUTFILE" != "" ]]; then
  OUTFILE="$OUTFILE.tar.gz"
  cd $ROOT_DIR/bin
  rm -f ./*.tar.gz
  echo "==> Archiving $ROOT_DIR/bin/vim-doge -> $ROOT_DIR/bin/$OUTFILE"
  tar -czf "$OUTFILE" vim-doge
fi

echo "🎉  Done building vim-doge binaries"
