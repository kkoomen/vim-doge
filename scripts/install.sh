#!/usr/bin/env bash

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if [[ -e ./bin/vim-doge ]]; then
  rm -f ./bin/vim-doge
fi


ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
cd $ROOT_DIR
[[ ! -d ./bin ]] && mkdir ./bin

OS="$(uname)"
OUTFILE="$ROOT_DIR/bin/vim-doge"
PKG_VERSION=$(cat "$ROOT_DIR/.version")
RELEASE_URL="https://github.com/kkoomen/vim-doge/releases/download/$PKG_VERSION"

if [[ $OS == 'Darwin' ]]; then
  TARGET="vim-doge-macos"
elif [[ $OS == 'Linux' ]]; then
  TARGET="vim-doge-linux"
else
  TARGET="vim-doge-win"
  OUTFILE="$OUTFILE.exe"
fi

FILENAME="$TARGET.tar.gz"
DOWNLOAD_URL="$RELEASE_URL/$FILENAME"
echo "Downloading $DOWNLOAD_URL"
curl -L --progress-bar \
    --fail \
    --output "$FILENAME" \
    "$DOWNLOAD_URL"
tar xzf "$FILENAME" && mv "vim-doge" "$OUTFILE"
rm -f "$FILENAME"
chmod +x "$OUTFILE"
