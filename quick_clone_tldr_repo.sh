#!/bin/bash
# Clone from a mirror repo in Gitee, because clone from GitHub will take too much time,

parentdir=~/.config/tldr2
if [ ! -d "$parentdir" ]; then
	mkdir -p $parentdir
fi

configdir="$parentdir/tldr"
if [ ! -d "$configdir" ]; then
	cd $parentdir
	
	echo "Clone tldr pages from Gitee."
	git clone https://gitee.com/fhtao/tldr
	
	echo ""
	echo "Change origin's url to GitHub."
	cd tldr
	git remote set-url origin "https://github.com/tldr-pages/tldr.git"

	echo ""
    echo "Pull for the newest updates. Press <Ctrl>-<C> to stop pulling."
	git pull
fi

