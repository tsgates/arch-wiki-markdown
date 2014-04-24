Dash
====

Dash is a minimalist POSIX-compliant shell. It can be much faster than
Bash, and takes up less memory when in use. Most POSIX compliant scripts
specify /bin/sh at the first line of the script, which means it will run
/bin/sh as the shell, which by default in Arch is a symlink to
/bin/bash.

Contents
--------

-   1 Installation
-   2 Use DASH as default shell
    -   2.1 Identifying bashisms
        -   2.1.1 Common places to check
    -   2.2 Relinking /bin/sh
-   3 See also

Installation
------------

Install dash from the official repositories.

Use DASH as default shell
-------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

You can re-symlink /bin/sh to /bin/dash, which can improve system
performance, but first you must verify that none of the scripts that
aren't explicitly #!/bin/bash scripts are safely POSIX compliant and do
not require any of Bash's features.

> Identifying bashisms

Features of bash that aren't included in Dash ('bashisms') will not work
without being explicitly pointed to /bin/bash. The following
instructions will allow you to find any scripts that may need
modification.

Install checkbashisms from the AUR.

Common places to check

-   Installed scripts with a #!/bin/sh shebang:

    $ find {,/usr}/bin -type f \
        -exec grep -q -- '^#!/bin/sh' {} \; \
        -exec checkbashisms -f -p {} +

-   Package install scripts:

    $ find /var/lib/pacman/local -mindepth 2 -type f -name install \
        -exec checkbashisms -f -p {} + 2>&1 |\
        grep -v -e '^you may get strange results' \
                -e 'does not appear to have a #! interpreter line;$'

> Relinking /bin/sh

Once you have verified that it won't break any functionality, it should
be safe to relink /bin/sh. To do so use the following command:

    # ln -sfT /bin/dash /bin/sh

Updates of Bash could overwrite /bin/sh. To prevent this, add the
following line to the [option] section of /etc/pacman.conf:

    NoExtract   = bin/sh

See also
--------

http://article.gmane.org/gmane.linux.arch.devel/11418:

-   https://mailman.archlinux.org/pipermail/arch-dev-public/2007-November/003053.html
-   https://launchpad.net/ubuntu/+spec/dash-as-bin-sh
-   https://wiki.ubuntu.com/DashAsBinSh

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dash&oldid=303419"

Category:

-   Command shells

-   This page was last modified on 6 March 2014, at 22:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
