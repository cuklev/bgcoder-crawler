#!/bin/bash

PROBLEM_ID="$1"

curl -s "$OJS_URL/Administration/Resources/GetAll/$PROBLEM_ID" -b "$COOKIE_JAR" --compressed --data 'sort=OrderBy-asc&page=1&pageSize=50&group=&filter='
