#!/bin/bash

COOKIE_JAR="$1"
KENDO_FILE="$2"

[[ ${OJS_URL:="http://bgcoder.com"} ]]

url="$OJS_URL/Administration/Contests/Read"
total=$(curl -s "$url" --compressed -b "$COOKIE_JAR" --data "sort=CreatedOn-desc" --data "page=1" --data "pageSize=1" --data "group=" --data "filter=" \
	| sed -r -n 's/.*"Total":([0-9]*).*/\1/p')

mkdir -p "$(dirname "$KENDO_FILE")"
curl -s "$url" --compressed -b "$COOKIE_JAR" --data "sort=CreatedOn-desc" --data "page=1" --data "pageSize=$total" --data "group=" --data "filter=" -o "$KENDO_FILE"
