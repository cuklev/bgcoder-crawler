#!/bin/bash

[[ ${COOKIE_JAR:="cookie-jar"} ]]
[[ ${OJS_URL:="http://bgcoder.com"} ]]

CONTEST_ID="$1"
DOWNLOAD_LOCATION="$2"


mkdir -p "$(dirname "$DOWNLOAD_LOCATION")"
curl -s "$OJS_URL/Administration/Problems/ByContest/$CONTEST_ID" --compressed -b "$COOKIE_JAR" -o "$DOWNLOAD_LOCATION"
