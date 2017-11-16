#!/bin/bash

PROBLEM_DIR="$1"
cd "$PROBLEM_DIR"
cd resources

md_file() {
	local file="$(find -iname \*.md | head -n1)"
	if [[ "$file" != "" ]]; then
		cat "$file"
		exit
	fi
}

html_file() {
	local file="$(find -iname \*.html | head -n1)"
	if [[ "$file" != "" ]]; then
		cat "$file"
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

odt_file() {
	local file="$(find -iname \*.odt | head -n1)"
	if [[ "$file" != "" ]]; then
		pandoc "$file" -t markdown_github -o-
		exit
	fi
}

doc_file() {
	local file="$(find -iname \*.doc | head -n1)"
	if [[ "$file" != "" ]]; then
		lowriter --convert-to odt "$file" &> /dev/null
		odt_file
		exit
	fi
}

docx_file() {
	local file="$(find -iname \*.docx | head -n1)"
	if [[ "$file" != "" ]]; then
		lowriter --convert-to odt "$file" &> /dev/null
		odt_file
		exit
	fi
}

md_file
html_file
link_file
docx_file
doc_file

exit 1
