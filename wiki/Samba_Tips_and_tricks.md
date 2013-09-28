Samba/Tips and tricks
=====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Sample configuration                                               |
| -   2 Share files without a username and password                        |
| -   3 Sample Passwordless Configuration                                  |
| -   4 Samba Security                                                     |
| -   5 Adding network shares using KDE4 GUI                               |
| -   6 Discovering network shares                                         |
| -   7 Remote control of Windows computer                                 |
| -   8 Block certain file extensions on samba share                       |
| -   9 Samba 4.* : Password Complexity                                    |
+--------------------------------------------------------------------------+

Sample configuration
--------------------

The following simple configuration file allows for a quick and easy
setup to share any number of directories, as well as easy browsing from
Windows clients.

See man smb.conf for details and explanation of configuration options.

    /etc/samba/smb.conf

    [global]
        workgroup = WORKGROUP
        server string = Samba Server
        netbios name = SERVER
        name resolve order = bcast host
        dns proxy = no

        log file = /var/log/samba/%m.log

        create mask = 0664
        directory mask = 0775

        force create mode = 0664
        force directory mode = 0775

        ; One may be interested in the following setting:
        ;force group = +nas

    [media1]
        path = /media/media1
        read only = No

    [media2]
        path = /media/media2
        read only = No

    [media3]
        path = /media/media3
        read only = No

Remember to testparm -s and systemctl restart smbd nmbd after editing
configuration files.

Share files without a username and password
-------------------------------------------

Edit /etc/samba/smb.conf and add the following line:

    map to guest = Bad User

After this line:

    security = user

Restrict the shares data to a specific interface replace:

    ;   interfaces = 192.168.12.2/24 192.168.13.2/24

with:

    interfaces = lo eth0
    bind interfaces only = true

Optionally edit the account that access the shares, edit the following
line:

    ;   guest account = nobody

For example:

    ;   guest account = pcguest

And do something in the likes of:

    # useradd -c "Guest User" -d /dev/null -s /bin/false pcguest

Then setup a "" password for user pcguest.

The last step is to create share directory (for write access make
writable = yes):

    [Public Share]
    path = /path/to/public/share
    available = yes
    browsable = yes
    public = yes
    writable = no

Sample Passwordless Configuration
---------------------------------

This is the configuration I use with samba 4 for easy passwordless
filesharing with family on a home network. Change any options needed to
suit your network (workgroup and interface). I'm restricting it to the
static IP I have on my ethernet interface, just delete that line if you
don't care which interface is used.

    /etc/samba/smb.conf

    [global]

       workgroup = WORKGROUP

       server string = Media Server

       security = user
       map to guest = Bad User

       log file = /var/log/samba/%m.log

       max log size = 50


       interfaces = 192.168.2.194/24


       dns proxy = no 


    [media]
       path = /shares
       public = yes
       only guest = yes
       writable = yes

    [storage]
       path = /media/storage
       public = yes
       only guest = yes
       writable = yes

Samba Security
--------------

An extra layer of security can be obtainded by restricting your
acceptable networks:

    /etc/samba/smb.conf

    hosts deny = 0.0.0.0/0
    hosts allow = xxx.xxx.xxx.xxx/xx yyy.yyy.yyy.yyy/yy 

If you're behind a firewall, make sure to open the ports Samba uses:

    UDP/137 - used by nmbd
    UDP/138 - used by nmbd
    TCP/139 - used by smbd
    TCP/445 - used by smbd

So a series of commands like this should suffice:

    # iptables -A INPUT -p tcp --dport 139 -j ACCEPT
    # iptables -A INPUT -p tcp --dport 445 -j ACCEPT
    # iptables -A INPUT -p udp --sport 137 -j ACCEPT
    # iptables -A INPUT -p udp --dport 137 -j ACCEPT
    # iptables -A INPUT -p udp --dport 138 -j ACCEPT

If you're basing your firewall upon Arch Linux's Simple Stateful
Firewall, just substitute the INPUT chain for the correspondent TCP and
UDP chains.

Adding network shares using KDE4 GUI
------------------------------------

How to configure the folder sharing in KDE4. Simple file sharing limits
user shared folders to their home directory and read-only access.
Advanced file sharing gives full semantics of Samba with no limits to
shared folders but requires su or sudo root permissions.

Discovering network shares
--------------------------

If nothing is known about other systems on the local network, and
automated tools such as smbnetfs are not available, the following
methods allow one to manually probe for Samba shares.

1. First, install nmap and smbclient using pacman:

    # pacman -S nmap smbclient

2. nmap checks which ports are open:

    # nmap -p 139 -sT 192.168.1.*

In this case, a scan on the 192.168.1.* IP address range and port 139
has been performed, resulting in:

    $ nmap -sT 192.168.1.*

    Starting nmap 3.78 ( http://www.insecure.org/nmap/ ) at 2005-02-15 11:45 PHT
    Interesting ports on 192.168.1.1:
    (The 1661 ports scanned but not shown below are in state: closed)
    PORT     STATE SERVICE
    139/tcp  open  netbios-ssn
    5000/tcp open  UPnP

    Interesting ports on 192.168.1.5:
    (The 1662 ports scanned but not shown below are in state: closed)
    PORT     STATE SERVICE
    6000/tcp open  X11

    Nmap run completed -- 256 IP addresses (2 hosts up) scanned in 7.255 seconds

The first result is another system; the second happens to be the client
from where this scan was performed.

3. Now that systems with port 139 open are revealed, use nmblookup to
check for NetBIOS names:

    $ nmblookup -A 192.168.1.1

    Looking up status of 192.168.1.1
            PUTER           <00> -         B <ACTIVE>
            HOMENET         <00> - <GROUP> B <ACTIVE>
            PUTER           <03> -         B <ACTIVE>
            PUTER           <20> -         B <ACTIVE>
            HOMENET         <1e> - <GROUP> B <ACTIVE>
            USERNAME        <03> -         B <ACTIVE>
            HOMENET         <1d> -         B <ACTIVE>
            MSBROWSE        <01> - <GROUP> B <ACTIVE>

Regardless of the output, look for <20>, which shows the host with open
services.

4. Use smbclient to list which services are shared on PUTER. If prompted
for a password, pressing enter should still display the list:

    $ smbclient -L \\PUTER

    Sharename       Type      Comment
    ---------       ----      -------
    MY_MUSIC        Disk
    SHAREDDOCS      Disk
    PRINTER$        Disk
    PRINTER         Printer
    IPC$            IPC       Remote Inter Process Communication

    Server               Comment
    ---------            -------
    PUTER

    Workgroup            Master
    ---------            -------
    HOMENET               PUTER

This shows which folders are shared and can be mounted locally. See:
#Accessing shares

Remote control of Windows computer
----------------------------------

Samba offers a set of tools for communication with Windows. These can be
handy if access to a Windows computer through remote desktop is not an
option, as shown by some examples.

Send shutdown command with a comment:

    $ net rpc shutdown -C "comment" -I IPADDRESS -U USERNAME%PASSWORD

A forced shutdown instead can be invoked by changing -C with comment to
a single -f. For a restart, only add -r, followed by a -C or -f.

Stop and start services:

    $ net rpc service stop SERVICENAME -I IPADDRESS -U USERNAME%PASSWORD

To see all possible net rpc command:

    $ net rpc

Block certain file extensions on samba share
--------------------------------------------

Samba offers an option to block files with certain patterns, like file
extensions. This option can be used to prevent dissemination of viruses
or to disuade users from wasting space with certain files:

    Veto files = /*.exe/*.com/*.dll/*.bat/*.vbs/*.tmp/*.mp3/*.avi/*.mp4/*.wmv/*.wma/

Samba 4.* : Password Complexity
-------------------------------

Samba 4 requires strong password when adding new user with pdbedit. If
you want to disable the complexity check, just use the follwing command:

    # samba-tool domain passwordsettings set --complexity=off

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba/Tips_and_tricks&oldid=255821"

Category:

-   Networking
