#!/bin/bash

PROBLEM_DIR="$1"
cd "$PROBLEM_DIR"

if [[ "$2" == "list" ]]; then
	find -type d -name resources -print0 \
		| xargs -n 1 -0 ls \
		| sed '/\.link$/!s/Resource-[0-9]*-//' \
		| sort -u

	exit 0
fi

narrow() {
	local candidates=("$@")
	local description=()

	case ${#description[*]} in
		0) return 1;; # No valid description
		1) echo "${description[0]}" # valid description
			return 0;;
	esac

	# TODO: Find the best
	echo "${description[@]}"
}


narrow *
