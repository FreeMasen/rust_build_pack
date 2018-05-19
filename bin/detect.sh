#!/bin/sh

if [ -f $1Cargo.toml ]; then
    echo "RustProject"
    exit 0
else
    exit 1
fi