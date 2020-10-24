#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
BUILD_TARGETS="${1:-}"
OUTFILE="${2:-}"

# Build the pkg lib prerequisites if needed.
if [[ ! -d $ROOT_DIR/pkg/lib-es5 ]]; then
  cd $ROOT_DIR/pkg
  npm install --no-save && npm run prepare
fi

cd $ROOT_DIR

# Build the binary.
node $ROOT_DIR/pkg/lib-es5/bin.js . -t "$BUILD_TARGETS" --out-path $ROOT_DIR/bin
[[ -f $ROOT_DIR/bin/vim-doge ]] && chmod +x $ROOT_DIR/bin/vim-doge

# Archive the binary.
if [[ "$OUTFILE" != "" ]]; then
  OUTFILE="$OUTFILE.tar.gz"
  cd $ROOT_DIR/bin
  rm -f ./*.tar.gz
  echo "==> Archiving $ROOT_DIR/bin/vim-doge -> $ROOT_DIR/bin/$OUTFILE"
  tar -czf "$OUTFILE" vim-doge
fi

echo "🎉  Done building vim-doge binaries"
