#!/bin/bash

PROBLEM_ID="$1"

curl -s "$OJS_URL/Administration/Resources/GetAll/$PROBLEM_ID" -b "$COOKIE_JAR" --compressed \
	--data 'sort=OrderBy-asc' \
	--data 'page=1' \
	--data 'pageSize=50' \
	--data 'group=' \
	--data 'filter='
