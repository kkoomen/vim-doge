#!/usr/bin/env sh

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if which curl 2>&1 > /dev/null
then
  continue
else
  echo "curl: command not found" >&2
  echo 'Please make sure that curl is installed and available in your $PATH' >&2
  exit 127
fi

if [ -e ./bin/vim-doge ]; then
  rm -f ./bin/vim-doge
fi


ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
cd "$ROOT_DIR"
[ ! -d ./bin ] && mkdir ./bin

OS="$(uname)"
OUTFILE="$ROOT_DIR/bin/vim-doge"
PKG_VERSION=$(cat "$ROOT_DIR/.version")
RELEASE_URL="https://github.com/kkoomen/vim-doge/releases/download/$PKG_VERSION"

if [ $OS = 'Darwin' ]; then
  TARGET="vim-doge-macos"
elif [ $OS = 'Linux' ]; then
  TARGET="vim-doge-linux"
else
  echo "vim-doge does not support your system"
  exit 1
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
