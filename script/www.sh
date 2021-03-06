#!/bin/bash

if [ -z "$2" ]
then
    echo "Usage: www.sh <development|production> <start|stop|restart>"
    exit 1
fi

ALTLAW_ENV=$1
PID_FILE="var/www.pid"

source `dirname $0`/env.sh


function start {
    $JAVA org.altlaw.www.server &
    PID=$!

    echo "Server running at PID $PID"
    mkdir -p var
    echo $PID > $PID_FILE
}

function stop {
    if [ -e $PID_FILE ]
    then
        kill `cat $PID_FILE`
        rm "$PID_FILE"
    else
        echo "No PID file.  Jps says:"
        jps
    fi
}

case "$2" in
    start)
        start;
        ;;
    stop)
        stop;
        ;;
    restart)
        stop;
        start;
        ;;
    *)
        echo "Invalid command: $2"
        echo "Run without arguments for usage."
        exit 1
esac
