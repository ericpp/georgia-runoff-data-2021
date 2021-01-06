#!/bin/sh

while [ 1 ]; do
	./fetch.sh 2>&1 | tee log.txt

	echo "Sleeping..."
	sleep 15
done
