Scponly
=======

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Openssh has this 
                           feature built-in since   
                           2008 (see                
                           http://undeadly.org/cgi? 
                           action=article&sid=20080 
                           220110039                
                           ) and scponly hasn't     
                           been updated in the      
                           major version since 2008 
                           as well (see             
                           http://sourceforge.net/p 
                           rojects/scponly/files/   
                           ). See also FS#37652.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Scponly is a limited shell for allowing users scp/sftp access and only
scp/sftp access to your box. Additionally, you can setup scponly to
chroot the user into a particular directory increasing the level of
security.

Contents
--------

-   1 Installation
    -   1.1 Prerequisites
    -   1.2 Setup
    -   1.3 Adding a chroot jail

Installation
------------

> Prerequisites

This guide assumes that you have the sshd daemon installed, configured,
and running. See Secure Shell for more information.

> Setup

Scponly resides in [community] and can be installed like any other
package:

    # pacman -S scponly

If you have a user already created, simply set the user's shell to
scponly

    # usermod -s /usr/bin/scponly username

That's it. Go ahead and test it using your favorite sftp client.

> Adding a chroot jail

-   Create chroot

    # cd /usr/share/doc/scponly/

    # ./setup_chroot.sh

-   Provide answers
-   Check that /path/to/chroot has root:root owner and r-x for others
-   Change shell for selected user to /usr/sbin/scponlyc
-   sftp-server may require some libnss modules such as libnss_files.
    Copy them to chroot's /lib

Retrieved from
"https://wiki.archlinux.org/index.php?title=Scponly&oldid=281628"

Category:

-   Networking

-   This page was last modified on 6 November 2013, at 01:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
