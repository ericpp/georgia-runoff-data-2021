#!/bin/sh

PID=$(pgrep -f run.sh)

if [ -z "$PID" ]; then
  echo "$PID"
  screen -d -m 'sh run.sh'
fi
