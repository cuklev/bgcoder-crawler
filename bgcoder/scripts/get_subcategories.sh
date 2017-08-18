#!/bin/bash

COOKIE_JAR="$1"
ID="$2"

[[ ${OJS_URL:="http://bgcoder.com"} ]]

URL="$OJS_URL/Administration/ContestCategories/ReadCategories"

if [[ "$ID" != "" ]]; then
	URL="$URL?id=$ID"
fi

curl -s "$URL" -b "$COOKIE_JAR" --compressed
