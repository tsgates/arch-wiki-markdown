DnsExit
=======

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Advertisement    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Background
----------

Q. What services does DnsExit.com provide?

A. We provide domain name registration, dynamic / static DNS services,
URL forwarding, Backup Mail service, Email Forwarding service, Email
Redirection service. DnsExit.com provides a convenient single-location,
integrated, web-based domain manager for configuring all of the services
provided. Click here to learn more.

dnsExit Client
--------------

The main dnsExit client comes in .deb, .rpm and .tar.gz downloads. Even
though the client is written in Perl, several things need to be modified
for Arch Linux.

Get the tarball from this address.

Installation
------------

Unpack the archive, go to the folder, and type:

    # perl setup.pl

The wizard is pretty self explanatory. After that, you need to run the
program so it generates the .pid file as it doesn't do that with the
initial setup.pl script for Arch:

    # perl ipUpdate.pl

Then it is necessary to copy the script itself so you can run it as a
daemon:

    # cp ipUpdate.pl /usr/sbin/ipUpdate.pl

We also need to copy:

    # cp Http_get.pm /usr/sbin/Http_get.pm

Retrieved from
"https://wiki.archlinux.org/index.php?title=DnsExit&oldid=254970"

Category:

-   Domain Name System
