#!/bin/bash
# Test code for parse command page's command.
#set -x
set -uf

unquote() {
	# take everything between two backticks, capture it
	printf "%s\n" "$*" | sed "s/\`\([^\`]*\)\`/\1/g"
}

# contains string substr
# return: true, if `string` contains `substr`.
contains() {
	[ "${1#*${2:-}*}" = "$1" ] && echo "false" || echo "true"
}

# startswith string prefix
# return: true, if `string` start with `prefix`
startswith() {
	[ "$2${1#${2}}" = "$1" ] && echo "true" || echo "false"
}

# index_of string token [start]
# return: index of `token` in `string`, from start . 0 means not exist.
index_of() {
	local string="$1"
	local token="$2"
	local start=${3:-0}
	if [ $start -ne 0 ]; then
		string=${string:$start}
	fi
	prefix=${string%%${token}*}
	echo ${#prefix}
}

log() {
	printf ""
	# echo $*
}

print_space() {
	if $SHOW_TYPE; then
		echo "space:"
	else
		printf " "
	fi
}

print_code() {
	if $SHOW_TYPE; then
		echo "code: $*"
	else
		printf "${scode}"
		printf "%s" "${*}"
		printf "${reset}"
	fi
}

print_option() {
	if $SHOW_TYPE; then
		echo "option: $*"
	else
		printf "${sparam}"
		printf "%s" "${*}"
		printf "${reset}"
	fi
}

print_value() {
	if $SHOW_TYPE; then
		echo "value: $*"
	else
		printf "${svalue}"
		printf "%s" "$*" | sed "s/{{//" | sed "s/}}//"
		printf "${reset}"
	fi
}

# get a option from $line
get_option() {
	local word=""
	while [ ${#line} -gt 0 ]; do
		local ch=${line:0:1}
		if [ "$ch" = ' ' -o "$ch" = '\t' -o "\ch" = ':' -o "$ch" = '=' -o "$ch" = '{' ]; then
			break
		fi
		word="${word}${ch}"
		line=${line:1}
	done
	printf "%s" "$word"
}

get_value() {
	local end_tag="$1"
	local index=`index_of "$line" "$end_tag" ${#end_tag}`
	index=`expr $index + ${#end_tag} + ${#end_tag}`  # assume begin_tag is the same len of end_tag
	local word=${line:0:$index}
	printf "%s" "$word"
}

get_code() {
	local word=""
	while [ ${#line} -gt 0 ]; do
		local ch=${line:0:1}
		if echo "$ch" | grep -q '[^a-zA-Z0-9]'; then
			break
		fi
		word="${word}${ch}"
		line=${line:1}
	done
	printf "%s" "$word"
}

code() {
	line=$(unquote "$line")
	printf "  "
	while [ ${#line} -gt 0 ]; do
		ch=${line:0:1}
		if [ "$ch" = " " -o "$ch" = "\t" ]; then
			line=${line:1}
			print_space
			continue
		fi

		two=${line:0:2}
		if [ "$ch" = "-" ]; then
			word=$(get_option)
			print_option "${word}"
		elif [ "$ch" = "'" -o "$ch" = '"' ]; then
			word=$(get_value $ch)
			print_value "${word}"
		elif [ "$two" = "{{" ]; then
			word=`get_value "}}"`
			print_value "${word}"
		elif echo "$ch" | grep -q '[a-zA-Z0-9]'; then
			word=`get_code`
			print_code "${word}"
		else
			word="$ch"
			print_code "${word}"
		fi
		line=${line:${#word}}
	done
	echo
}

SHOW_TYPE=false

# --------------

while [ $# -gt 0 ]; do
	case "$1" in
		-t | --type)
			SHOW_TYPE=true
			;;
	esac
	shift
done

reset="\33[0m"
scode="\33[31m" # red
sparam="\33[33m"
svalue="\33[36m"

# cat commands.md | while read line; do
cat commands.md | while IFS= read -r line || [ -n "$line" ]; do
	if [ -z "$line" ]; then
		continue
	fi
	echo $line
	code "$line"
	echo
#	exit
done
