#!/bin/bash
set -e

if [ "$1" = 'transcode' ]; then
    exec transcode "$@"
else
 if [ -x $(which "$1") ]; then
    exec "$@"
 fi
fi

exec transcode "$@"
