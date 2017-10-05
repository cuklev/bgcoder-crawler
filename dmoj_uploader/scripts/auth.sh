#!/bin/bash

LOGIN_URL="$DMOJ_URL/accounts/login/?next=/"

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
