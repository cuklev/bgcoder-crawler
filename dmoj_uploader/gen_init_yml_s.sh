#!/bin/bash

CONTESTS_LOCATION="$1"
[[ ${CONTESTS_LOCATION:=../bgcoder_crawler/downloaded/contests} ]]

find "$CONTESTS_LOCATION" -name \*.zip \
	| while read zipfile; do
		{
			echo "archive: $(basename "$zipfile")"
			echo "test_cases:"
			unzip -Z1 "$zipfile" \
				| sort -n \
				| sed \
					-e N \
					-e 's/^/- {in: /' \
					-e 's/\n/, out: /' \
					-e '/\.000\./{s/$/, points: 0}/;b}' \
					-e 's/$/, points: 1}/'
		} > "$(dirname "$zipfile")/init.yml"
	done
