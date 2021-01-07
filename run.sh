#!/bin/sh

while [ 1 ]; do
	#./fetch.sh 2>&1 | tee log.txt
	./fetch.sh

	#echo "Sleeping..."
	#sleep 5
done
