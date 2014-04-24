Snort
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

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

From the project home page:

Snort® is an open source network intrusion prevention and detection
system (IDS/IPS) developed by Sourcefire. Combining the benefits of
signature, protocol, and anomaly-based inspection, Snort is the most
widely deployed IDS/IPS technology worldwide. With millions of downloads
and nearly 400,000 registered users, Snort has become the de facto
standard for IPS.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Update the rules: Oinkmaster
    -   3.1 Oinkmaster setup
    -   3.2 Oinkmaster usage
-   4 See also

Installation
------------

Install snort from the AUR.

Configuration
-------------

The main configuration file is /etc/snort/snort.conf.

Read it carefully, as usual it is very well documented.

    var HOME_NET        10.0.0.0/28           # Change to the subnet of your LAN.
    var EXTERNAL_NET    !$HOME_NET
    var DNS_SERVERS     $HOME_NET
    var SMTP_SERVERS    $HOME_NET             # Comment these if you're not running any servers on the LAN.
    var HTTP_SERVERS    $HOME_NET
    var SQL_SERVERS     $HOME_NET
    var TELNET_SERVERS  $HOME_NET
    var HTTP_PORTS      80
    var SHELLCODE_PORTS !80
    var ORACLE_PORTS    1521
    var AIM_SERVERS     [64.12.24.0/24,64.12.25.0/24,64.12.26.14/24,64.12.28.0/24,64.12.29.0/24,64.12.161.0/
                         24,64.12.163.0/24,205.188.5.0/24,205.188.9.0/24]
    var RULE_PATH       /etc/snort/rules
    var HTTP_PORTS      80:5000               # For HTTPd's running on port 80 and 5000. Change appropriately
                                              # to the ports you are using on your LAN.
    config detection:   search-method lowmem  # If you're using a machine "with very limited resources".

At the bottom of the file, there is a list of includes. These define
which rules you want to enforce. (Un)comment as you please. You should
check that the corresponding file exists, as for me, none of the rules
files were present.

    groupadd snort
    mkdir -p /var/log/snort
    useradd -g snort -d /var/log/snort snort
    chown -R snort:snort /var/log/snort

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Under review --  
                           I am not sure about this 
                           yet. (Discuss)           
  ------------------------ ------------------------ ------------------------

Edit /etc/conf.d/snort:

    SNORT_ARGS="-u snort -g snort -l /var/log/snort -K ascii -c /etc/snort/snort.conf -D -h 10.0.0.0/28 -A full

Replace 10.0.0.0/28 with the CIDR of your LAN.

Now Snort will run as user snort in group snort. Should improve
security. The other options make it log to /var/log/snort in ASCII mode.
Run snort -h to see other available options.

I have been running my router for 12 days now, and using the above snort
options, I had around 120MB of logs! So I changed the -A switch to "-A
none". This only logs alerts. I did not know what to do with all the
logs anyway.

Update the rules: Oinkmaster
----------------------------

If you want to be able to download Snort's latest rules, you will need a
subscription. This costs money. If you are happy enough with 5 days old
rules, you just need to register for free. If you do not, the only
updates you will get are the new rules distributed with a new Snort
release. Go ahead and register at Snort. If you really do not want to
register, you can use the rules from BleedingSnort.com. They are
bleeding edge, meaning they have not been tested thoroughly.

oinkmaster is available as AUR package.

> Oinkmaster setup

Edit /etc/oinkmaster.conf and look for the URL section and uncomment the
2.4 line. Make sure to replace <oinkcode> by the Oink code you generated
after logging into your Snort account. For Bleeding Snort rules,
uncomment the appropriate line.

When you log into your new account, create an "Oink code". Another thing
to change is

    use_external_bins===1 # 1 uses wget, tar, gzip instead of Perl modules

The rest of the configuration file is fine.

> Oinkmaster usage

    oinkmaster.pl -o /etc/snort/rules

Create an executable script with the exact command and place it in
/etc/cron.daily to update the rules daily automatically.

See also
--------

-   Simple stateful firewall
-   Router

Retrieved from
"https://wiki.archlinux.org/index.php?title=Snort&oldid=269528"

Category:

-   Security

-   This page was last modified on 3 August 2013, at 01:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
