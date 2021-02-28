# tldr

A fully-functional POSIX shell client for [tldr](https://github.com/rprieto/tldr/).
This version aims to be the easiest, smallest, and most universal client to set up
on a new account, without sacrificing any features. It uses only `/bin/bash` features
and `git`, and tested on Linux, OSX, FreeBSD, with `bash`.

![tldr screenshot](Screenshot.png?raw=true)

## Installation
```bash
mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/fanhongtao/tldr-sh-client/master/tldr
chmod +x ~/bin/tldr
```

Then try using the command! If you get an error such as _-bash: tldr: command not found_,
you may need to add `~/bin` to your `$PATH`. On OSX edit `~/.bash_profile`
(`~/.bashrc` on Linux), and add the following line to the bottom of the file:
```bash
export PATH=$PATH:~/bin
```

If you'd like to enable shell completion (eg. `tldr w<tab><tab>` to get a
list of all commands which start with w) then add the following to the same
startup script:

```bash
complete -W "$(tldr 2>/dev/null --list)" tldr
```

## Prerequisites

`git` needs to be available somewhere in your `$PATH`. The script is otherwise self-contained.

## Usage
```
tldr [options] command

[options]
	-l, --list:      show all available pages
	-p, --platform:  show page from specific platform rather than autodetecting
	-u, --update:    update, force retrieving latest copies of index and <command>
	-m, --markdown:  show markdown page
	-v, --version:   show version number and quit
	-h, -?, --help:  this help overview

command
	Show examples for this command
```

The client caches a copy of all pages and the index locally under
~/.config/tldr. By default, the cached copies will automatically update every 14 days.

## Customization
You can change the styling of the output from `tldr` by defining some environment variables. For
example, try adding the following lines to your `~/.bash_profile` file (OSX) or `~/.bashrc` file
(Linux).

```bash
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'
```

Possible settings are: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`,
`white`, `onblue`, `ongrey`, `reset`, `bold`, `underline`, `italic`, `eitalic`, `default`
_(some variables may not work in some shells)_.

NB: You will need to log into a new session to see the effect. Just run the commands in the
terminal directly to see the change immediately and temporarily.

## Contributing

This is the result of a Sunday afternoon project. It's been lightly tested under Mac OS X 10.9
and Ubuntu Linux 15.10. I've tried to make the project as portable as possible, but if there's
something I missed I'd love your help.

* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or even better send me a pull request.

Contributions are always welcome at any time!

## Extra

```bash
export TLDR_REPO='https://github.com/tldr-pages/tldr.git'
export TLDR_AUTO_UPDATE=1
```

* `TLDR_REPO` : Used to set to a `tldr` git repo.
  * `https://github.com/tldr-pages/tldr.git`， **Default value.**
  * `https://gitee.com/tldr-pages/tldr.git`.  Alterative value. If the access to GitHub is too slow, try this one.
* `TLDR_AUTO_UPDATE` : If `tldr` will automatically update cached content.
  * `1`, enable auto-update. **Default value.**
  * `0`, disable auto-update. Can manually update by `tldr -u`.


# How to test

There are some test suggestions.

## Show markdown

Use `tldr -m` to show the original markdown.

The fellowing command shows markdown of `sleep`

```bash
./tldr -m sleep
```

## Change code for parse in `parse.sh`

File [parse.sh](parse.sh) is used to parse commands in [commands.md](commands.md).

Before change, execute the fellowing command to write parse result into file `p1.txt`

```bash
./parse.sh -t > p1.txt
```

After change, write result into `p2.txt`

```bash
./parse.sh -t > p2.txt
```

And use `diff` to compare the results.

```bash
diff p1.txt p2.txt
```

Finally, merge code into [tldr](tldr).

## View by `view-commands.sh`

Use [view-commands.sh](view-commands.sh) to view commands one by one.

```bash
./tldr -l > list.txt   	         # Generate command list file
./view-commands.sh list.txt      # View command from the first
./view-commands.sh list.txt  bc  # View command from 'bc'
```
