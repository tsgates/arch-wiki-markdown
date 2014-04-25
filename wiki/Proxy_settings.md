Proxy settings
==============

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 Environment variables
    -   2.1 Keep proxy through sudo
    -   2.2 Automation with network managers
-   3 About libproxy
-   4 Web Proxy Options
    -   4.1 Simple Proxy with SSH
-   5 Using a SOCKS proxy
-   6 Proxy settings on GNOME3

Introduction
------------

A proxy is "an interface for a service, especially for one that is
remote, resource-intensive, or otherwise difficult to use directly".
Source: Proxy - Wiktionary.

Environment variables
---------------------

Some programs (like wget) use environment variables of the form
"protocol_proxy" to determine the proxy for a given protocol (e.g. HTTP,
FTP, ...).

Below is an example on how to set these variables in a shell:

     export http_proxy=http://10.203.0.1:5187/
     export https_proxy=$http_proxy
     export ftp_proxy=$http_proxy
     export rsync_proxy=$http_proxy
     export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

Some programs look for the all caps version of the environment
variables.

If the proxy environment variables are to be made available to all users
and all applications, the above mentioned export commands may be added
to a script, say "proxy.sh" inside /etc/profile.d/. The script has to be
then made executable. This method is helpful while using a Desktop
Environment like Xfce which does not provide an option for proxy
configuration. For example, Chromium browser will make use of the
variables set using this method while running XFCE.

Alternatively you can automate the toggling of the variables by adding a
function to your .bashrc (thanks to Alan Pope)

     function proxy(){
         echo -n "username:"
         read -e username
         echo -n "password:"
         read -es password
         export http_proxy="http://$username:$password@proxyserver:8080/"
         export https_proxy=$http_proxy
         export ftp_proxy=$http_proxy
         export rsync_proxy=$http_proxy
         export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
         echo -e "\nProxy environment variable set."
     }
     function proxyoff(){
         unset HTTP_PROXY
         unset http_proxy
         unset HTTPS_PROXY
         unset https_proxy
         unset FTP_PROXY
         unset ftp_proxy
         unset RSYNC_PROXY
         unset rsync_proxy
         echo -e "\nProxy environment variable removed."
     } 

If you do not need a password then omit it.

As an alternative, you may want to use the following script. Add this
script into your ".bashrc" and source the ".bashrc" file. Note that, It
is recommended to put these kind of scripts in a separete file like
"functions" then source this file instead of putting everything under
".bashrc". You just need to change the areas "YourUserName" and
"ProxyServerAddress:Port" obviously. You may also want to change the
name "myProxy" into something short and easy to write.

     #!/bin/bash

     assignProxy(){
       PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY ALL_PROXY"
       for envar in $PROXY_ENV
       do
         export $envar=$1
       done
     }

     clrProxy(){
       assignProxy "" # This is what 'unset' does.
     }

     myProxy(){
       user=YourUserName
       read -p "Password: " -s pass &&  echo -e " "
       proxy_value="http://$user:$pass@ProxyServerAddress:Port"
       assignProxy $proxy_value  
     }
     

> Keep proxy through sudo

If the proxy environment variables are set for the user only (say, from
manual commands or .bashrc) they will get lost when running commands
with sudo (or when programs like yaourt use sudo internally).

A way to prevent that is to add the following line to the sudo
configuration file (accessible with visudo) :

    Defaults env_keep += "http_proxy https_proxy ftp_proxy"

You may also add any other environment variable, like rsync_proxy, or
no_proxy.

> Automation with network managers

-   NetworkManager cannot change the environment variables.
-   netctl could set-up these environment variables but they would not
    be seen by other applications as they are not child of netctl.

About libproxy
--------------

libproxy (which is available in the extra repository) is an abstraction
library which should be used by all applications that want to access a
network resource. It still is in development but could lead to a unified
and automated handling of proxies in GNU/Linux if widely adopted.

The role of libproxy is to read the proxy settings form different
sources and make them available to applications which use the library.
The interesting part with libproxy is that it offers an implementation
of the Web Proxy Autodiscovery Protocol and an implementation of Proxy
Auto-Config that goes with it.

The /usr/bin/proxy binary takes URL(s) as argument(s) and returns the
proxy/proxies that could be used to fetch this/these network
resource(s).

Note:the version 0.4.11 does not support http_proxy='wpad:' because
{ pkg-config 'mozjs185 >= 1.8.5'; } fails .

As of 06/04/2009 libproxy is required by libsoup. It is then indirectly
used by the Midori browser.

Web Proxy Options
-----------------

-   Squid is a very popular caching/optimizing proxy
-   Privoxy is an anonymizing and ad-blocking proxy
-   For a simple proxy, ssh with port forwarding can be used

> Simple Proxy with SSH

Connect to a server (HOST) on which you have an account (USER) as
follows

    ssh -D PORT USER@HOST

For PORT, choose some number which is not an IANA registered port. This
specifies that traffic on the local PORT will be forwarded to the remote
HOST. ssh will act as a SOCKS server. Software supporting SOCKS proxy
servers can simply be configured to connect to PORT on localhost.

Using a SOCKS proxy
-------------------

There are two cases:

-   the application you want to use handles SOCKS proxies (for example
    Firefox) then you just have to configure it to use the proxy
-   the application you want to use does not handle SOCKS proxies then
    you can try to use tsocks (available in extra)

Proxy settings on GNOME3
------------------------

Some programs like Chromium prefer to use the settings stored by gnome.
These settings can be modified through the gnome-control-center front
end and also through gsettings.

    gsettings set org.gnome.system.proxy mode 'manual' 
    gsettings set org.gnome.system.proxy.http host 'proxy.localdomain.com'
    gsettings set org.gnome.system.proxy.http port 8080
    gsettings set org.gnome.system.proxy.ftp host 'proxy.localdomain.com'
    gsettings set org.gnome.system.proxy.ftp port 8080
    gsettings set org.gnome.system.proxy.https host 'proxy.localdomain.com'
    gsettings set org.gnome.system.proxy.https port 8080
    gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12' , '*.localdomain.com' ]"

This configuration can also be set to automatically execute when Network
Manager connects to specific networks , by using the package proxydriver
from the AUR

Retrieved from
"https://wiki.archlinux.org/index.php?title=Proxy_settings&oldid=281513"

Category:

-   Proxy servers

-   This page was last modified on 5 November 2013, at 09:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
