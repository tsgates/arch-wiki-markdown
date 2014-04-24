Balsa
=====

Balsa is a small and light email client written the GNOME project. As
such it has tight integration with Gnome, however works quite well with
other desktops or window managers.

Installation
------------

Install the balsa package, available from the Official repositories.

Configuration
-------------

Balsa launches with the normal email client setup wizard that takes you
through most setup. In addition there is a preferences item on the edit
menu. Configuration files can be found in ~/.balsa.

One issue to which I found no good solution (unless you are running
GNOME) is configuring the browser to open automatically when you click
on a link in an email.

  

Note:You will want to examine other options before using this method. It
may cause breakage.

1) click on a link in an email and note which browser it is trying to
load - in my case /usr/lib/firefox/firefox.

2) Check how much of that path exists and create what is missing. I had
to create /usr/lib/firefox

    mkdir /usr/lib/firefox

3) Make a soft link to your preferred browser.

    ln -s /usr/bin/chromium /usr/lib/firefox/firefox

Retrieved from
"https://wiki.archlinux.org/index.php?title=Balsa&oldid=301632"

Category:

-   Email Client

-   This page was last modified on 24 February 2014, at 12:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
