Identd Setup
============

The Ident service as specified by RFC 1413 is mostly used by various IRC
networks and the occasional old FTP server to ask a remote server which
user is making a connection. This method is quite untrustworthy, as the
remote host can simply choose to lie.

So you have two choices:

1.  Tell the truth (see pidentd below)
2.  Tell a little white lie (see nullident below)

pIdentd
-------

Like most people, I prefer to run identd from from inetd instead of as a
stand-alone service. For this to work you will need to install two
packages: xinetd and pidentd. I tried this with oidentd but it does not
seem to work with the latest xinetd.

1. Install needed software

    # pacman -S xinetd pidentd

2. Next, you will need to paste the following into a new file and save
it as /etc/xinetd.d/auth

    service auth
    {
          flags = REUSE
          socket_type = stream
          wait = no
          user = nobody
          server = /usr/sbin/identd
          server_args = -m -N
          logonfailure += USERID
          disable = no
    }

3. After you have saved the new file, run xinetd with the following
command

    # systemctl start xinetd.service

If all went well, you should have the auth service running on port 113.
A good way of checking this is by installing nmap (if you do not have it
already) and typing

    $ nmap localhost

Retrieved from
"https://wiki.archlinux.org/index.php?title=Identd_Setup&oldid=253859"

Category:

-   Networking
