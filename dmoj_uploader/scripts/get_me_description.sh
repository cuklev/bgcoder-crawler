#!/bin/bash

PROBLEM_DIR="$1"
cd "$PROBLEM_DIR"

cd resources

md_file() {
	local file="$(find -iname \*.md | head -n1)"
	if [[ "$md_file" != "" ]]; then
		cat "$md_file"
		exit
	fi
}

link_file() {
	local file="$(find -name \*.link | head -n1)"
	if [[ "$file" != "" ]]; then
		local link="$(cat "$file")"
		echo "<a href=\"$link\">Link to description</a>"
		exit
	fi
}

md_file
link_file

exit 0
