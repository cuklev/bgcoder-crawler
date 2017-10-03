#!/bin/bash

COOKIE_JAR="$1"
GROUP_OR_TYPE="$2"

[[ ${DMOJ_URL:="http://localhost:8081"} ]]

case "$GROUP_OR_TYPE" in
	group) URL="$DMOJ_URL/admin/judge/problemgroup/" ;;
	type) URL="$DMOJ_URL/admin/judge/problemtype/" ;;
	*)
		echo "Specify group or type."
		exit 1 ;;
esac

curl -s "$URL" -b "$COOKIE_JAR" --compressed \
	| sed -n -r 's;.*value="([0-9]*)".*<a[^>]*>([^<]*).*;\1:\2;p'
