#!/bin/bash

COOKIE_JAR="$1"

[[ ${DMOJ_URL:="http://localhost:8081"} ]]
LOGIN_URL="$DMOJ_URL/accounts/login/?next=/"

printf "Username: "
read username
printf "Password: "
read -rs password
echo

CSRF_SCRIPT="$(dirname "$0")/csrf.sh"
csrf="$("$CSRF_SCRIPT" "$LOGIN_URL" "$COOKIE_JAR")"

curl -s "$LOGIN_URL" \
	-b "$COOKIE_JAR" -c "$COOKIE_JAR" \
	-d "csrfmiddlewaretoken=$csrf" \
	-d "username=$username" \
	-d "password=$password" \
	-d "next=%2F"
