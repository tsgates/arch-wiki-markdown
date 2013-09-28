Juniper VPN
===========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preferred installation method                                      |
| -   2 64 bit Hack                                                        |
| -   3 Another installation method                                        |
| -   4 Troubleshooting                                                    |
|     -   4.1 It keeps saying password incorrect                           |
|     -   4.2 I can login but Network Connect won't launch                 |
|     -   4.3 Network Connect launched but the VPN doesn't work            |
|     -   4.4 Network Connect launched and a configuration error message   |
|         is displayed                                                     |
|     -   4.5 ncapp.error Failed to connect/authenticate with IVE.         |
|                                                                          |
| -   5 Caveats                                                            |
| -   6 Alternative Method                                                 |
| -   7 Yet Another Method using the Mad Scientist's Ubuntu "msjnc" script |
+--------------------------------------------------------------------------+

Preferred installation method
=============================

(NOTE: In some cases, depending on your corporate policy configuration,
you _must_ login through the browser. If this is the case, command-line
tools (jnc, junipernc) won't work.)

1) Go to your companys' vpn site, log in and download / install the
juniper client.

2) Install jnc from [AUR].

3) Make a directory for the .config file:

    mkdir -p ~/.juniper_networks/network_connect/config

4) Copy and adapt this .config file in this directory:

    host=foo.bar.com
    user=username
    password=secret
    realm= realm with spaces
    cafile=/etc/ssl/bar-chain.pem
    certfile=

cafile: ca chain to verify the host certificate certfile: host
certificate in DER format Cafile or certfile must be configured, you can
download them from your vpn sign-in page (certificate information,
export certificate). realm: You can find out your realm by viewing the
page source of your vpn sign-in page: just search for the word realm in
it.

5) Start / stop network connect:

    jnc --nox

for use without GUI. To stop the client, execute

    jnc stop

64 bit Hack
===========

This was the final fix after veritable hours of trying to make it work
more properly, and it's very simple:

1) Install bin32-jre from the AUR - make sure the PKGBUILD installs it
to /opt/bin32-jre, rather than /opt/java, where it will conflict with
the 64 bit JRE.

2) Install jre from the AUR.

3) As root, mv the java binary to java.orig:

    mv /opt/java/jre/bin/java /opt/java/jre/bin/java.orig

4) Create and make executable a new java script " "

    touch /opt/java/jre/bin/java
    chmod 755 /opt/java/jre/bin/java

5) Put the following in our new java file, and you're done:

    #!/bin/bash
    if [ $3x = "NCx" ]
    then
        /opt/bin32-jre/jre/bin/java "$@"
    else
        /opt/java/jre/bin/java.orig "$@"
    fi

Bear in mind, this is a terrible hack, and if you update JRE it will
break and you'll have to repeat a few steps. That said, it worked
fantastically for me, with minimal setup if I need to hop on a VPN from
another Arch PC.

Another installation method
===========================

Here's what I did to connect to the Juniper VPN at my company:

References: Gentoo Wiki Archives

1.  Get JRE
2.  Get the really old GCC libs
    1.  Either with gcc3 and gcc2
    2.  If you're lazy like me or just can't get it to produce the
        super-old libstdc++-libc6.2-2.so.3, just steal the whole
        lib-compat from gentoo with this PKGBUILD:

    # Contributor: Clement Siuchung Cheung <clement.cheung@umich.edu>
    pkgname=lib-compat
    pkgver=1.4.1
    pkgrel=1
    pkgdesc="Gentoo lib compat for old programs only available in binary"
    arch=(x86)
    url="http://www.gentoo.org/"
    source=(ftp://ftp.ibiblio.org/pub/linux/distributions/gentoo/distfiles/${pkgname}-${pkgver}.tar.bz2)
    md5sums=('ec4a4528295b5879ad055e44c4a6d463')

    build() {
      cd $startdir/src/${pkgname}-${pkgver}/x86

      # Install /lib files
      mkdir -p $startdir/pkg/lib
      mv ld-linux.so.1* $startdir/pkg/lib

      # Install /usr/lib files
      mkdir -p $startdir/pkg/usr/lib
      mv *.so* $startdir/pkg/usr/lib

      # Fix files
      cd $startdir/pkg/usr/lib
      mv -f libstdc++-libc6.2-2.so.3 libstdc++-3-libc6.2-2-2.10.0.so
      ln -s libstdc++-3-libc6.2-2-2.10.0.so libstdc++-libc6.2-2.so.3
      mv -f libstdc++-libc6.1-1.so.2 libstdc++-2-libc6.1-1-2.9.0.so
      ln -s libstdc++-2-libc6.1-1-2.9.0.so libstdc++-libc6.1-1.so.2
      ln -s libstdc++.so.2.8.0 libstdc++.so.2.8
      ln -s libstdc++.so.2.7.2.8 libstdc++.so.2.7.2
      ln -s libg++.so.2.7.2.8 libg++.so.2.7.2
      rm -f libstdc++.so.2.9.dummy libstdc++.so.2.9.0
      rm -f libsmpeg-0.4.so.0.dummy
    }

1.  Get the smelly old Motif libs
    1.  Install lesstif. Then symlink to fool the system that it's motif
        like they say in the Gentoo wiki.
    2.  Sadly I wasn't able to get it work through the openmotif route
        because our openmotif package is too new and will give you
        libXm.so.4 instead of libXm.so.3. Add your instructions here if
        you manage to get this work.

2.  Get the su work. They use xterm to ask for root password to do the
    install. So do either of the following:
    1.  Install xterm
    2.  Setup your user to be able to su without password (google for
        the instructions)

3.  Do "sudo modprobe tun". You'll need to do it every time before you
    connect. So you might want to setup the tun module to be autoloaded
    at start up to save you time and trouble.

Troubleshooting
===============

There are many things that can go wrong. Please share your experience
here if there's something non-obvious that wasted you weeks to track
down so that others can save their time. ;-)

It keeps saying password incorrect
----------------------------------

First of all, make sure the username and password is actually
correct. ;-) Check caps lock, etc. If you swear it's correct and it
still says incorrect, that means the POST request to the Juniper IVE box
"somehow" failed.

The Tamper Data addon for Firefox can be used to debug. Try changing the
fields in the headers.

One thing that had me scratching my head for months is incorrect
charset. Juniper IVE apparently does not support UTF-8. For some
reasons, my "intl.charset.default" setting in "about:config" for Firefox
is UTF-8, causing my POST request to have *ONLY* UTF-8 in the charset.
Setting it to ISO-8859-1 fixes the problem. Also double check
"intl.accept_charsets". You can have UTF-8, Chinese and European
charsets all you want. But make sure you have ISO-8859-1 as fallback.
Use the Tamper Data addon to make sure you really are accepting
ISO-8859-1 in the HTTP header.

Another thing is the useragent must be "Firefox", not "Bon Echo". You
may need to change this under "general.useragent.extra.firefox" in
about:config.

I can login but Network Connect won't launch
--------------------------------------------

1.  Check your JRE
2.  Go to ".juniper_networks/network_connect" in your home directory.
3.  Check that ncsvc is setuid root. Fix it if not.
4.  ldd ncsvc and see if there're any missing libraries
5.  Follow instructions here to run it from command line. Use the "-L 5"
    switch to log everything, use strace as root, etc. Peek at ncsvc.log
    and see if there's anything wrong.

Network Connect launched but the VPN doesn't work
-------------------------------------------------

Run "ip route" and see if the route is there. Network connect has a
diagnosis tool in the GUI. You can also checks the logs (also available
in the GUI).

If it initially works but stops working later on, see caveat below.

Network Connect launched and a configuration error message is displayed
-----------------------------------------------------------------------

Check that you have net-tools installed.

ncapp.error Failed to connect/authenticate with IVE.
----------------------------------------------------

See my post on the ubuntu form. I was trying some of the several
'command-line' options and it turns out that in certain cases, policy
won't permit it. It had to install both bin32-jre and bin32-firefox and
authenticate through the browser.

Caveats
=======

/etc/resolv.conf will get overwritten every once in a while by DHCPCD so
your VPN will stop working eventually. If that happens, just restart
Network Connect. There's no known solution to the problem but I do find
a discussion on Redhat bugs website about this. We need to somehow teach
DHCPCD the concept of merging configs and being a good neighbor...

Until then, restart the connection every once in a while, save
/etc/resolv.conf somewhere or somehow whip up some super-clever script
yourself to restore the VPN settings every time your DHCP lease is
renewed.

Alternative Method
==================

Another method to get Juniper VPN to work for 64 bit Arch linux is
suggested for your reference. I use this method to connect to my
university's vpn network.

The key reference: http://wireless.siu.edu/install-ubuntu-64.htm

Basics

The key issue is that 64 bit java plugin do not work with the Juniper
software. (firefox, sun java jre)

One way to do it is to install an alternative version of java and link
the java plugin for the firefox manually. This saves us from the trouble
of having to deal with the chroot environment as suggested in other
sites.

These are the steps I follow:

I have firefox and sun java jre installed. I assume the system is 64 bit
Arch linux.

1.) install xterm:

pacman -S xterm

2.) install a custom 64 bit java

go to http://www.java.com/en/download select the Linux x64 verson

Decide on a location for the installation, extract the binary and put it
in the desired location, and make the binary executable with chmod +x <<
binary >>.

Finally run it to install java.

3.) install the customized 32 bit java

again, go to http://www.java.com/en/download this time, select
Linux(self-extracting) option

Extract the new binary to the same location created above, make it
executable, and run the binary. It will ask you whether you want to
replace the files to 32 bit, Type "A" to overwrite all the 64-bit files
with the 32-bit ones.

4.) link the library

the relevant library for firefox is libnpjp2.so, to link it,

ln -s << location of java you installed above >>/lib/amd64/libnpjp2.so
/usr/lib/mozilla/plugins/libnpjp2.so

The newest firefox 5 does look at /usr/lib/mozilla/plugins for plugins,
instead of the ~/.mozilla/plugins in the previous versions.

Yet Another Method using the Mad Scientist's Ubuntu "msjnc" script
==================================================================

Follow the directions here: http://www.ubuntuready.com/howtos

References: http://mad-scientist.us/juniper.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Juniper_VPN&oldid=249151"

Category:

-   Virtual Private Network
