#!/bin/bash
# Script download AdventOfCode input for the day
# PUt into crontab
# 0,1 12 * * * sleep 10 && PATHTOTHIS/download_input.sh $(date +\%-d)

if [ -z "$1" ]; then
  day=$(date +%-d)
else
  day=$1
fi
URL="https://adventofcode.com/2020/day/${day}/input"
input_filename="$HOME/me/adventofcode/test/input2020_${day}"
echo "Getting input from ${URL}"
echo "output to ${input_filename}"
cookiefile=$(dirname "$0")/cookie_session
if [ ! -f "$cookiefile" ]; then
    echo "$cookiefile must exist and export SESSION var"
    exit 1
fi
source "$cookiefile"

curl "$URL" \
  -H 'authority: adventofcode.com' \
  -H 'cache-control: max-age=0' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: none' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H "cookie: _ga=GA1.2.895517357.1606730261; _gid=GA1.2.38384064.1606730261; session=$SESSION" \
  --compressed > "${input_filename}"

head -3 "${input_filename}"
