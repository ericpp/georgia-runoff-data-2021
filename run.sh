#!/bin/sh

getgaversion() {
	newversion=$(curl -s https://results.enr.clarityelections.com//GA/107556/current_ver.txt)
	exists=$(grep "$newversion" GA/versions)

	if [ -z "$exists" ]; then
		echo "$1" >> GA/versions
	fi

	echo "$newversion"
}

download() {
	prefix=$1
	url=$2

	mkdir -p "./$prefix"

	filename=$(basename "$url")

	echo "$url"
	curl --compressed --connect-timeout 10 -m 10 -s -o "./$prefix/$filename" "$url"
}

while [ 1 ]; do
	tstamp=$(date +%Y-%m-%d_%H:%M:%S.%N)

	echo "Pulling in results: $tstamp"

	download "AP" "https://interactives.ap.org/elections/live-data/production/2021-01-05/us-senate/GA.json"
	download "AP" "https://interactives.ap.org/elections/live-data/production/2021-01-05/us-senate/summary.json"
	download "AP" "https://interactives.ap.org/elections/live-data/production/2021-01-05/bop.json"

	download "NPR" "https://apps.npr.org/elections20-primaries/data/GA_S_1_5_2021.json"

	download "NBC" "https://www.nbcnews.com/politics/2020-special-elections/georgia-senate-runoff-results?format=json"

	download "Bloomberg" "https://www.bloomberg.com/bbg-gfx/us-election-results/2021-01-05/results.tsv"
	download "Bloomberg" "https://www.bloomberg.com/bbg-gfx/us-election-results/2021-01-05/county/GA-results.tsv"

	gaversion=$(getgaversion)

	echo "$gaversion"

	download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/ALL.json"
	download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Election_Day_Votes.json"
	download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Absentee_by_Mail_Votes.json"
	download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Advanced_Voting_Votes.json"
	download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Provisional_Votes.json"

	git add -A
	updated=$(git diff --name-only --cached | xargs)

	git commit --author "Automated Script <run@localhost>" -m "$updated"
	git log --name-status HEAD^..HEAD
	git push origin master

	echo "Sleeping..."
	sleep 30
done
