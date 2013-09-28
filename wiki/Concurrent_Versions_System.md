Concurrent Versions System
==========================

"Concurrent Versions System is a version control system, an important
component of Source Configuration Management (SCM). Using it, you can
record the history of sources files, and documents. It fills a similar
role to the free software RCS, PRCS, and Aegis packages."

This is a quick guide on how to set up the latest CVS server.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Initialization                                                     |
| -   3 Configuration                                                      |
| -   4 Use                                                                |
+--------------------------------------------------------------------------+

Installation
------------

Update or install to the latest version of cvs and xinetd (as root):

    # pacman -S cvs xinetd

Create the cvs group - members of this group will have write access to
the repository (as root):

    # groupadd cvs

Create the cvs user in the cvs group (-md makes the home directory) (as
root):

    # useradd -md /home/cvsroot -g cvs -p Insecure0 cvs

Initialization
--------------

Initialize your CVS repository (as cvs):

    cvs% cvs -d /home/cvsroot init

The permissions on the directory (not the files inside, however) should
be 2775 (drwxrwxr-x), but if not, run (as cvs):

    cvs% chmod 2775 /home/cvsroot

Add any users that you want to have local access to the repository to
the group cvs by using the following two steps. You can add pre-existing
users to the cvs group with the command (as root):

    # gpasswd -a username cvs

Make a file in /etc/xinetd.d/ called cvspserver with these contents (as
root):

    service cvspserver
    {
            port            = 2401
            socket_type     = stream
            protocol        = tcp
            wait            = no
            user            = root
            passenv         = /home/cvsroot
            server          = /usr/bin/cvs
            server_args     = -f --allow-root=/home/cvsroot pserver
    }

Edit /etc/services and add this line containing the information for
cvspserver service if does not exist (as root):

    cvspserver 2401/tcp     #CVS PServer

Unset the variable HOME before you restart xinetd:

    # unset HOME

Now restart xinetd (as root):

    /etc/rc.d/xinetd restart

Configuration
-------------

Become cvs ("su cvs") and create a 'passwd' file in ~/CVSROOT. To add
entries in the file you can use htpasswd command (present in the apache
package) like that:

    htpasswd -b filename username password

then edit che file and add che group, should look like this:

    # Format is username:password:group

    anonymous::
    luser:HopefullySecure0:cvs
    other:Insecure0:cvs

Now create a 'writers' file in ~/CVSROOT, which grants write privileges
to the users you created in 'passwd':

    luser
    other

Now create a 'readers' file in ~/CVSROOT, which grants read privileges
to the users you created in 'passwd':

    anonymous

Note:If a user is present in the readers file cannot have write access
too.

Use
---

You can test out the server using the following commands:

    export CVSROOT=:pserver:my_user_name@127.0.0.1:/home/cvsroot
    cvs login
    mkdir ~/sandbox
    mkdir ~/sandbox/myproject
    cd ~/sandbox/myproject
    echo "this is a sample file" > myfile
    cvs import -m "description of myproject" myproject v1 r1
    cd ..
    rm -R myproject
    cvs checkout myproject
    cd myproject
    echo "some changes to the file" >> myfile
    cvs commit -m "Explain changes here" myfile

Retrieved from
"https://wiki.archlinux.org/index.php?title=Concurrent_Versions_System&oldid=254353"

Category:

-   Version Control System
