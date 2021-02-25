#!/bin/sh
# Test code for parse command page's command.

unquote() {
	# take everything between two backticks, capture it
	printf "%s\n" "$*" | sed "s/\`\([^\`]*\)\`/\1/g"
}

print_value() {
	printf "${svalue}"
	printf "%s" "$*" | sed "s/{{\(.*\)}}/\1/g"
	printf "${reset}"
}

parse() {
	printf "  "
	for word in $*; do
		case "$word" in
		\{\{*) # vlaue
			print_value "$word"
			;;
		\'*) # vlaue
			print_value "$word"
			;;
		-*) # option
			new=`echo "$word" | sed "s/=//"`
			if [ $new = $word  ]; then
				printf "${sparam}$word${reset}"
			else
				option=${word%%=*}
				value=${word##*=}
				printf "${sparam}${option}=${reset}"
				print_value "$value"
			fi
			;;
		*)
			printf "${scode}$word${reset}"
			;;
		esac
		printf " "
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

cat commands.md | while read line; do
	echo $line
	code "$line"
	echo
done
