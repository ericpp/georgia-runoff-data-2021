#!/bin/sh

urls=$(jq -r '.data.races[].precinct_metadata.timestamped_url' NYT/georgia.json  | grep -v null)

for url in $urls; do
	exists=$(grep NYT/precinct-urls.txt)

	if [ -z "$exists" ]; then
		echo "$url" >> NYT/precinct-urls.txt
	fi
done
