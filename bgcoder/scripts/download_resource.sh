#!/bin/bash

URL="$1"
DOWNLOAD_DIR="$2"

cd "$DOWNLOAD_DIR"

# curl does not support Content-Disposition: filename*=UTF-8''
# work around it!
UTF_FILENAME="$(curl -s "$URL" --compressed -b "$COOKIE_JAR" -I \
	| sed -n -r "s/^Content-Disposition:.* filename\*=UTF-8''(.*)\r$/\1/p" \
	| sed "$(for hex in {{0..9},{a..f}}{{0..9},{a..f}}; do echo "s/%$hex/\\x$hex/gi"; done)")"
	# Nested and ugly $() but it works

if [[ "$UTF_FILENAME" == "" ]]; then
	curl -s "$URL" --compressed -b "$COOKIE_JAR" -O -J
else
	curl -s "$URL" --compressed -b "$COOKIE_JAR" -o "$UTF_FILENAME"
fi
