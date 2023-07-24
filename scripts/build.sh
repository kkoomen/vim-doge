#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
BUILD_TARGET="${1:-}"
OUTFILE="${2:-}"
OS="$(uname)"

CMD="cargo"
if [[ "$OS" != "Darwin" ]] && command -v cross >/dev/null 2>&1; then
  CMD="cross"
fi

cd $ROOT_DIR
[[ ! -d ./bin ]] && mkdir ./bin
[[ -e ./bin/vim-doge-helper ]] && rm -f ./bin/vim-doge-helper

# Build the binary.
cd $ROOT_DIR/helper
if [[ "$BUILD_TARGET" != "" ]]; then
  eval "$CMD build --release --target $BUILD_TARGET"
  cp target/$BUILD_TARGET/release/vim-doge-helper ../bin/
else
  eval "$CMD build --release"
  cp target/release/vim-doge-helper ../bin/
fi

# Archive the binary.
if [[ "$OUTFILE" != "" ]]; then
  OUTFILE="$OUTFILE.tar.gz"

  cd $ROOT_DIR/bin
  rm -f ./*.tar.gz
  echo "==> Archiving $ROOT_DIR/bin/vim-doge-helper -> $ROOT_DIR/bin/$OUTFILE"
  tar -czf "$OUTFILE" vim-doge-helper
fi

echo "🎉  Done building vim-doge-helper"
