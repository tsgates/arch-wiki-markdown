Stumpwm
=======

StumpWM is a tiling, full-screen window manager written entirely in
Common Lisp. The successor to the cult classic Ratpoison window manager
("GNU Screen to the power of X"), StumpWM adds all the flexibility and
hackability of common lisp, allowing the user to make modifications to
the source of the window manager even while it is running.

From the StumpWM homepage:

If you're tired of flipping through themes like channel-surfing, and
going from one perfect-except-for-just-one-thing window manager to
another even-more-broken-in-some-other-way then perhaps Stumpwm can
help.

Stumpwm attempts to be customizable yet visually minimal. There are no
window decorations, no icons, and no buttons. It does have various hooks
to attach your personal customizations, and variables to tweak.

Want to see it in action? A StumpWM user created a video.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 With SBCL (recommended, will run faster)                     |
|         -   1.1.1 With Quicklisp (recommended)                           |
|         -   1.1.2 With AUR                                               |
|                                                                          |
|     -   1.2 With Clisp                                                   |
|                                                                          |
| -   2 Documentation and Support                                          |
| -   3 Tweaking                                                           |
| -   4 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Installation
------------

> With SBCL (recommended, will run faster)

With Quicklisp (recommended)

WARNING:Only use root to install SBCL and, if you want to, run "make
install".

1.  Install SBCL
    -   pacman -S sbcl

2.  Get Quicklisp at the Quicklisp website
    -   curl -O http://beta.quicklisp.org/quicklisp.lisp

3.  Load Quicklisp with SBCL
    -   sbcl --load quicklisp.lisp

4.  Install Quicklisp
    -   (quicklisp-quickstart:install) or
        (quicklisp-quickstart:install :path "path/of/your/choice")

5.  Add it to your SBCL init file
    -   (ql:add-to-init-file)

6.  Check for updates of Quicklisp (not needed if you have just
    downloaded it)
    -   (ql:update-client)

7.  Check for updates on Quicklisp
    -   (ql:update-all-dists)

8.  Install CLX and CL-PPCRE
    -   (ql:quickload "clx")
    -   (ql:quickload "cl-ppcre")

9.  Quit SBCL with (quit)
10. Get the git version of StumpWM
    -   git clone git://github.com/sabetts/stumpwm.git

11. Get into the stumpwm folder and start compiling
    -   cd stumpwm && ./autogen.sh && ./configure && make
    -   You can optionally run "make install" as root.

12. Put the StumpWM binary path into your .xinit and have fun! :)

Optional: Install slime/swank for nonstop real-time hacking:

1.  Install swank server
    -   (ql:quickload "swank")

2.  Install slime-helper
    -   (ql:quickload "quicklisp-slime-helper")

3.  Paste the following into your dot-emacs
    -   (load (expand-file-name "/path/to/slime-helper.el"))
    -   (setq inferior-lisp-program "sbcl")

4.  Now put the following into your .stumpwmrc or just eval during your
    stumpwm-session
    -   (require 'swank)
    -   (swank:create-server)

5.  Connect Emacs/Slime to your stumpwm-session using
    -    M-x slime-connect

With AUR

1.  Install SBCL
    -   pacman -S sbcl

2.  Install clx from AUR.
    -   If you really do not want to use a PKGBUILD here, you can also
        use asdf-install to install clx.

3.  Install cl-ppcre
    -   Again, this can be installed with asdf-install if you really do
        not like PKGBUILDs.

4.  Install git
    -   pacman -S git

5.  Install stumpwm from AUR.
    -   Alternately, you can check it out directly from the git repo.,
        as described on the [ homepage]. Read the directions and check
        the StumpWM wiki for compilation instructions.

> With Clisp

1.  Get and create these packages from AUR in the following order making
    sure to have makepkg install dependencies first (makepkg -s):
    -   clisp-new-clx
    -   cl-asdf
    -   cl-ppcre. To get this to install, I had to comment out the
        dependency line in the PKGBUILD.
    -   stumpwm-git. Alternatively, download the latest version from the
        web site and follow the install instructions. The executable can
        stay in your home directory tree.

2.  Make sure to install each one (sudo pacman -U name.pkg.tar.gz)
    before installing the next.
3.  See the Makepkg article for details on downloading and installing
    from AUR (compiling/creating package and installing).

Also, look at this post if you run into troubles.

Documentation and Support
-------------------------

If you installed StumpWM by hand or still have the source lying around,
there is a TeXInfo manual.

There is also a wiki, an IRC channel (#stumpwm) on Freenode, and a
mailing list. For more information, of course, see the project's
website.

Tweaking
--------

See the wiki for a variety of useful tweaks for your .stumpwmrc.

If you are an emacs user, you will find an emacs minor mode for editing
StumpWM files (and interfacing with the program stumpish, but more on
that below) in the contrib/ directory of the StumpWM source. If you are
using clisp, this file can also be found in /usr/share/stumpwm/.

stumpish is the STUMP window manager Interactive SHell. It is a program
that allows the user to interact with StumpWM while it is running, from
the comfort of a terminal (or using the emacs mode). It can be found in
the contrib/ directory of the StumpWM source. If you use clisp, this
file can also be found in /usr/bin/.

Troubleshooting
---------------

If you cannot start stumpwm and get

               debugger invoked on a SB-INT:SIMPLE-PARSE-ERROR in thread
           #:
           no non-whitespace characters in string "".
           Type HELP for debugger help, or (SB-EXT:QUIT) to exit from SBCL.
           (no restarts: If you did not do this on purpose, please report it as a bug.)
           (PARSE-INTEGER "" :START 0 :END NIL :RADIX 10 :JUNK-ALLOWED NIL)

In the REPL,It can be solved by delete the .Xauthority in your home
diretory. You can refer it atIssue on github

Retrieved from
"https://wiki.archlinux.org/index.php?title=Stumpwm&oldid=253286"

Category:

-   Tiling WMs
