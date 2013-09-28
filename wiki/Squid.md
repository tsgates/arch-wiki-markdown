Squid
=====

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

From the squid website:

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and
more. It reduces bandwidth and improves response times by caching and
reusing frequently-requested web pages. Squid has extensive access
controls and makes a great server accelerator. It runs on Unix and
Windows and is licensed under the GNU GPL.

While squid works wonderfully in large corporations and schools, it can
also benefit the home user too. However, if you're looking for a more
lightweight single-user proxy, you should try Polipo.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Accessing services on local hostnames                              |
| -   4 Starting                                                           |
| -   5 Content Filtering                                                  |
| -   6 Frontend                                                           |
| -   7 Ad blocking with adzapper                                          |
|     -   7.1 Installation                                                 |
|     -   7.2 Configuration                                                |
|                                                                          |
| -   8 Anti-virus layer                                                   |
|     -   8.1 Installing dependencies                                      |
|     -   8.2 Configuration                                                |
|     -   8.3 Testing                                                      |
|                                                                          |
| -   9 Transparent web proxy                                              |
|     -   9.1 iptables                                                     |
|     -   9.2 Shorewall                                                    |
|                                                                          |
| -   10 HTTP Authentication                                               |
|     -   10.1 NTLM                                                        |
|                                                                          |
| -   11 Additional Resources                                              |
+--------------------------------------------------------------------------+

Installation
------------

Install squid available in the Official Repositories.

Configuration
-------------

By default, the cache directories will be created in /var/cache/squid,
and the appropriate permissions set up for those directories. However,
for greater control, we need to delve into /etc/squid/squid.conf.

Everything is well commented, but if you want to strip the comments out
you should run:

    sed -i "/^#/d;/^ *$/d" /etc/squid/squid.conf

The following options might be of some use to you. If you do not have
the option present in your configuration file, add it!

-   http_port - Sets the port that Squid binds to on your local machine.
    You can have Squid bind to multiple ports by specifying multiple
    http_port lines. By default, Squid binds to port 3128.

    http_port 3128
    http_port 3129

-   http_access - This is an access control list for who is allowed to
    use the proxy. By default only localhost is allowed to access the
    proxy. For testing purposes, you may want to change the option
    http_access deny all to http_access allow all, which will allow
    anyone to connect to your proxy. If you wanted to just allow access
    to your subnet, you can do:

    acl ip_acl src 192.168.1.0/24
    http_access allow ip_acl
    http_access deny all

-   cache_mgr - This is the email address of the cache manager.

    cache_mgr squid.admin@example.com

-   shutdown_lifetime - Specifies how long Squid should wait when its
    service is asked to stop. If you're running squid on your desktop
    PC, you may want to set this to something short.

    shutdown_lifetime 10 seconds

-   cache_mem - This is how much memory you want Squid to use to keep
    objects in memory rather than writing them to disk. Squid's total
    memory usage will exceed this! By default this is 8MB, so you might
    want to increase it if you have lots of RAM available.

    cache_mem 64 MB

-   visible_hostname - hostname that will be shown in status/error
    messages

    visible_hostname cerberus

-   cache_peer - If you want your Squid to go through another proxy
    server, rather than directly out to the Internet, you need to
    specify it here.
-   login - Use this option if the parent proxy requires authentication.
-   never_direct - Tells the cache to never go direct to the internet to
    retrieve a page. You will want this if you have set the option
    above.

    cache_peer 10.1.1.100 parent 8080 0 no-query default login=user:password
    never_direct allow all

-   maximum_object_size - The largest size of a cached object. By
    default this is small (256KB I think), so if you have a lot of disk
    space you will want to increase the size of it to something
    reasonable.

    maximum_object_size 10 MB

Note:After defining a new cache_dir it maybe necessary to initialize the
caches directory structure with this command: squid -zN -z for Create
missing swap directories and -N for No daemon mode.

-   cache_dir - This is your cache directory, where all the cached files
    are stored. There are many options here, but the format should
    generally go like:

    cache_dir <storage type> <directory> <size in MB> 16 256

So, in the case of a school's internet proxy:

    cache_dir diskd /cache0 200000 16 256

If you change the cache directory from defaults, you must set the
correct permissions on the cache directory before starting Squid, else
it won't be able to create its cache directories and will fail to start.

Accessing services on local hostnames
-------------------------------------

If you plan to access web servers on the LAN using hostnames that are
not fully-defined (e.g. http://mywebapp), you may need to enable the
dns_defnames option. Without this option, Squid will make a DNS request
for the hostname verbatim (mywebapp), which may fail, depending on your
LAN's DNS setup. With the option enabled, Squid will append any domain
configured in /etc/resolv.conf when making the request (e.g.
mywebapp.company.local).

    dns_defnames on

Starting
--------

Once you have finished your configuration, you should check that your
configuration file is correct:

    # squid -k check

Then create your cache directories:

    # squid -z

Then you can start Squid!

    # systemctl start squid

To start squid on boot use this command:

    # systemctl enable squid

Content Filtering
-----------------

If you're looking for a content filtering solution to work with Squid,
you should check out the very powerful DansGuardian.

Frontend
--------

If you'd like a web-based frontend for managing Squid, Webmin is your
best bet.

Ad blocking with adzapper
-------------------------

Adzapper is a plugin for Squid. It catches ads of all sorts (even Flash
animations) and replaces them with an image of your choice, so the
layout of the page isn't altered very much.

> Installation

Adzapper is no longer in the community repository, but it can be found
in the AUR.

> Configuration

    echo "redirect_program /usr/bin/adzapper.wrapper" >> /etc/squid/squid.conf

(squid 2.6.STABLE13-1)

    echo "url_rewrite_program /usr/bin/adzapper.wrapper" >> /etc/squid/squid.conf
    echo "url_rewrite_children 10" >> /etc/squid/squid.conf

If you want, you can configure adzapper to your liking. The
configuration out of the box works wonderfully well though.

    nano /etc/adzapper/adzapper.conf

Anti-virus layer
----------------

Adding Anti-virus capabilities to Squid is done using the HAVP program
to interface it with ClamAV.

> Installing dependencies

Follow this link to install ClamAV on your system.

Once ClamAV is installed, install HAVP from AUR. Details on installing
an AUR package can be found here, and the HAVP package can be found
here.

> Configuration

Once HAVP is installed, create a user group for the HAVP instance:

    useradd havp

Change the owner of the antivirus logs and temporary file-testing
directories to havp :

    chown -R havp:havp /var/run/havp
    chown -R havp:havp /var/log/havp

Add the mandatory lock option to your filesystem (needed by HAVP) : In
your /etc/fstab, modify :

    [...] / ext3 defaults 1 1

to :

    [...] / ext3 defaults,mand 1 1

Then reload your filesystem :

    mount -o remount /

Add this info in your /etc/squid/squid.conf :

    cache_peer 127.0.0.1 parent 8080 0 no-query no-digest no-netdb-exchange default
    cache_peer_access 127.0.0.1 allow all

Make sure your port in your /etc/havp/havp.config matches the cache_peer
port in /etc/squid/squid.conf.

> Testing

Reload your squid and start HAVP:

    systemctl restart squid
    systemctl start havp

Don't forget to add HAVP to your rc.conf if your want it to launch on
boot :

    systemctl enable squid
    systemctl enable havp

You can try the antivirus capabilities with a test virus (not a real
virus) available here.

Transparent web proxy
---------------------

Transparency happens by redirecting all www requests eth0 picks up, to
Squid. You'll need to indicate Squid that it is running like a
transparent web proxy by adding the intercept (for squid 3.2) parameter
to the http_port option:

     http_port 3128 intercept

> iptables

From a terminal with root privileges, run:

    # gid=`id -g proxy`
    # iptables -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner $gid -j ACCEPT
    # iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination SQUIDIP:3128
    # iptables-save > /etc/iptables/iptables.rules

Then start Iptables:

    # systemctl start iptables.service

Replace SQUIDIP with the public IP(s) which squid may use for its
listening port and outbound connections.

Note:If you are using a content filtering solution, you should put the
port for it, not the Squid port, and you need to remove the intercep
option in the http_port line.

> Shorewall

Edit /etc/shorewall/rules and add

    REDIRECT	loc	3128	tcp	www # redirect to Squid on port 3128
    ACCEPT		$FW	net	tcp	www # allow Squid to fetch the www content

    systemctl restart shorewall

HTTP Authentication
-------------------

Squid can be configured to require a user and password in order to use
it. We will use digest http auth

First create a users file with
htdigest -c /etc/squid/users MyRealm username. Enter a password when
prompted.

Then add these lines to your squid.conf:

       auth_param digest program /usr/lib/squid/digest_file_auth -c /etc/squid/users
       auth_param digest children 5
       auth_param digest realm MyRealm
       
       acl users proxy_auth REQUIRED
       http_access allow users

And restart squid. Now you will be prompted to enter a username and
password when accessing the proxy.

You can add more users with htdigest /etc/squid/users MyRealm newuser.
You probably would like to install Apache package, which contains
htdigest tool.

Note:Be aware that http_access rules cascade, so you need to set them in
the desired order.

> NTLM

Warning:NTLM is deprecated and has security problems.

Set up samba and winbindd and test it with

     ntlm_auth --username=DOMAIN\\user

Grant r-x access to /var/cache/samba/winbindd_privileged/ directory for
squid user/group

Then add something like this to squid.conf:

     auth_param ntlm program /usr/bin/ntlm_auth --helper-protocol=squid-2.5-ntlmssp
     auth_param ntlm children 5
     auth_param ntlm max_challenge_reuses 0
     auth_param ntlm max_challenge_lifetime 2 minutes
     auth_param ntlm keep_alive off

     acl ntlm_users proxy_auth REQUIRED
     http_access allow ntlm_users
     http_access deny all

Additional Resources
--------------------

-   Elite Proxy Config Example

Retrieved from
"https://wiki.archlinux.org/index.php?title=Squid&oldid=255463"

Categories:

-   Security
-   Proxy servers
