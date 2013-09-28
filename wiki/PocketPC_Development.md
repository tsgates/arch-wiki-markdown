PocketPC Development
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Install CE GCC
--------------

Execute

     pacman -S cegcc

to install CE GCC package group.

Configuring
-----------

Put following lines into /etc/profile.d/cegcc.sh

     export PATH=/opt/cegcc/bin:$PATH
     export MANPATH=$MANPATH:/opt/cegcc/man:/opt/cegcc/share/man

Compiling applications
----------------------

You may use tests/Cplusplus folder from cegcc-0.50-src.tar.gz source
tarball as an example.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PocketPC_Development&oldid=197988"

Category:

-   Development
