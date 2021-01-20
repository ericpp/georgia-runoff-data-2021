#!/bin/sh

urls=$(jq -r '.data.races[].precinct_metadata.timestamped_url' NYT/georgia.json  | grep -v null)

touch NYT/precinct-urls.txt

for url in $urls; do
	exists=$(grep "$url" NYT/precinct-urls.txt)

	if [ -z "$exists" ]; then
		echo "$url" >> NYT/precinct-urls.txt
	fi
done

cd NYT/precincts/
wget -nc -i ../precinct-urls.txt
