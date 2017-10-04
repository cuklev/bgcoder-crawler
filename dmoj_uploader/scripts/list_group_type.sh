#!/bin/bash

GROUP_OR_TYPE="$1"

[[ ${DMOJ_URL:="http://localhost:8081"} ]]
[[ ${COOKIE_JAR:="cookie-jar"} ]]

case "$GROUP_OR_TYPE" in
	group) URL="$DMOJ_URL/admin/judge/problemgroup/" ;;
	type) URL="$DMOJ_URL/admin/judge/problemtype/" ;;
	*)
		echo "Specify group or type."
		exit 1 ;;
esac

curl -s "$URL" -b "$COOKIE_JAR" --compressed \
	| sed -n -r 's;.*value="([0-9]*)".*<a[^>]*>([^<]*).*;\1:\2;p'
