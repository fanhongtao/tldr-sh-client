#!/bin/sh
# Test code for parse command page's command.
#set -x
unquote() {
	# take everything between two backticks, capture it
	printf "%s\n" "$*" | sed "s/\`\([^\`]*\)\`/\1/g"
}

# contains string substr
# return: true, if `string` contains `substr`.
contains() {
	[ -z ${2:-} ] && { echo "true"; return; }
	[ "${1#*$2*}" = "$1" ] && echo "false" || echo "true"
}

# startswith string prefix
# return: true, if `string` start with `prefix`
startswith() {
	[ "$2${1#${2}}" = "$1" ] && echo "true" || echo "false"
}

log() {
	printf ""
	# echo $*
}

print_code() {
	if $SHOW_TYPE; then
		echo "code: $*"
	else
		printf "${scode}${*}${reset}"
	fi
}

print_option() {
	if $SHOW_TYPE; then
		echo "option: $*"
	else
		printf "${sparam}${*}${reset}"
	fi
}

print_value() {
	# Delete first character of "$*", and check if the rest string contain $value_end_tag
	# Beacuse value start with `'` or `"`, end tag is the same as start tag. So we should check after delete the first character.
	if $(contains `echo "$*" | sed 's/.//'` $value_end_tag); then
		want_value=false
	else
		want_value=true
	fi
	if $SHOW_TYPE; then
		echo "value: $*"
	else
		printf "${svalue}"
		printf "%s" "$*" | sed "s/{{//" | sed "s/}}//"
		printf "${reset}"
	fi
	log "value_end_tag: $value_end_tag, want_value: $want_value"
}

parse() {
	value_end_tag=""
	want_value=false
	printf " "
	for word in $*; do
		printf " "
		log "want_value: $want_value"
		if $want_value; then
			print_value "$word"
			continue
		fi

		case "$word" in
		\{\{*) # vlaue
			value_end_tag="}}"
			print_value "$word"
			;;
		\'*) # vlaue
			value_end_tag="'"
			print_value "$word"
			;;
		\"*) # vlaue
			value_end_tag='"'
			print_value "$word"
			;;
		-*) # option
			if ! $(contains "$word" "="); then
				if ! $(contains "$word" "{{"); then
					print_option "${word}"
				else
					option=${word%%{{*}
					value="{{"${word##*{{}
					print_option "${option}"
					value_end_tag="}}"
					print_value "$value"
				fi
			else
				option=${word%%=*}
				value=${word##*=}
				print_option "${option}="
				if $(startswith $value "{{"); then
					value_end_tag="}}"
				elif $(startswith $value "'"); then
					value_end_tag="'"
				elif $(startswith $value '"'); then
					value_end_tag='"'
				else
					value_end_tag=""
				fi
				print_value "$value"
			fi
			;;
		*)
			print_code "$word"
			;;
		esac
	done
	echo
}

code() {
	line=$(unquote "$line")
	parse $line
}

# --------------

reset="\33[0m"
scode="\33[31m" # red
sparam="\33[33m"
svalue="\33[36m"

SHOW_TYPE=false
while [ $# -gt 0 ]; do
	case "$1" in
		-t | --type)
			SHOW_TYPE=true
			;;
	esac
	shift
done

# cat commands.md | while read line; do
cat commands.md | while IFS= read -r line || [ -n "$line" ]; do
	if [ -z "$line" ]; then
		continue
	fi
	echo $line
	code "$line"
	echo
done
