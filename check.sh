#!/bin/sh

PID=$(pgrep -f run.sh)

if [ -z "$PID" ]; then
  echo "$PID"
  screen -d -m ./run.sh
fi
