#!/usr/bin/env sh

# For more info about the 'set' command, see
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -e
set -u

if ! which curl > /dev/null 2>&1; then
  echo "curl: command not found" >&2
  echo 'Please make sure that curl is installed and available in your $PATH' >&2
  exit 127
fi

ROOT_DIR=$(cd "$(dirname "$0")/.."; pwd -P)
OUTFILE="./bin/vim-doge-helper"

cd "$ROOT_DIR"

if [ -e "$OUTFILE" ]; then
  rm -f "$OUTFILE"
fi

[ ! -d ./bin ] && mkdir ./bin

OS="$(uname)"
ARCH="$(uname -m)"
APP_VERSION=$(cat "$ROOT_DIR/.version")
RELEASE_URL="https://github.com/kkoomen/vim-doge/releases/download/v$APP_VERSION"

if [ $OS = 'Darwin' ]; then
  if [ $ARCH = 'arm64' ]; then
    TARGET="vim-doge-helper-macos-aarch64"
  else
    TARGET="vim-doge-helper-macos-x86_64"
  fi
elif [ $OS = 'Linux' ]; then
  if [ $ARCH = 'aarch64' ]; then
    TARGET="vim-doge-helper-linux-aarch64"
  else
    TARGET="vim-doge-helper-linux-x86_64"
  fi
else
  echo "vim-doge does not support your system"
  exit 1
fi

ARCHIVE_FILENAME="$TARGET.tar.gz"
DOWNLOAD_URL="$RELEASE_URL/$ARCHIVE_FILENAME"
echo "Downloading $DOWNLOAD_URL"
curl -L --progress-bar \
    --fail \
    --output "$ARCHIVE_FILENAME" \
    "$DOWNLOAD_URL"
tar xzf "$ARCHIVE_FILENAME" && mv "vim-doge-helper" "$OUTFILE"
rm -f "$ARCHIVE_FILENAME"
chmod +x "$OUTFILE"
