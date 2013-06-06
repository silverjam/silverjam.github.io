---
layout: post
title: "Android Build Tools SNAFU"
date: 2013-06-05 16:28
comments: true
categories: google android whining android-build-tools android-studio android-development-toolkit adt
---

So, I started developing for the Android platform in earnest around April of
2013.  I found that the Android project had release not just a mere plugin for
Eclipse but a rebranded, pre-customized version of Eclipse called ADT or
Android Development Toolkit.

This seemed pretty cool, I guess, though it seems better to just release a
plugin so you can slice and dice your dev environment however you want.

## Cool, but can it do Vim?

At least for the February release of ADT it did not work so well (the 20130219
version)-- installing vrapper breaks all kinds of things:

This:

{% img /images/adt-splash-screen.png %}

Turned in to this:

{% img /images/juno-splash-screen.png %}

Afterwards, all of my Android integration pre-packaged in ADT seemed to
disappear.  I had to manually re-install the Android integration that was
previously there.  Not sure why I did... maybe it was user error... but it was
not a good user experience.

## Alternate Reality: Android Studio

So far, my experience with trying the Android Studio preview has been great,
but mostly because the of the dark UI, super easy *vim installation* that didn't
*nuke any Android integration* ... and because it does stuff like this:

{% img /images/astudio-closure-fold.png %}

Finally, something that can at least make Java not look so stupid.  To quote
the [Sarah Palin jibe][jibe], *"it's just lipstick on a pig"*, but I'll take
it!  Yes sir, uh-huh.

[jibe]: http://www.cnn.com/2008/POLITICS/09/10/campaign.lipstick/

---

So... this brings me to new version of ADT (verstion 20130522) -- I'm starting
a new project I figured I'd try to upgrade to the May release of ADT.  Lo and
behold it doesn't come pre-packaged with something called *Android Build Tools*
and it has a really shitty way to install it, basically it pops up a nag box
and says:

```
Hey, we couldn't take the time to implement auto download or to auto package
this new tool we're requiring, so go grab it yourself, good luck!

Yours truly,
-Asshats
```

This wasted a good hour as I groped around trying to figure out what was wrong.
Finally the Internet saved me as I discovered that many other developers can't
read either:

- [R cannot be resolved][R1] [Stack Overflow]
- [Some else with the R problem][R2] [Google Groups]
- [Another person, same problem][R3] [Google Groups]

[R1]: http://stackoverflow.com/questions/885009/r-cannot-be-resolved-android-error
[R2]: https://groups.google.com/forum/?fromgroups#!topic/android-developers/rCaeT3qckoE
[R3]: https://groups.google.com/forum/?fromgroups=#!topic/adt-dev/epOfZbKPFdk

The thing is, I did read the nag dialog, and I tried to download whatever it
wanted, but for whatever reason (poor up bringing -- loose morals -- just plain
dumb) I didn't succeed.  So, this proves at least one thing: *Android
developers can't read*.  Or does it?  Maybe it proves that Google wasted a lot
of people's time with this decision.

<!-- vim: spell
-->
