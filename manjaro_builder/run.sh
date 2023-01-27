#!/bin/bash
ARCH=$1
if [ -f "Dockerfile" ]; then
rm -rf Dockerfile
fi

cp ${ARCH}.Dockerfile Dockerfile

if [ "$ARCH" = "amd" ]; then
    docker build --platform linux/amd64 -t manjaro_builder .
else
    docker build --platform linux/arm64 -t manjaro_builder .
fi
