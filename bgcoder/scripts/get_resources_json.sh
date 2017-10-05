#!/bin/bash

PROBLEM_ID="$1"

[[ ${COOKIE_JAR:="cookie-jar"} ]]
[[ ${OJS_URL:="http://bgcoder.com"} ]]

curl -s "$OJS_URL/Administration/Resources/GetAll/$PROBLEM_ID" -b "$COOKIE_JAR" --compressed --data 'sort=OrderBy-asc&page=1&pageSize=50&group=&filter='
