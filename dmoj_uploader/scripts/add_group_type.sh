#!/bin/bash

DMOJ_URL="$1"
COOKIE_JAR="$2"
ID="$3"
NAME="$4"
GROUP_OR_TYPE="$5"

case "$GROUP_OR_TYPE" in
	group) URL="$DMOJ_URL/admin/judge/problemgroup/add/" ;;
	type) URL="$DMOJ_URL/admin/judge/problemtype/add/" ;;
	*)
		echo "Specify group or type."
		exit 1 ;;
esac

CSRF_SCRIPT="$(dirname "$0")/csrf.sh"
csrf="$("$CSRF_SCRIPT" "$URL" "$COOKIE_JAR")"

curl -s "$URL" \
	-b "$COOKIE_JAR" \
	--compressed \
	--form "csrfmiddlewaretoken=$csrf" \
	--form "name=$ID" \
	--form "full_name=$NAME" \
	--form "_save="
