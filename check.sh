#!/bin/sh

PID=$(pgrep -f run.sh)

if [ -z "$PID" ]; then
  screen -d -m ./run.sh
fi
