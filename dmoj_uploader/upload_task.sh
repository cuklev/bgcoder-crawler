#!/bin/bash

DMOJ_URL="${1:-http://testjudge.telerikacademy.com}"

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
		-b "$COOKIE_JAR" \
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
		-b "$COOKIE_JAR" \
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
		-b "$COOKIE_JAR" \
		--compressed \
		--form "csrfmiddlewaretoken=$csrf" \
		--form "code=$id" \
		--form "name=$name" \
		--form "is_public=on" \
		--form "date_0=2017-08-18" \
		--form "date_1=12:00:00" \
		--form "authors=1" \
		--form "description=$description" \
		--form "license=" \
		--form "og_image=" \
		--form "summary=" \
		--form "types=1" \
		--form "types=2" \
		--form "group=1" \
		--form "points=$points" \
		--form "partial=on" \
		--form "time_limit=$time_limit" \
		--form "memory_limit=$memory_limit" \
		--form "allowed_languages=1" \
		--form "allowed_languages=2" \
		--form "allowed_languages=3" \
		--form "allowed_languages=4" \
		--form "allowed_languages=5" \
		--form "allowed_languages=6" \
		--form "allowed_languages=7" \
		--form "allowed_languages=8" \
		--form "allowed_languages_all=on" \
		--form "change_message=" \
		--form "language_limits-TOTAL_FORMS=3" \
		--form "language_limits-INITIAL_FORMS=0" \
		--form "language_limits-MIN_NUM_FORMS=0" \
		--form "language_limits-MAX_NUM_FORMS=1000" \
		--form "language_limits-0-id=" \
		--form "language_limits-0-problem=" \
		--form "language_limits-0-language=" \
		--form "language_limits-0-time_limit=" \
		--form "language_limits-0-memory_limit=" \
		--form "language_limits-1-id=" \
		--form "language_limits-1-problem=" \
		--form "language_limits-1-language=" \
		--form "language_limits-1-time_limit=" \
		--form "language_limits-1-memory_limit=" \
		--form "language_limits-2-id=" \
		--form "language_limits-2-problem=" \
		--form "language_limits-2-language=" \
		--form "language_limits-2-time_limit=" \
		--form "language_limits-2-memory_limit=" \
		--form "language_limits-__prefix__-id=" \
		--form "language_limits-__prefix__-problem=" \
		--form "language_limits-__prefix__-language=" \
		--form "language_limits-__prefix__-time_limit=" \
		--form "language_limits-__prefix__-memory_limit=" \
		--form "problemclarification_set-TOTAL_FORMS=0" \
		--form "problemclarification_set-INITIAL_FORMS=0" \
		--form "problemclarification_set-MIN_NUM_FORMS=0" \
		--form "problemclarification_set-MAX_NUM_FORMS=1000" \
		--form "problemclarification_set-__prefix__-description=" \
		--form "problemclarification_set-__prefix__-id=" \
		--form "problemclarification_set-__prefix__-problem=" \
		--form "solution-TOTAL_FORMS=0" \
		--form "solution-INITIAL_FORMS=0" \
		--form "solution-MIN_NUM_FORMS=0" \
		--form "solution-MAX_NUM_FORMS=1" \
		--form "solution-__prefix__-publish_on_0=" \
		--form "solution-__prefix__-publish_on_1=" \
		--form "solution-__prefix__-content=" \
		--form "solution-__prefix__-id=" \
		--form "solution-__prefix__-problem=" \
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

add_problem autotest "Auto test" 'Multiline
кирилица'
