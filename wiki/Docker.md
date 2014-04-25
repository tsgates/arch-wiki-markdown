Docker
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Docker is a utility to pack, ship and run any application as a
lightweight container.

Installation
------------

Docker can be installed with the docker package, available in the
official repositories.

Note: As of 2014/03/11, docker is still under heavy development, docker
0.8.0 does not work with lxc 1.0, use docker-git instead.

Setup
-----

This step is optional.

Edit /etc/systemd/system/docker.service as follows, where http_proxy is
your proxy server and -g <path> is your docker home. The path defaults
to /var/cache/docker.

    .include /usr/lib/systemd/system/docker.service
    [Service]
    # assume 192.168.1.1 is your proxy server, don't use 127.0.0.1
    Environment="http_proxy=192.168.1.1:3128"
    ExecStart=
    ExecStart=/usr/bin/docker -d -g /var/yourDockerDir

Note:http_proxy does not seem to work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Docker&oldid=305200"

Category:

-   Virtualization

-   This page was last modified on 16 March 2014, at 20:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
