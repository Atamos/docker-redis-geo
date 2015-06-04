#!/bin/bash
set -e
if [ "$1" = 'redis-server' ]; then
     chown -R redis .
         exec gosu redis "$@" --module-add /usr/lib/geo.so
     fi
exec "$@"
