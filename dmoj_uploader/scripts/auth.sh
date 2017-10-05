#!/bin/bash

LOGIN_URL="$DMOJ_URL/accounts/login/?next=/"

check_good_cookie() {
	[[ ! -f "$COOKIE_JAR" ]] && return 1
	curl -s -I "$DMOJ_URL/admin/" -b "$COOKIE_JAR" \
		| grep -q "200 OK"
}

while ! check_good_cookie; do
	printf "Username: "
	read username
	printf "Password: "
	read -rs password
	echo

	CSRF_SCRIPT="$(dirname "$0")/csrf.sh"
	csrf="$("$CSRF_SCRIPT")"

	curl -s "$LOGIN_URL" \
		-b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		-d "csrfmiddlewaretoken=$csrf" \
		-d "username=$username" \
		-d "password=$password" \
		-d "next=%2F"
done
