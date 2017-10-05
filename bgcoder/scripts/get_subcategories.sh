#!/bin/bash

ID="$1"
URL="$OJS_URL/Administration/ContestCategories/ReadCategories"

if [[ "$ID" != "" ]]; then
	URL="$URL?id=$ID"
fi

curl -s "$URL" -b "$COOKIE_JAR" --compressed
