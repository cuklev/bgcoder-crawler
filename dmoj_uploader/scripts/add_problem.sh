#!/bin/bash

ID="$1"
NAME="$2"
DESCRIPTION="$3"
POINTS="$4"
TIME_LIMIT="$5"
MEMORY_LIMIT="$6"
GROUP_ID="$7"
TYPE_IDS="$8"

URL="$DMOJ_URL/admin/judge/problem/add/"

CSRF_SCRIPT="$(dirname "$0")/csrf.sh"
csrf="$("$CSRF_SCRIPT")"

curl -s "$URL" \
	-b "$COOKIE_JAR" \
	--compressed \
	--form "csrfmiddlewaretoken=$csrf" \
	--form "code=$ID" \
	--form "name=$NAME" \
	--form "is_public=on" \
	--form "date_0=2017-08-18" \
	--form "date_1=12:00:00" \
	--form "authors=1" \
	--form "description=$DESCRIPTION" \
	--form "license=" \
	--form "og_image=" \
	--form "summary=" \
	$(for tid in $TYPE_IDS; do
		echo "--form types=$tid"
	done) \
	--form "group=$GROUP_ID" \
	--form "points=$POINTS" \
	--form "partial=on" \
	--form "time_limit=$TIME_LIMIT" \
	--form "memory_limit=$MEMORY_LIMIT" \
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
