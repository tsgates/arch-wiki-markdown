ISPmanager
==========

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: upstream site    
                           unavailable, probably    
                           dead project (+ the      
                           package ispmanager-pro   
                           was removed from AUR)    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 What is ISPmanager?
-   2 Prerequisites
-   3 Installing ISP manager
    -   3.1 ISP manager package
    -   3.2 ISP manager configuration
    -   3.3 Install the license
-   4 System configuration for ISP manager
    -   4.1 httpd
        -   4.1.1 Virtual hosts under ISP manager control
        -   4.1.2 Control interface
        -   4.1.3 php
    -   4.2 Website statistics
        -   4.2.1 Webalizer
        -   4.2.2 awstats
    -   4.3 DNS (bind)
    -   4.4 Configuring e-mail
        -   4.4.1 MTA: Postfix
        -   4.4.2 Client access: dovecot
    -   4.5 FTP access
-   5 Recommendations
-   6 Resources

What is ISPmanager?
-------------------

ISP manager is a webhosting control panel. It comes in two flavors, a
lite and pro version. The only difference between them is that the pro
version supports resellers. Unlike most control panels, ISP manager can
make use of a wide range of server software. ISP manager tries to barely
touch your configuration files and you say what files ISP manager is
allowed to modify. Any changes you make to the configuration files are
reflected back into ISP manager and ISP manager will not overwrite your
own configuration. Because of this ISP manager doesn't depend on certain
versions or flavors of software. Unless you're using the installer, ISP
manager will never install software itself. This makes it a breeze to
administer your servers and is compatible with upgrades. Some of the
even most expensive control panels out there do not offer that kind of
flexibility.

Prerequisites
-------------

For all features of this HOWTO for ISP manager to work, you need to
install the following software. All the software required is packaged in
the Arch Linux extra repository.

    pacman -S apache postfix webalizer php pure-ftpd bind dovecot

You should read the install documentation at
http://en.ispdoc.com/index.php/ISPmanager_installation_%28ISPmanager%29.

Installing ISP manager
----------------------

> ISP manager package

You can find the ISP manager package in the AUR:
https://aur.archlinux.org/packages.php?ID=18388

> ISP manager configuration

The main configuration is contained in
/usr/local/ispmgr/etc/ispmgr.conf. You can find an example ispmgr.conf
in /usr/local/ispmgr/etc/dist/ispmgr.conf. You may want to put the
firststart option there, this will give you a short setup wizard the
first time you log in to the control interface.

    echo "option FirstStart" >> /usr/local/ispmgr/etc/ispmgr.conf

When you've modified your configuration, you need restart the ispmgr
process. You only need to kill the ispmgr process for this:

    killall ispmgr

The ISP manager httpd module will automatically start the ispmgr
process.

> Install the license

First, obtain a license at http://ispsystem.com/en/order/index.html.
Licenses are IP bound. After you've registered and requested a license,
you can proceed by downloading the license and putting it in the right
directory.

    wget -O - http://lic.ispsystem.com/ispmgr.lic?ip=YOUR_IP_ADDRESS > /usr/local/ispmgr/etc/ispmgr.lic

System configuration for ISP manager
------------------------------------

> httpd

ISP manager relies on Apache's httpd. (ISP manager can be made to use
nginx as well).

Virtual hosts under ISP manager control

If you want ispmgr not to touch your httpd.conf, for example, create a
new file called ispmgr.vhosts.conf and configure it in ispmgr.conf:

    touch /etc/httpd/conf/ispmgr.vhosts.conf
    echo "path httpd.conf /etc/httpd/conf/ispmgr.vhosts.conf" >> /usr/local/ispmgr/etc/ispmgr.conf

Control interface

For the control panel to work, add the following to your httpd
configuration:

    echo "Include /usr/local/ispmgr/etc/ispmgr.inc" >> /etc/httpd/conf/httpd.conf

Note that you do not have to use the ispmgr.inc file. Read the file
itself to see how the control panel works. You may decide to put the
control panel under its own vhost so it's only accessible from a
specific address.

ISPmanager uses its own apache module. ispmgr.inc will take care of
loading the apache module, however you have to add the proper symlink
for your apache version.

    cd /usr/local/ispmgr/lib/apache
    ln -s mod_ispmgr.2.2.0.so mod_ispmgr.so

You may also decide for ease of trying/installation to not use HTTPS for
the control interface. To allow regular HTTP connections to the control
interface, add the following to ispmgr.conf:

    echo "Option AllowHTTP" >> /usr/local/ispmgr/etc/ispmgr.conf

It's highly recommended that for production purposes you do use HTTPS to
manage your server. After this, the control interface should be working.
Go to http(s)://<yourip>/manager and login using your system's root
user.

php

    echo "path php.ini /etc/php/php.ini" >> /usr/local/ispmgr/etc/ispmgr.conf
    # This allows PHP to be used as an apache module
    echo "Option ForcePHP" >> /usr/local/ispmgr/etc/ispmgr.conf

> Website statistics

ISP manager can make use of both webalizer and awstats to generate
statistics. Depending on which statistics program you configured, you'll
be able to enable it in the log rotation properties of a virtual host in
the management interface.

Webalizer

    echo "path webalizer /usr/bin/webalizer" >> /usr/local/ispmgr/etc/ispmgr.conf
    echo "extaction webalizer http://$site/webstat/" >> /usr/local/ispmgr/etc/ispmgr.conf

    mkdir /usr/local/ispmgr/etc/extconf
    cp /usr/local/ispmgr/etc/dist/webalizer.conf /usr/local/ispmgr/etc/extconf/webalizer.conf

awstats

awstats is available in the AUR:
https://aur.archlinux.org/packages.php?ID=11674. It comes with a
configuration file for httpd, httpd-awstats.conf. Make sure it is
included for awstats to work correctly.

    echo "Include /etc/httpd/conf/extra/httpd-awstats.conf" >> /etc/httpd/conf/httpd.conf
    echo "path awstats /usr/local/awstats/wwwroot/cgi-bin/awstats.pl" >> /usr/local/ispmgr/etc/ispmgr.conf

> DNS (bind)

If you want to use the DNS facilities ISP manager provides, install the
bind package. The default configuration suffices and you do not have to
do anything else to make it work. You may want to let ISP manager have
it's own bind configuration file similar to the httpd configuration
above.

    echo "path named.conf /etc/named.ispmgr.conf" >> /usr/local/ispmgr/etc/ispmgr.conf
    touch /etc/named.ispmgr.conf
    echo 'include "/etc/named.ispmgr.conf";' >> /etc/named.conf
    /etc/rc.d/named start

> Configuring e-mail

MTA: Postfix

Postfix is one of the easiest MTA's to configure, and I'm only going to
cover postfix. ISP Manager is also compatible with CommuniGatePro, Exim,
and Sendmail.

    mkdir /etc/postfix/ispmgr
    touch /etc/postfix/ispmgr/{local-host-names,virtusertable,generic,aliases}

    echo "
    MTA  postfix
    # You really want to use Maildirs, trust me
    Option Maildir

    path postfix_main.cf /etc/postfix/main.cf
    path aliases /etc/postfix/ispmgr/aliases
    path local-host-names /etc/postfix/ispmgr/local-host-names
    path virtusertable /etc/postfix/ispmgr/virtusertable
    path genericstable /etc/postfix/ispmgr/generic
    path newaliases /usr/bin/newaliases
    path postfix /usr/sbin/postfix
    path postmap /usr/sbin/postmap
    path sasl /usr/sbin/saslpasswd2
    " >> /usr/local/ispmgr/etc/ispmgr.conf

The following postfix configuration is a bare minimum. Note that copy
pasting this command will overwrite your current main.cf.

    echo "
    queue_directory = /var/spool/postfix
    command_directory = /usr/sbin
    daemon_directory = /usr/lib/postfix
    home_mailbox = Maildir/
    mail_owner = postfix

    myhostname = your.mail.fqdn

    virtual_alias_domains = /etc/postfix/ispmgr/local-host-names
    virtual_alias_maps = hash:/etc/postfix/ispmgr/virtusertable
    smtp_generic_maps = hash:/etc/postfix/ispmgr/generic
    alias_maps = hash:/etc/postfix/ispmgr/aliases
    alias_database = $alias_maps
    " > /etc/postfix/main.cf

Client access: dovecot

    mkdir /etc/dovecot/ispmgr
    touch /etc/dovecot/ispmgr/passwd

    echo "
    POP3 dovecot
    path dovecot.passwd /etc/dovecot/ispmgr/passwd
    " >> /usr/local/ispmgr/etc/ispmgr.conf

The following dovecot configuration is a bare minimum. Note that copy
pasting this command will overwrite your current dovecot.conf.

    echo "
    protocols = imap
    ssl_disable = yes
    disable_plaintext_auth = no
    auth default {
            passdb passwd-file {
                    args = /etc/dovecot/ispmgr/passwd
            }

            userdb passwd-file {
                    args = /etc/dovecot/ispmgr/passwd
            }
    }
    " > /etc/dovecot/dovecot.conf

> FTP access

You can use any FTP server that supports /etc/passwd authentification.
Pure-FTPd's standard configuration uses passwd authentification, so the
only thing you have to do is start Pure-FTPd

    /etc/rc.d/pure-ftpd start

ISP manager will automatically set /bin/date as shell for users, so in
order to allow FTP logins, you'll need to add this "shell" to
/etc/shells:

    echo "/bin/date" >> /etc/shells

Recommendations
---------------

-   Keeping accurate time on servers is important. You can use ntpd for
    this.

Resources
---------

-   ISP manager's forum: http://forum.ispsystem.com/en/index.php
-   ISP manager's homepage: http://ispsystem.com/en/index.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=ISPmanager&oldid=277305"

Category:

-   Networking

-   This page was last modified on 2 October 2013, at 04:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
