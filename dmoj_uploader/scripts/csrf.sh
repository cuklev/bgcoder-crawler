#!/bin/bash

URL="$1"

curl -s "$URL" -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
	| sed -r -n "/name='csrfmiddlewaretoken'/s/.*value='([^']*).*/\1/p"
