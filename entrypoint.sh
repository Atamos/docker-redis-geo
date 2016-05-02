#!/bin/bash
set -e
if [ "$1" = 'redis-server' ]; then
	chown -R redis .
	gosu redis "$@" --module-add /usr/lib/geo.so &
	PID=$!
	trap "redis-cli SHUTDOWN SAVE" TERM INT
	wait $PID
	trap - TERM INT
	wait $PID
fi
exec "$@"
