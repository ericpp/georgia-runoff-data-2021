#!/bin/sh

getgaversion() {
	version=$(curl -s https://results.enr.clarityelections.com//GA/107556/current_ver.txt)
	echo "$version" > GA/versions
	echo "$version"
}

download() {
	prefix=$1
	url=$2

	mkdir -p "./$prefix"

	filename=$(basename "$url")

	echo "$url"
	curl --compressed --connect-timeout 10 -m 10 -s -o "./$prefix/$filename" "$url"
}

tstamp=$(date +%Y-%m-%d_%H:%M:%S.%N)

echo "Pulling in results: $tstamp"

# Media outlets

while read -r source url; do
        if [ ! -z "$source" -a ! -z "$url" ]; then
                download "$source" "$url"
        fi
done < urls.txt

# GA SOS data

gaversion=$(getgaversion)

download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/ALL.json"
download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Election_Day_Votes.json"
download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Absentee_by_Mail_Votes.json"
download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Advanced_Voting_Votes.json"
download "GA" "https://results.enr.clarityelections.com//GA/107556/$gaversion/json/Provisional_Votes.json"

# NYT Precinct URLS

sh ./precinct-urls.sh

# Use git to find differences and push to github
git add -A
git diff --cached --name-only
git add log.txt

updated=$(git diff --name-only --cached | xargs)

git commit --author "Automated Script <run@localhost>" -m "$updated"
git log --name-status HEAD^..HEAD

git push origin master
