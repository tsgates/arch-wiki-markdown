Hula
====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is a guide for how to build Hula ([1]) a calendar and mail server.
This guide does not explain how to configure it, just build it and
access the administration GUI.

Contents
--------

-   1 Installing necessary packages
-   2 Getting the source.
-   3 Building Hula.
-   4 Completing the installation.
-   5 Starting hula.

Installing necessary packages
-----------------------------

Hula itself does not have many dependencies, but there are packages that
are needed to build Hula: subversion and pkgconfig

Getting the source.
-------------------

The sources needed to be download using subversion from the hula
repository.

     svn checkout svn+ssh://anonymous@forgesvn1.novell.com/svn/hula/trunk

The password is 'anonymous' it may need to be typed twice.

Note: per this page: www.hula-project.org/Source_Code:

If you do not have developer access to the Subversion repository, you
can still get read-only anonymous access to the code. To check out the
hula module anonymously, run:

      svn checkout https://forgesvn1.novell.com/svn/hula/trunk

This was previously on an anonymous SSH account: that has now changed.

Building Hula.
--------------

Since the sources have been downloaded using subversion, we simply need
to run ./autogen.sh, make, and make install.

    $ ./autogen.sh --prefix=/opt/hula/
    make
    make install

The --prefix=/opt/hula makes sure hula gets installed to /opt/hula.

Completing the installation.
----------------------------

There are a few steps left to completing the installation.

    cd /opt/hula/sbin
    ./hulasetup --domain=your.domain.com

If you do not specifiy --domain it will default to
localhost.localdomain. Also, if you have apache running on port 80 I
recommend doing something like:

    ./hulasetup --http=8080

But the port the web service runs on can always be changed later from
the administration page. The port the administration GUI runs on can
also be changed later.

Starting hula.
--------------

To start Hula, run /opt/hula/sbin/hulamanager.

Finally, just open http://localhost:89 in your favorite web browser to
access the administration GUI. The default username is admin and the
password is hula. I recommend adding /opt/hula/sbin/hulamanager to your
/etc/rc.local to get hula to start on boot. These can be changed later
on.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hula&oldid=250458"

Category:

-   Web Server

-   This page was last modified on 13 March 2013, at 04:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
