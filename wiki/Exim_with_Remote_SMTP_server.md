Exim with Remote SMTP server
============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Use Exim with a remote smtp server                                 |
|     -   1.1 Install Packages                                             |
|     -   1.2 Edit configuration                                           |
|     -   1.3 Update: 11-Feb-05:                                           |
|     -   1.4 Update: 10-Feb-08:                                           |
|     -   1.5 Using GMail as smarthost:                                    |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 451 Temporary local problem                                  |
+--------------------------------------------------------------------------+

> Use Exim with a remote smtp server

This document describes how to set up Exim (a mail transfer agent) to
use a remote smtp server, for example your ISP's smtp server.

Install Packages

    # pacman -S exim

Edit configuration

Edit /etc/mail/exim.conf and add or change the following

In Main Configuration Settings uncomment primary_hostname and add the
hostname of your box (see the /etc/hostname file)

    primary_hostname = myhostname          # change to your hostname

At the end of the Routers Configuration section add

    passonto_isp:
      driver = manualroute
      domains = !+local_domains
      transport = remote_smtp
      route_list = * smtp.myisp.com        # change to the desired smtp server

Make sure that in Transports Configuration it says (uncommented)

    remote_smtp:
      driver = smtp

* * * * *

If you have a laptop, or a machine in a smarthost configuration, where
you do not want the name of the machine to appear in the outgoing email
then you must enable exim's rewriting facilities.

In the Rewriting section you should have something like:

    *@machine.mydomain $1@mydomain

where machine is the hostname of your laptop or PC and mydomain is the
domain name of the machine and the outgoing mail.

Update: 11-Feb-05:

FYI - I just got done wrestling with Exim (4.44) to get it up and
running in this configuration on my machine, and I had to do a number of
things quite differently than the other person. Thought I'd capture them
here for posterity, since I had to go through a pretty painful process
that cost me a lot of time and aggravation before I hit upon the right
config. Hopefully this'll save others from a similar fate.

By the way, I should note: my Exim server does not receive any emails
directly from the Net. I'm using fetchmail to grab the mail's from an
external POP mail drop and dump them into my Exim server. So perhaps
this is different than the other person's configuration.

Anyway, here's what worked for me.

I did not need to update primary_hostname. If you leave it commented
out, like this:

    # primary_hostname =

then exim will just automatically use whatever your system's hostname
command outputs. (i.e., the HOSTNAME that you have set in rc.conf.) I
very much DID need to update this line:

    domainlist local_domains = @

and it caused me much grief until I got it right! In my case, it needed
to look like this:

    domainlist local_domains = @:localhost:mydnamicdnshostname.homeip.net

I think the dynamic dns entry might be optional (since I never really
deliver any mail to an address at that FQDN), but the @ and the
localhost are both critical.

-   @ basically means again to use whatever your system's hostname
    command outputs. That's needed because some daemons that run on your
    box may try to send emails to the root user at the host, and they
    will get rejected if you do not have the @ entry.
-   localhost was necessary in order to allow fetchmail to deliver all
    the messages that it fetched. Without that entry there, Exim would
    fail to deliver them, and then generate a bounce message in
    response. Even worse, most of my fetched messages were spam, and so
    it would try to send the bounce back to the return address on the
    spam which 1) often was forged, and thus a bad thing to do, and 2)
    often would get rejected either due to an invalid email address or
    because I was trying to initiate email from a residential dynamic IP
    address and thus was also a bad thing to do. In the latter case,
    those messages wound up frozen on the queue, and I had to spend some
    time manually purging them from the queue. Just a bad situation all
    around until I got this piece right.
-   I also wanted to allow other boxes on my LAN to relay messages
    through this exim server. By default, though, that's blocked. You
    can enable it by changing this:

    hostlist   relayfromhosts = 127.0.0.1

to this:

    hostlist   relayfromhosts = 127.0.0.1 : 192.168.0.0/24

While, you are at it, it actually couldn't hurt to make it this:

    hostlist   relayfromhosts = 127.0.0.1 : ::::1 : 192.168.0.0/24

(The ::::1 is just the ipv6 equivalent of 127.0.0.1)

Despite what was written by the other person, I found that that the
passonto_isp router should NOT go at the end of the Routers
Configuration section. Since it's at the end, it won't get executed if
some other router gets executed first, and that's exactly what was
happening to me. This router, which appears before it was getting
executed instead:

    dnslookup:
      driver = dnslookup
      domains = ! +local_domains
      transport = remote_smtp
      ignoretargethosts = 0.0.0.0 : 127.0.0.0/8
      no_more

That router might be desired in some configurations, but not this one.
That will cause exim to try to deliver the message itself, rather than
passing it on to your ISP's MTA. (And as I indicated above, that will
often fail if you are on a residential dynamic IP adddress.) To set this
up properly, do it like this:

    #dnslookup:
    #  driver = dnslookup
    #  domains = ! +local_domains
    #  transport = remote_smtp
    #  ignoretargethosts = 0.0.0.0 : 127.0.0.0/8
    #  no_more

    passonto_isp:
      driver = manualroute
      domains = !+local_domains
      transport = remote_smtp
      route_list = * smtp.myisp.com        # change to the desired smtp server

One last thing: make sure to also update the /etc/mail/aliases file, if
you have got any daemons running on your box that need to send email to
the root user. You'll probably want those emails to get delivered to
your non-root user account instead, and this is how you set that
behavior. Look for these lines:

    # Person who should get root's mail
    #root:

And uncomment and add your local user account to the root: line:

    # Person who should get root's mail
    root: johndoe

Hope this all spares someone some hair-pulling and lost sleep down the
road. I wish I had read an entry like this before I started - I wouldn't
be so tired right now!

Update: 10-Feb-08:

    passonto_isp:
      driver = manualroute
      domains = !+local_domains
      transport = remote_smtp
      route_list = * smtp.myisp.com        # change to the desired smtp server

should be changed to

    send_to_gateway:
      driver = manualroute
      domains = !+local_domains
      transport = remote_smtp
      route_list = * smtp.myisp.com        # change to the desired smtp server

Using GMail as smarthost:

Add a router before or instead of the dnslookup router:

    gmail_route:
      driver = manualroute
      transport = gmail_relay
      route_list = * smtp.gmail.com

Add a transport:

    gmail_relay:
      driver = smtp
      port = 587
      hosts_require_auth = $host_address
      hosts_require_tls = $host_address

Add an authenticator (replacing myaccount@gmail.com and mypassword with
your own account details):

    gmail_login:
      driver = plaintext
      public_name = LOGIN
      hide client_send = : myaccount@gmail.com : mypassword

$host_address is used for hosts_require_auth and hosts_require_tls
instead of smtp.gmail.com to avoid occasional 530 5.5.1 Authentication
Required errors. These are caused by the changing IP addresses in DNS
queries for smtp.gmail.com. $host_address will expand to the particular
IP address that was resolved by the gmail_route router.

For added security, use a per-application password. This works with
Google Apps accounts as well.

Troubleshooting
---------------

> 451 Temporary local problem

If you are getting a "451 Temporary Local Problem" when testing SMTP,
you are probably sending as root. By default Exim will not allow you to
send as root.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Exim_with_Remote_SMTP_server&oldid=233277"

Category:

-   Mail Server
