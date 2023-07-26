---
layout: post
title: "Infinite terminal logs"
date: 2013-05-24 23:11
comments: true
categories: [bash, linux, logging, script, terminal, emulation]
---

## The Problem: Unsatisfying Terminal Emulators

Sometimes when you're hacking on things it's a great resource to be able to
recall / search everything that you've done in the past so that you can
reconstruct what's happened in a coherent matter.

This is, a crutch, or a substitute for a structured approach to a problem, but
I find it useful during "hack and slash" sessions when you don't necessarily
want or need a structured approach.

Some commercial terminals offer logging ([SecureCRT][SecureCRT] for example).
Linux, terminals... not so much.  No such option exists in the default Ubuntu
terminal.  There are two terminals named _Terminator_ one is [Java
based][TerminatorJava] and does not have a package in the standard Ubuntu
repositories, and the [other][TenshuTerminator] is present in Ubuntu's
standard repositories.

[SecureCRT]: http://vandyke.com/products/securecrt/index.html
[TerminatorJava]: http://software.jessies.org/terminator/
[TenshuTerminator]: http://www.tenshu.net/p/terminator.html

You can image this led to some confusion on my part... because both offer some
functionality that I wanted, but what I really wanted was a combination of the
two terminals.  It's ironic that SecureCRT offers the best solution for what I wanted.

Java Terminator:

- Terminal logging
- Good search, ala OSX Term.app (does not really work though)

Tenshu Terminator:

- Infinite scrollback (also, does not work very well)
- Tiling

So, what is a hacker to do?  Why... hack up something that works... a good
citizen of the FLOSS world would try to add these features to the terminal
emulator that they liked, but why bother when you can create a solution that
solves most of the problem in a few minutes... Really, I ended up not like the
java based Terminator at all because it was ugly and did not ingrate well with
Ubuntu, so created my own logging solution seemed like it would solve the
logging, search and infinite scrollback use cases.

## The Solution: Old Fashioned 'Script' Utility

The [script][script-info] tool is a unix utility to record everything that
passing from the shell to the terminal emulator to control things like cursor
movements, colors, and the contents of the cells on the terminal device.

[script-info]: http://ultra.pr.erau.edu/~jaffem/classes/cs125/script.htm

This is pretty heavy handed, and allows you to replay your entire terminal
session (complete with timings) if you so desire.  But this isn't the goal,
the goal is to get a terminal log, that easily searchable.

So, to start, data is needed first, so as soon as the shell is started,
everything is recorded:

``` bash shell profile additions
    if [ -z "$UNDER_SCRIPT" ]; then

        logdir=$HOME/Logs
        logname=$(date +%F_%T).$$.script

        logfile=$logdir/.$logname
        final_logfile=$logdir/$logname

        trap '( mv $logfile $final_logfile )' EXIT

        if [ ! -d $logdir ]; then
            mkdir $logdir
        fi

        gzip -q $logdir/*.script &>/dev/null

        export UNDER_SCRIPT=$logfile

        script -e -f -q $logfile
        exit $?
    fi
```

Then a [terminal emulation library][gate-one] is added:
[gate-one]: http://liftoff.github.io/GateOne/Developer/terminal.html

``` bash
    $ cd ~/Logs
    $ wget https://raw.github.com/liftoff/GateOne/master/terminal/terminal.py
```

Then a script is implemented to emulate a terminal and generate a usable log
file:

``` python ~/Logs/stripesc.py
import sys
import terminal
import locale

encoding = locale.getpreferredencoding()
term = terminal.Terminal(200,200) # bigger than we could possibly need 

fp = sys.stdin

def process_scrollback(term):
    if not term.scrollback_buf:
        return
    return term.scrollback_buf[-1].tounicode().rstrip().encode(encoding)

def make_scroll_up_cb(term):
    def _():
        print process_scrollback(term)
    return _

term.add_callback(terminal.CALLBACK_SCROLL_UP, make_scroll_up_cb(term))
```

Then, as need you'd invoke a shell script to decode a log, and grep for
something interesting:

``` bash ~/Logs/strip-escape-codes.sh
cat - | python stripesc.py
```

Also periodically, you could throw away the terminal emulation data that's no
longer needed:

``` bash ~/Logs/strip-all-escape-codes.sh
#!/bin/bash
for log_file in `ls -1 *.script.gz`; do

    zcat $log_file | python stripesc.py
        >`echo $log_file | sed -e 's/.script.gz/.log/'`

done
```

Thus, we've solved the problem with minimal effort, and maximum utility
(albeit a little cumbersome).

<!-- vim: spell:
-->
