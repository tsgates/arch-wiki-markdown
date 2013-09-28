Mrtg
====

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Server Setup                                                       |
| -   2 Apache configuration                                               |
| -   3 MRTG Setup                                                         |
| -   4 mrtg.cfg Global configuration                                      |
| -   5 Resource Monitoring                                                |
|     -   5.1 CPU Monitoring                                               |
|     -   5.2 Memory usage                                                 |
|     -   5.3 Swap Usage                                                   |
|     -   5.4 number of processes                                          |
|     -   5.5 established connections                                      |
|     -   5.6 users count                                                  |
|     -   5.7 monitor mount points                                         |
|     -   5.8 Server interface                                             |
|                                                                          |
| -   6 Startup script                                                     |
+--------------------------------------------------------------------------+

Server Setup
------------

This document assumes that you already have a Apache and net-snmp
working and configured properly

The following should all be performed as root.

-   Install the necessary programs

    # pacman -S mrtg perl-net-snmp

-   create an mrtg user

    # useradd -d /srv/http/mrtg mrtg

-   create the user home directory and change the owner ship to the user

    # mkdir /srv/http/mrtg/
    # chown mrtg:mrtg /srv/http/mrtg

  

Apache configuration
--------------------

As far as the Apache configuration is concerned, we simply need to add
an alias which is directed to the HTML files locations :

The configuration should look like this :

  

    Alias /mrtg /srv/http/mrtg/html/
    <Directory "/srv/http/mrtg/html/">
       AllowOverride None
       Options None
       DirectoryIndex index.html
       Order allow,deny
       Allow from all
    </Directory>

MRTG Setup
----------

There are many ways to configure the mrtg for your local server. Here,
the easiest way to expand the application for other server and network
appliances is described if needed.

The following should all be performed as the mrtg user we created.

-   create an HTML directory to hold the png files and the index.html
    file

    # mkdir /srv/http/mrtg/html

now we will begin dealing with the application scripts first we will
create a basic mrtg.cfg file

-   The following script call will scan our localhost for its interfaces
    and create for us the relevant configuration for each interface;
    public is the community name set for the local SNMP access:

    # cfgmaker --output=/srv/http/mrtg/mrtg.cfg --ifref=name --ifref=descr --global "WorkDir: /srv/http/mrtg" public@localhost

-   the mrtg.cfg files contains all the server interfaces. we do not
    need the "lo" interface so we are going to delete it and edit the
    global configuration

mrtg.cfg Global configuration
-----------------------------

remove the lines that are irrelevant to the interface and add the
fallowing lines at the top:

    ### Global configuration  ###

    LoadMIBs: /usr/share/snmp/mibs/UCD-SNMP-MIB.txt
    EnableIPv6: no
    HtmlDir: /srv/http/mrtg/html
    ImageDir: /srv/http/mrtg/html
    LogDir: /srv/http/mrtg
    ThreshDir: /srv/http/mrtg
    RunAsDaemon: Yes
    Interval: 5
    Refresh: 600

  
 the global configuration lines mean :

1) to load the Linux MIB in mrtg

2) to enable/disable IPv6

3) HTML home directory

4) the png files home directory

5) the log dir files locations

6) the Thresh folder

7) whether or not we want to run the application as a daemon , in this
case : yes

8) the daemon interval (minimum 5 min)

9) the interval to refresh the HTML files

  

Resource Monitoring
-------------------

Now that we have the global configuration set we need to add the
resources and devices we want to monitor.

in this tutorial we are going to monitor:

1)CPU

2)Memory Usage

3)swap

4)Number of Processes

5)Total TCP Established Connections

6)Users Count

7)the server mount points

8)the server interfaces

> CPU Monitoring

for monitoring the CPU we need to add the next lines :

    Target[localhost.cpu]:ssCpuRawUser.0&ssCpuRawUser.0:public@127.0.0.1 + ssCpuRawSystem.0&ssCpuRawSystem.0:public@127.0.0.1 +\ 
    ssCpuRawNice.0&ssCpuRawNice.0:public@127.0.0.1
    RouterUptime[localhost.cpu]: public@127.0.0.1
    MaxBytes[localhost.cpu]: 100
    Title[localhost.cpu]: CPU Load
    PageTop[localhost.cpu]: Active CPU Load %
    Unscaled[localhost.cpu]: ymwd
    ShortLegend[localhost.cpu]: %
    YLegend[localhost.cpu]: CPU Utilization
    Legend1[localhost.cpu]: Active CPU in % (Load)
    Legend2[localhost.cpu]:
    Legend3[localhost.cpu]:
    Legend4[localhost.cpu]:
    LegendI[localhost.cpu]:  Active
    LegendO[localhost.cpu]:
    Options[localhost.cpu]: growright,nopercent

  

> Memory usage

to monitor the memory usage we need to add the next lines :

    # get memory Usage
    Target[localhost.memtotal]: ( .1.3.6.1.4.1.2021.4.5.0&.1.3.6.1.4.1.2021.4.5.0:public@localhost ) - \
    ( .1.3.6.1.4.1.2021.4.6.0&.1.3.6.1.4.1.2021.4.6.0:public@localhost )
    PageTop[localhost.memtotal]: Memory Usage
    Options[localhost.memtotal]: nopercent,growright,gauge
    Title[localhost.memtotal]: Memory Usage
    MaxBytes[localhost.memtotal]: 100000000
    kMG[localhost.memtotal]: k,M,G,T,P,X
    YLegend[localhost.memtotal]: bytes
    ShortLegend[localhost.memtotal]: bytes
    LegendI[localhost.memtotal]: Memory Usage: 
    LegendO[localhost.memtotal]:
    Legend1[localhost.memtotal]: Memory Usage, not including swap, in bytes
    Colours[localhost.memtotal]: Blue#1000ff, Black#000000, Gray#CCCCCC, Yellow#FFFF00

> Swap Usage

for swap usage add the following lines :

    # get swap memory
    Target[localhost.swap]:( .1.3.6.1.4.1.2021.4.3.0&.1.3.6.1.4.1.2021.4.3.0:public@localhost ) - \
    ( .1.3.6.1.4.1.2021.4.4.0&.1.3.6.1.4.1.2021.4.4.0:public@localhost)
    PageTop[localhost.swap]: Swap Usage
    Options[localhost.swap]: nopercent,growright,gauge,noinfo
    Title[localhost.swap]: Swap Usage
    MaxBytes[localhost.swap]: 100000000 
    kMG[localhost.swap]: k,M,G,T,P,X
    YLegend[localhost.swap]: bytes
    ShortLegend[localhost.swap]: bytes
    LegendI[localhost.swap]: Swap Usage:
    LegendO[localhost.swap]:
    Legend1[localhost.swap]: Swap memory avail, in bytes
    Colours[localhost.swap]: Blue#1000ff,Violet#ff00ff,Black#000000, Gray#CCCCCC

in the title section some calculation are made. MRTG knows to calculate
the values given from the OID

> number of processes

for getting the number of processes running we are doing some unique
here

    # get number of processes running
    Target[localhost.procs]: `/usr/local/mrtg/linux_porc.pl`
    Title[localhost.procs]: Process Statistics
    PageTop[localhost.procs]: Process Statistics
    MaxBytes[localhost.procs]: 10000
    YLegend[localhost.procs]: Processes  
    LegendI[localhost.procs]:   Blocked Processes:
    LegendO[localhost.procs]:   Run Queue:
    Legend1[localhost.procs]: Number of Blocked Processes 
    Legend2[localhost.procs]: Number of Processes in Run Queue
    Legend3[localhost.procs]: Maximal Blocked Processes
    Legend4[localhost.procs]: Maximal Processes in Run Queue
    Options[localhost.procs]: growright, integer, nopercent, gauge

  
 as we can see here we are calling the command linux_proc.pl that was
written in Perl and returns an Integer which presence the number of
processes.

the content of the command is :

    #!/usr/bin/perl
    open(COMD,"ps -ef | wc -l|");
    $num = <COMD>;
    close(COMD);
    	
    print int($num);

> established connections

in order to get a graph about established connections we are doing the
way as the privies section :

    # get number of established connections
    Target[localhost.estconn]: `/usr/local/mrtg/linux_estconn.pl`
    Title[localhost.estconn]: Established connections
    PageTop[localhost.estconn]: Established connections
    MaxBytes[localhost.estconn]: 100000
    YLegend[localhost.estconn]: Established connections
    LegendI[localhost.estconn]:   Established connections: 
    LegendO[localhost.estconn]: Number of Established connections: 
    Options[localhost.estconn]: growright, integer, nopercent, gauge
    Colours[localhost.estconn]: Red#FF0000,Blue#0066CC,Black#000000, White#FFFFFF

  
 the content of the file linux_estconn.pl is :

  

    #!/usr/bin/perl
    open(COMD,"ss -an | grep ESTABLISHED | wc -l|");
    $num = <COMD>;
    close(COMD);
    	
    print int($num);

> users count

for the users count once again we are using a Perl script to create an
integer output

for the mrtg configuration we need to add :

  

    # get number of current users
    Target[localhost.users]: `/usr/local/mrtg/linux_users.pl`
    Title[localhost.users]: logged in users
    PageTop[localhost.users]: number of users
    MaxBytes[localhost.users]: 100000
    YLegend[localhost.users]: users count 
    Legend0[localhost.users]: logged in users count: 
    Options[localhost.users]: growright, integer, nopercent, gauge
    Colours[localhost.users]: Red#FF0000,White#FFFFFF,Blue#0066CC,Black#000000

  
 the linux_users.pl file content is :

    #!/usr/bin/perl
    open(COMD,"w | grep -v load | grep -v USER | wc -l|");
    $num = <COMD>;
    close(COMD);
    	
    print int($num);

> monitor mount points

in order to monitor mount points we first need to make sure that SNMP is
sending us the relevant information to check the mount point OID we need
first to see all the mount points by the command :

    snmpwalk -v 2c -c public localhost mount

this will display all of the server mount points and there mount
location.

to monitor the mount point we want we need to take the last octet from
the result and add it to the next 2 OID's

    .1.3.6.1.4.1.2021.9.1.8.
    .1.3.6.1.4.1.2021.9.1.6.

so the mrtg.cfg section for the root FS will look like this :

  

    # monitor root FS 
    Target[localhost.rootfs]: .1.3.6.1.4.1.2021.9.1.8.1&.1.3.6.1.4.1.2021.9.1.6.1:public@localhost
    PageTop[localhost.rootfs]: Root FS Usage
    Options[localhost.rootfs]: nopercent,growright,gauge,noinfo
    Title[localhost.rootfs]: Root FS Usage
    MaxBytes[localhost.rootfs]: 100000000
    YLegend[localhost.rootfs]: Giga bytes
    ShortLegend[localhost.rootfs]: bytes
    LegendI[localhost.rootfs]: Root FS Usage:
    Colours[localhost.rootfs]: Yellow#FFFF00, White#FFFFFF, Gray#CCCCCC, Blue#1000ff

> Server interface

the server interface is outomaticly generated when we run the "cfgmaker"
command.

Startup script
--------------

If you want the MRTG daemon to start at boot add the next startup
script:

    vi /etc/rc.d/mrtg

    #!/bin/bash 
    . /etc/rc.conf
    . /etc/rc.d/functions
    LENG=C
    USER=mrtg
    MRTG=/usr/bin/mrtg
    MRTGCFG=/srv/http/mrtg/mrtg.cfg
    daemon_name=mrtg
    Start() {
           stat_busy "starting the MRTG Daemon"
           su - ${USER} -c "env LENG=${LANG} ${MRTG} ${MRTGCFG} > /dev/null"
           RETVAL=$?;
           if [[ $RETVAL -eq 0 ]]; then
                   add_daemon $daemon_name
                   stat_done
           else
                   stat_fail
                   exit 1
           fi
    }
    Stop() {
           stat_busy "Stopping the MRTG Daemon"
           PID=`ps -ef | grep mrtg.cfg | grep -v grep | awk '{print $2}'`
           if [[ ! -z ${PID} ]]; then
                   kill ${PID}
                   RETVAL=$?;
                   if [[ $RETVAL -eq 0 ]]; then
                           rm_daemon $daemon_name
                           stat_done
                   else
                           stat_fail
                           exit 1
                   fi
          fi
    }
    case "$1" in
           start)
                   Start;
           ;;
           stop)
                   Stop;
           ;;
           restart)
                   Stop;
                   Start;
           ;;
           *)
                   echo "Usage: mrtg {start|stop|restart}";
           ;;
    esac

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mrtg&oldid=249144"

Category:

-   Networking
