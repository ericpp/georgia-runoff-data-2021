#!/bin/sh

while [ 1 ]; do
	./fetch.sh | tee -a log.txt

	echo "Sleeping..."
	sleep 15
done
