#!/bin/bash

COOKIE_JAR="$1"
PROBLEM_ID="$2"

[[ ${OJS_URL:="http://bgcoder.com"} ]]

curl -s "$OJS_URL/Administration/Resources/GetAll/$PROBLEM_ID" -b "$COOKIE_JAR" --compressed --data 'sort=OrderBy-asc&page=1&pageSize=50&group=&filter='
