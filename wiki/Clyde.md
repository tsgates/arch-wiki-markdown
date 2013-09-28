Clyde
=====

Summary

Overview and a comprehensive FAQ for clyde, the package manager

Related

pacman

AUR

Resources

Github page (source code)

Bug tracker

Forum topic

Warning:Clyde is an unofficial, third-party package manager, unsupported
by Arch devs.

Note:As of 2011-07-18 it is not actively developed anymore.

Clyde is a replacement for Arch Linux's pacman. It is written in the Lua
programming language and uses lualpm (a Lua binding to libalpm) as its
backend. It is intended to be a unified replacement for other package
management utilities (specifically it intends to replace powerpill (now
discontinued) and Yaourt).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Using Clyde                                                        |
| -   3 FAQ                                                                |
|     -   3.1 Who is Clyde?!                                               |
|     -   3.2 I hate typing sudo every time.                               |
|     -   3.3 I changed my pacman.conf but Clyde seems to ignore it        |
|     -   3.4 Does Clyde build packages with root permission?              |
|     -   3.5 I found a bug, where is the bugtracker?                      |
|     -   3.6 Clyde not working behind a proxy                             |
+--------------------------------------------------------------------------+

Installation
------------

You can find clyde in AUR. For installation help read this page.

Using Clyde
-----------

Same as pacman. But as Clyde also supports the AUR you can easily update
those packages too:

    clyde -Syu --aur

Tip:Try out clyde --stats

FAQ
---

> Who is Clyde?!

Clyde is the orange ghost in the original Pac-Man arcade game. See?

> I hate typing sudo every time.

You can configure your shell to run clyde with sudo when necessary by
putting the following code into your ~/.bashrc or ~/.zshrc:

    clyde() {
       case $1 in
           -S | -S[^sih]* | -R* | -U*)
               /usr/bin/sudo /usr/bin/clyde "$@" ;;
           *)
               /usr/bin/clyde "$@" ;;
       esac
    }

Or this one if you do not use sudo:

    clyde() {
       case $1 in
           -S | -S[^sih]* | -R* | -U*)
               /bin/su -c /usr/bin/clyde "$@" ;;
           *)
               /usr/bin/clyde "$@" ;;
       esac
    }

> I changed my pacman.conf but Clyde seems to ignore it

Well yes, it ignores your pacman.conf. Edit your /etc/clyde.conf

You can also replace the pacman part of your clyde.conf with the
following line:

    clyde.conf

    Include = /etc/pacman.conf

This can be important if you add multilib to pacman but forget to add it
to clyde, as it can result in odd issues where clyde tries and fails to
install multilib packages from the AUR.

> Does Clyde build packages with root permission?

No. If you take a closer look at the output, you may note that clyde
uses fakeroot to build packages, and that the password that is needed at
the start is only really used when libaplm/luaplm install the packages,
at the end of the process.

> I found a bug, where is the bugtracker?

Of course, clyde has no bugs. But there are unexpected
behaviours :).Here.

> Clyde not working behind a proxy

Try tsocks, you can find it in the extra repo.

edit tsocks' configuration file and then run:

    tsocks clyde -Ss something

Alternatively you can try proxychains, which is a similar program.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Clyde&oldid=238330"

Categories:

-   Package management
-   Arch User Repository
