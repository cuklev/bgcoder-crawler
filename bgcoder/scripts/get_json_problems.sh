#!/bin/bash

COOKIE_JAR="$1"
CONTEST_ID="$2"
DOWNLOAD_LOCATION="$3"

[[ ${OJS_URL:="http://bgcoder.com"} ]]

mkdir -p "$(dirname "$DOWNLOAD_LOCATION")"
curl -s "$OJS_URL/Administration/Problems/ByContest/$CONTEST_ID" --compressed -b "$COOKIE_JAR" -o "$DOWNLOAD_LOCATION"
