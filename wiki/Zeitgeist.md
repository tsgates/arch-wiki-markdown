Zeitgeist
=========

  Summary help replacing me
  ----------------------------------------------
  Provides an overview and setup of Zeitgeist.

Zeitgeist is a service which logs user activities and events, anywhere
from files opened to websites visited or conversations held via email
and more. It makes this information readily available for other
applications to use in the form of timelines and statistics. See the
Wikipedia article for a more detailed description of Zeitgeist itself.

Installation
------------

Install zeitgeist from the official repositories, which includes the
daemon and the datahub. The daemon receives metadata from data sources,
and provides them to applications using D-Bus. The datahub provides
passive plugins which insert events into Zeitgeist.

To configure what gets logged by Zeitgeist, install activity-log-manager
which provides a graphical user interface where you can filter out
specific folders, file types, and applications. The GNOME Control Center
also has a Privacy module where you can make similar adjustments.

To monitor and inspect Zeitgeist's log at a low level, install
zeitgeist-explorer which provides a graphical user interface where you
can see the events logged in real-time just like wireshark.

> Data providers

The following applications are just some of the apps which are able to
send metadata to Zeitgeist. In some cases this functionality must be
enabled manually.

-   bijiben
-   gedit
-   midori
-   quodlibet-plugins
-   rhythmbox
-   totem
-   zim

zeitgeist-datasources can be also installed from the AUR, which provides
some third party plugins for other applcations.

> Applications

The following applications can be used to browse or search for recent
activity using the Zeitgeist engine:

-   cairo-dock-plugins
-   catfish
-   gnome-activity-journal
-   synapse
-   unity

For more information see http://zeitgeist-project.com/experience/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Zeitgeist&oldid=289825"

Category:

-   Daemons and system services

-   This page was last modified on 21 December 2013, at 23:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
