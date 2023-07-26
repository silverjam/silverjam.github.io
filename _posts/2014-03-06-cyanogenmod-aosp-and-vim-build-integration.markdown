# CyanogenMod (AOSP) and Vim Build Integration

| Metadata   | Value      |
| ---------- | ---------- |
| Date       | 2014-03-06 |
| Categories | android    |

---

The build system AOSP and CyanogenMod have some interesting shell scripts that
make it easier to build various parts of the system:

- `breakfast [device]` -- selects a particular device for building
- `brunch [device]` -- building the entire image for the device
- `mka bacon` -- almost the same as `brunch`, but, mmm.... bacon....
- `mm [make_args]` -- builds whatever module you happen to be in, just that
  module
- `mmp [make_args]` -- builds whatever module you happen to be in, just that
  module, and pushes it to the device

So... the mm and mmp directives seem like great shortcuts to shorten your
develop / compile / test cycle, right?  But what about editor completion?  You
can't invoke mm and mmp in a vim session in order to munch on the compile
errors?!  Fret not!  Now you can!

The first step is a couple of nifty shell scripts.  They probably represent a
horrible compromise of your security, so use with care.  But here they are...

The first is a server of sorts, it sits in a open shell session, one that's all
setup to build Android:

```bash do_over_there_listen.sh
#!/bin/bash

FIFO_STDINP="/tmp/do_over_there.stdinp.fifo"
FIFO_STDOUT="/tmp/do_over_there.stdout.fifo"
FIFO_STDERR="/tmp/do_over_there.stderr.fifo"

do_stuff_here() {
    rm -vf $FIFO_STDINP
    rm -vf $FIFO_STDOUT
    rm -vf $FIFO_STDERR

    mkfifo $FIFO_STDINP
    mkfifo $FIFO_STDOUT
    mkfifo $FIFO_STDERR

    while read line <$FIFO_STDINP ; do
        echo "Running: $line"
        eval $line >$FIFO_STDOUT 2>$FIFO_STDERR
    done
}
```

You run this script like so:

```text run do_stuff_here
$ . ~/Scripts/do_over_there_listen.sh ; do_stuff_here
removed `/tmp/do_over_there.stdinp.fifo'
removed `/tmp/do_over_there.stdout.fifo'
removed `/tmp/do_over_there.stderr.fifo'
```

The next step is a script that takes the place of make in your vim session:

```bash do_over_there
#!/bin/bash

D=$(dirname $(readlink -f ${BASH_SOURCE}))
source "$D/do_over_there_listen.sh"

echo "mm $@" >$FIFO_STDINP

cat $FIFO_STDOUT &
cat $FIFO_STDERR >&2 &

wait
```

Then, the final piece of the puzzle is to tell vim to use the new "make"
command with (after `chmod +x do_over_there` of course):

```text vimrc mods
set makeprg=~/path/to/do_over_there
```

Finally, you'll be able to compile with the AOSP and CyanogenMod build system
niceties but then suck those error logs into vim.  Like so:

<img src=images/do-over-there.gif />
