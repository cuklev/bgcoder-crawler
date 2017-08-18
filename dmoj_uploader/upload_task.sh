#!/bin/bash

DMOJ_URL="http://testjudge.telerikacademy.com"
ADD_TASK_URL="$DMOJ_URL/admin/judge/problem/add/"

COOKIE_JAR="cookie-jar"

auth() {
	local url="$DMOJ_URL/accounts/login/?next=/"

	local username
	local password

	printf "Username: "
	read username
	printf "Password: "
	read -rs password
	echo

	local csrf=$(curl -s "$url" -c "$COOKIE_JAR" \
		| sed -r -n "/name='csrfmiddlewaretoken'/s/.*value='([^']*).*/\1/p")

	curl -s "$url" \
		-b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		-d "csrfmiddlewaretoken=$csrf" \
		-d "username=$username" \
		-d "password=$password" \
		-d "next=%2F"
}

add_group() {
	local id="$1"
	local name="$2"

	local url="$DMOJ_URL/admin/judge/problemgroup/add/"

	local csrf=$(curl -s "$url" -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		| sed -r -n "/name='csrfmiddlewaretoken'/s/.*value='([^']*).*/\1/p")

	curl -s "$url" \
		-b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		--compressed \
		--form "csrfmiddlewaretoken=$csrf" \
		--form "name=$id" \
		--form "full_name=$name" \
		--form "_save="
}

add_type() {
	local id="$1"
	local name="$2"

	local url="$DMOJ_URL/admin/judge/problemtype/add/"

	local csrf=$(curl -s "$url" -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		| sed -r -n "/name='csrfmiddlewaretoken'/s/.*value='([^']*).*/\1/p")

	curl -s "$url" \
		-b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		--compressed \
		--form "csrfmiddlewaretoken=$csrf" \
		--form "name=$id" \
		--form "full_name=$name" \
		--form "_save="
}

add_task() {
	return 1
}

[[ -f "$COOKIE_JAR" ]] || auth
