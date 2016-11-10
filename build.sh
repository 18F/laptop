#!/bin/bash

# This build script will any binaries that the laptop script needs
# and places them inside the releases folder.
# The binaries will only be targeted to Mac OS X (64-bit)
# After the binaries are compiled, you will need to put them in
# a GitHub Release for them to be publiclly accessible.
set -e

function compile_git_seekrets() {
  if which go > /dev/null; then
    echo "Found Go toolchain"
  else
    echo "Go does not exist. Run 'brew install go'"
    exit 1
  fi
  if which glide > /dev/null; then
    echo "Found glide"
  else
    echo "Glide does not exist. Run 'brew install glide'"
    exit 1
  fi
  # make a go workspace
  export GOPATH=$(mktemp -d)
  # download the code
  go get github.com/apuigsech/git-seekret
  pushd "$GOPATH/src/github.com/apuigsech/git-seekret"
  glide install
  # build it
  GOOS=darwin GOARCH=amd64 go build -o git-seekret-osx
  # place the binary in folder
  mv git-seekret-osx "$BIN_PATH"/git-seekret-osx
  # cleanup workspace
  popd
  rm -rf "$GOPATH"
}

BIN_PATH=$(pwd)/releases/
rm -rf "$BIN_PATH"
mkdir -p "$BIN_PATH"


compile_git_seekrets
