Frandom
=======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Needs updating   
                           to SystemD (Discuss)     
  ------------------------ ------------------------ ------------------------

frandom is a fast alternative to /dev/urandom. It can be used wherever
fast random number generation is required, eg for randomising large hard
drives prior to encryption.

From the frandom page: "The frandom suite comes as a Linux kernel module
for several kernels, or a kernel patch for 2.4.22. It implements a
random number generator, which is 10-50 times faster than what you get
from Linux' built-in /dev/urandom."

Does frandom generate good random numbers? Refer to the frandom page for
this and other technical info.

Beneath in the example section, you'll find 'real', 'user' and 'sys'
information, what they mean you can find here.

Installation
------------

Frandom is available as a package from the AUR.

Once the daemon has been started, it is available from /dev/frandom. It
is run in the normal way:

    # /etc/rc.d/frandom {start|stop|restart}

Or if you prefer, it can be started at boot by adding it /etc/rc.conf:

    DAEMONS=(... frandom ...)

Wiping a disk
-------------

Use the following dd command. This will wipe all the data on the
specified device, take care!

    # dd if=/dev/frandom of=/dev/sdx1

Refer to Securely wipe disk for more general info on this topic.

Example
-------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           Benchmarking disk wipes. 
                           Notes: Maybe anyone can  
                           bring this to nicer      
                           Formatting, move it      
                           there and link to it?    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

1) On a 1.73 GHZ Thinkpad T43 with 2 GB ram:

    # time dd if=/dev/frandom of=/dev/sdb2
     dd: writing to `/dev/sdb2': No space left on device
     587384596+0 records in
     587384595+0 records out
     300740912640 bytes (301 GB) copied, 12844.6 s, 23.4 MB/s
     real    214m4.620s
     user    3m34.693s
     sys     77m28.660s

Summary: 300 GB in approx 3.5 hours

  
 2) On a 2.4 GHZ (T8300 Core 2 Duo) Thinkpad T61 with 2 GB ram:

    # dd if=/dev/frandom of=/dev/sdb bs=1M
      dd: writing `/dev/sdb': No space left on device
      476941+0 records in
      476940+0 records out
      500107862016 bytes (500 GB) copied, 5954.52 s, 84.0 MB/s

Summary: 500 GB in approx 1.65 hours

  
 3) On a 2.8 GHz (Athlon2 X4) with 4 GB ram:

    # dd if=/dev/frandom of=/dev/sdc3 bs=1M seek=100KB
      dd: writing `/dev/sdc3': No space left on device
      1807429+0 records in
      1807428+0 records out
      1895225712640 bytes (1.9 TB) copied, 20300.3 s, 93.4 MB/s

Summary: ~2TB in ~5.64 hours. However, on the same machine:

    # dd if=/dev/frandom of=/dev/null bs=1M count=1000
      1000+0 records in
      1000+0 records out
      1048576000 bytes (1.0 GB) copied, 7.81581 s, 134 MB/s

versus

    # dd if=/dev/urandom of=/dev/null bs=1M count=1000
      1000+0 records in
      1000+0 records out
      1048576000 bytes (1.0 GB) copied, 144.296 s, 7.3 MB/s

This makes frandom 10-20 times faster on this machine, meaning it would
take approx 50-120 hours (2-5 days!) to randomize 2TB using urandom.

4) On a 2.70GHz (i7-2620M) ThinkPad x220 with 8GB Ram:

    # time dd if=/dev/frandom of=/dev/sdc
      dd: writing to `/dev/sdc': No space left on device
      625140336+0 records in
      625140335+0 records out
      320071851520 bytes (320 GB) copied, 9618.12 s, 33.3 MB/s
      real    160m18.126s
      user    1m8.916s
      sys     36m16.401s

Summary: 320 GB in approx. 2.67 hours

5) On a 2.70GHz (i7-2620M) ThinkPad x220 with 8GB Ram:

    # time dd if=/dev/frandom of=/dev/sdc
      dd: writing to `/dev/sde': Input/output error
      467085833+0 records in
      467085832+0 records out
      239147945984 bytes (239 GB) copied, 24675.2 s, 9.7 MB/s
      real    411m15.208s
      user    2m58.028s
      sys     83m14.188s

Summary: 500 GB in approx. 6.85 hours (connected on USB3)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Frandom&oldid=302459"

Categories:

-   Security
-   File systems

-   This page was last modified on 28 February 2014, at 17:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
