#!/bin/sh

#set -e

CURRENT_DIR=$PWD
# locate
if [ -z "$BASH_SOURCE" ]; then
    SCRIPT_DIR=`dirname "$(readlink -f $0)"`
elif [ -e '/bin/zsh' ]; then
    F=`/bin/zsh -c "print -lr -- $BASH_SOURCE(:A)"`
    SCRIPT_DIR=`dirname $F`
elif [ -e '/usr/bin/realpath' ]; then
    F=`/usr/bin/realpath $BASH_SOURCE`
    SCRIPT_DIR=`dirname $F`
else
    F=$BASH_SOURCE
    while [ -h "$F" ]; do F="$(readlink $F)"; done
    SCRIPT_DIR=`dirname $F`
fi
# change pwd
cd $SCRIPT_DIR

REL_BIN_DIR='target/bin'

cargo_build() {
  OUT_DIR="$1"
  shift
  rm -rf target/release && \
  cargo build --release $@ && \
  mkdir -p $OUT_DIR && \
  cp target/release/rivet $OUT_DIR && \
  cp target/release/rivet-engine $OUT_DIR
}

cargo_build $REL_BIN_DIR/sqlite-local --features sqlite-local $@ && \
cargo_build $REL_BIN_DIR/default $@ && \
du -sh $REL_BIN_DIR/sqlite-local/* $REL_BIN_DIR/default/*
