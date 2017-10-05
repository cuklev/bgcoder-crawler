#!/bin/bash

URL="$1"
DOWNLOAD_DIR="$2"

cd "$DOWNLOAD_DIR"
curl -s "$URL" --compressed -b "$COOKIE_JAR" -O -J
