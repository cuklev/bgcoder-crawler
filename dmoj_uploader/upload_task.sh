#!/bin/bash

DMOJ_URL="http://testjudge.telerikacademy.com"

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

add_problem() {
	local id="$1"
	local name="$2"
	local description="$3"

	local points=100
	local time_limit=1
	local memory_limit=16384

	local url="$DMOJ_URL/admin/judge/problem/add/"

	local csrf=$(curl -s "$url" -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		| sed -r -n "/name='csrfmiddlewaretoken'/s/.*value='([^']*).*/\1/p")

	curl -s "$url" \
		-b "$COOKIE_JAR" -c "$COOKIE_JAR" \
		--compressed \
		--form "csrfmiddlewaretoken=$csrf" \
		--form "code=$id" \
		--form "name=$name" \
		--form "is_public=on" \
		--form "date_0=2017-08-18" \
		--form "date_1=12:00:00" \
		--form "description=$description" \
		--form "license=" \
		--form "og_image=" \
		--form "summary=" \
		--form "types=3" \
		--form "types=5" \
		--form "group=7" \
		--form "points=$points" \
		--form "partial=on" \
		--form "time_limit=$time_limit" \
		--form "memory_limit=$memory_limit" \
		--form "allowed_languages=1" \
		--form "allowed_languages=2" \
		--form "allowed_languages=3" \
		--form "allowed_languages=4" \
		--form "change_message=" \
		--form "problemclarification_set-TOTAL_FORMS=0" \
		--form "problemclarification_set-INITIAL_FORMS=0" \
		--form "problemclarification_set-MIN_NUM_FORMS=0" \
		--form "problemclarification_set-MAX_NUM_FORMS=1000" \
		--form "problemclarification_set-__prefix__-description=" \
		--form "problemclarification_set-__prefix__-id=" \
		--form "problemclarification_set-__prefix__-problem=" \
		--form "language_limits-TOTAL_FORMS=0" \
		--form "language_limits-INITIAL_FORMS=0" \
		--form "language_limits-MIN_NUM_FORMS=0" \
		--form "language_limits-MAX_NUM_FORMS=1000" \
		--form "language_limits-__prefix__-id=" \
		--form "language_limits-__prefix__-problem=" \
		--form "language_limits-__prefix__-language=" \
		--form "language_limits-__prefix__-time_limit=" \
		--form "language_limits-__prefix__-memory_limit=" \
		--form "translations-TOTAL_FORMS=0" \
		--form "translations-INITIAL_FORMS=0" \
		--form "translations-MIN_NUM_FORMS=0" \
		--form "translations-MAX_NUM_FORMS=1000" \
		--form "translations-__prefix__-language=" \
		--form "translations-__prefix__-name=" \
		--form "translations-__prefix__-description=" \
		--form "translations-__prefix__-id=" \
		--form "translations-__prefix__-problem=" \
		--form "_save="
}

[[ -f "$COOKIE_JAR" ]] || auth
