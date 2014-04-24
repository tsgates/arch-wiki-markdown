AOLserver
=========

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Aolserver 4.5 http://www.aolserver.com http://www.tcl.tk

What are the advantages over any other web server?

20x Faster and massively scalable, and has all the features of an
appserver builtin.

Phil Greenspun said it best:
http://philip.greenspun.com/wtr/aolserver/introduction-1.html

notes on Installation: (read README)

get+compile your own tcl 8.4: (example)

    ./configure --prefix=/opt/tcl --enable-threads --enable-shared
    make
    make install

I pop it in my path:

    ln -s /opt/tcl/bin/tclsh8.4 /usr/bin/tclsh

was a real bitch for me on Arch Linux this time around after it was easy
before; until a guy named frankie on irc chat #aolserver (freenode
server) gave me the following:

In aolserver-4.5/configure, comment out the below lines, and add right
below them:

    # case "$LDLIB" in
    # *gcc*)
    # LDLIB="$LDLIB -nostartfiles"
    # ;;
    # esac
    LDLIB="$LDLIB -nostartfiles"

    this now works:
    /path/to/tclsh8.4 nsconfig.tcl -install /aolservers_new_dir
    make
    make install

In /etc/hosts you must have the ip of your nic matching `uname -n`

    after you cp base.tcl to nsd.tcl; you must 
    chown -R your_user: /aolservers_new_dir 

vi /etc/ld.so.conf and add path to tcl and aolserver /lib directory
close and run ldconfig

cp -p base.tcl nsd.tcl

bin/nsd -ft nsd.tcl -u your_user & will start the server on port 8000.

then tune into http://your_ip:8000 and blam! your in bizness

fro a little guidance check out http://philip.greenspun.com/tcl/

Resources
---------

-   AOLserver on Wikipedia

AOLserver's Wikipedia page, with slightly more background and history.

Retrieved from
"https://wiki.archlinux.org/index.php?title=AOLserver&oldid=240566"

Category:

-   Web Server

-   This page was last modified on 16 December 2012, at 11:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
