#!/bin/bash

URL="$OJS_URL/Administration/ContestCategories/Read"

curl -s "$URL" -b "$COOKIE_JAR" --compressed \
	--data 'sort=CreatedOn-desc' \
	--data 'page=1' \
	--data 'pageSize=10' \
	--data 'group=' \
	--data 'filter=IsVisible~eq~false'
