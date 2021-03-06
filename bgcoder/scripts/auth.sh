#!/bin/bash

LOGIN_URL="$OJS_URL/Account/Login"

check_good_cookie() {
	[[ ! -f "$COOKIE_JAR" ]] && return 1
	curl -s -I "$OJS_URL/Administration/Contests" -b "$COOKIE_JAR" \
		| grep -q "200 OK"
}

get_request_verification_token() {
	local url="$1"
	local form_action="$2"
	form_action="${form_action//\//\\/}"
	curl -s "$url" --compressed -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		| sed -r -n 's/.*<form[^>]*action="'"$form_action"'"[^>]*><input[^>]*name="__RequestVerificationToken"[^>]*value="([^"]*).*/\1/p'
}

mkdir -p "$(dirname "$COOKIE_JAR")"

while ! check_good_cookie; do
	printf "Username: "
	read username
	printf "Password: "
	read -rs password
	echo
	
	token=$(get_request_verification_token "$LOGIN_URL" "/Account/Login")
	curl -s "$LOGIN_URL" --compressed -b "$COOKIE_JAR" -c "$COOKIE_JAR" -d "__RequestVerificationToken=$token" -d "UserName=$username" -d "Password=$password" > /dev/null
done
