#!/bin/sh
# View commands `tldr` pages one by one.

set -uf

usage() {
	cmd=$(basename "$0")
	cat <<EOF
USAGE: $cmd <command-list-file> [<start-command>]

Example:
    $cmd  list.txt           # Start view from the first command in 'list.txt'
    $cmd  list.txt  bc       # Start view from command 'bc' in 'list.txt'

Note: You can create file 'list.txt' by:
    tldr -l > list.txt
EOF
}

#------------------

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

list_file=$1
command=${2:-}

while read line; do
    if [ ${#command} -gt 0 -a "$command" != "$line" ]; then
        continue
    fi
    command=""
    ./tldr $line
    read -p "Press Enter to view next command. Press Ctrl-C to quit. > " enter < /dev/tty
    echo
done < $1

echo "All commands finished."
