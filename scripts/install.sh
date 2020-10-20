#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if [[ -e ./bin/vim-doge ]]; then
  rm -f ./bin/vim-doge
fi


ROOT_DIR=$(realpath "$(cd "$(dirname "$0")"; pwd -P)/.."
cd $ROOT_DIR
mkdir ./bin

OS="$(uname)"
OUTFILE="$ROOT_DIR/bin/vim-doge"

PKG_VERSION=$(cat "$ROOT_DIR/.version")
RELEASE_URL="https://github.com/kkoomen/vim-doge/releases/download/$PKG_VERSION"

if [[ $OS == 'Darwin' ]]; then
  TARGET="vim-doge-macos"
elif [[ $OS == 'Linux' ]]; then
  TARGET="vim-doge-linux"
else
  TARGET="vim-doge-win.exe"
  OUTFILE="$OUTFILE.exe"
fi

TEMP_FILE="vim-doge.tar.gz"
DOWNLOAD_URL="$RELEASE_URL/$TARGET.tar.gz"
echo "Downloading $DOWNLOAD_URL"
curl -L --progress-bar \
    --fail \
    --output "$TEMP_FILE" \
    "$DOWNLOAD_URL"
tar xzf "$TEMP_FILE" && mv "$TARGET" "$OUTFILE"
rm -f "$TEMP_FILE"
chmod +x "$OUTFILE"
