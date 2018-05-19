#!/bin/sh
beginswith() { case $2 in "$1"*) true;; *) false;; esac; }
echo "-----> Getting a fresh copy of Rust"
curl https://sh.rustup.rs -sSf | sh -y
MANPATH=$1Cargo.toml
echo "-----> Manifest Path: $MANPATH"
APPNAME=""
echo "-----> Capturing the app name"
while read l; do
  if beginswith "name = " "$l"; then
    APPNAME=$(echo $l | cut -d ' ' -f 2-)
    break
  fi
done <$MANPATH
echo "-----> App Name: $APPNAME"
export APPNAME
echo "-----> Building the project"
cargo build --release --manifest-path $MAN_PATH
echo "-----> Copying the binary to the build dir"
cp $1target/release/$NAME $1$NAME
