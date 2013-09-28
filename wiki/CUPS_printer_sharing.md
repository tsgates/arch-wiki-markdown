CUPS printer sharing
====================

Summary

Setting up printer sharing using CUPS

Related

Samba

CUPS

CUPS provides capabilities to set up printer sharing between different
systems. Below you'll find instructions for common scenarios.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Between GNU/Linux systems                                          |
|     -   1.1 Using the web interface                                      |
|     -   1.2 Manual setup                                                 |
|                                                                          |
| -   2 Between GNU/Linux and Windows                                      |
|     -   2.1 Linux server - Windows client                                |
|         -   2.1.1 Sharing via IPP                                        |
|         -   2.1.2 Sharing via Samba                                      |
|                                                                          |
|     -   2.2 Windows server - Linux client                                |
|         -   2.2.1 Sharing via LPD                                        |
|         -   2.2.2 Sharing via IPP                                        |
|         -   2.2.3 Sharing via Samba                                      |
|             -   2.2.3.1 Configuration using the web interface            |
|             -   2.2.3.2 Manual configuration                             |
|                                                                          |
|     -   2.3 Troubleshooting                                              |
|         -   2.3.1 Can't print with GTK applications                      |
|                                                                          |
| -   3 Other operating systems                                            |
+--------------------------------------------------------------------------+

Between GNU/Linux systems
-------------------------

Once CUPS has been setup on the GNU/Linux print server, the recommended
method of sharing the printer with another GNU/Linux system is through
the relatively easy to use web interface, yet manual configuration is
also a way.

You will need avahi-daemon running, before you restart cupsd.

> Using the web interface

Access http://localhost:631 with a browser and the CUPS administration
home page will be displayed.

Click on the Administration tab near the top, select the add printer
option and it should automatically detect the connected printer. If not,
try turning off the printer and then back on before another attempt.

Once the printer has been set up, look under the Server heading and
click the checkbox for "Share printers connected to this system". Now,
conclude by clicking change settings and the server will automatically
restart.

Selecting "Edit Configuration File" allows making direct edits to the
cups.conf file. This is useful for allowing server access only to
certain users or IP addresses, as the example shown below.

> Manual setup

On the server computer (the one directly connected to the printer)
simply open up /etc/cups/cupsd.conf and allow access to the server by
modifying the location lines. For instance:

    <Location />
       Order allow,deny
       Allow localhost
       Allow 192.168.0.*
    </Location>

Also make sure the server is listening on the IP address the client will
be addressing. Add the following line after "# Listen <serverip>:631"
(using the server's IP address instead of client's 192.168.0.100):

    Listen 192.168.0.101:631

To "Show shared printers on the local network" make sure you have the
Browsing directive enabled:

    Browsing On

After making modifications, restart CUPS.

On the client system, open up (create if not present)
/etc/cups/client.conf and add the ServerName to match the IP address or
the name of the server. Add this line:

    ServerName 192.168.0.101

There are more configuration possibilities, including automatic methods,
which are described in detail in http://localhost:631/help/network.html

After making modifications, restart CUPS.

Note:When adding the printer from the client, if using the Internet
Printing Protocol (IPP), put the URI as
ipp://192.168.0.101:631/printers/<name-of-printer>

Between GNU/Linux and Windows
-----------------------------

> Linux server - Windows client

Sharing via IPP

The preferred way to connect a Windows client to a Linux print server is
using IPP. It's a standard printer protocol based on HTTP, allowing you
all ways to profit from port forwarding, tunneling etc. The
configuration is very easy and this way is less error-prone than using
Samba. IPP is natively supported by Windows since Windows 2000.

To configure the server side proceed as described in the section above
to enable browsing.

On the Windows computer, go to the printer control panel and choose to
'Add a New Printer'. Next, choose to give a URL. For the URL, type in
the location of the printer:
http://host_ip_address:631/printers/printer_name (where host_ip_address
is the GNU/Linux server's IP address and printer_name is the name of the
printer being connected to).

After this, install the native printer drivers for your printer on the
Windows computer. If the CUPS server is set up to use its own printer
drivers, then you can just select a generic postscript printer for the
Windows client(e.g. 'HP Color LaserJet 8500 PS' or 'Xerox DocuTech 135
PS2'). Then test the print setup by printing a test page.

Sharing via Samba

If your client's Windows version is below Windows 2000 or if you
experienced troubles with IPP you can also use Samba for sharing. Note
of course that with Samba this involves another complex piece of
software. This makes this way more difficult to configure and thus
sometimes also more error-prone, mostly due do authentication problems.

To configure Samba on the Linux server, edit /etc/samba/smb.conf file to
allow access to printers. File smb.conf can look something like this:

    /etc/samba/smb.conf

    [global]
    workgroup=Heroes
    server string=Arch Linux Print Server
    security=user

    [printers]
        comment=All Printers
        path=/var/spool/samba
        browseable=yes
        # to allow user 'guest account' to print.
        guest ok=no
        writable=no
        printable=yes
        create mode=0700
        write list=@adm root yourusername

That should be enough to share the printer, yet adding an individual
printer entry may be desirable:

    /etc/samba/smb.conf

    [ML1250]
        comment=Samsung ML-1250 Laser Printer
        printer=ml1250
        path=/var/spool/samba
        printing=cups
        printable=yes
        printer admin=@admin root yourusername
        user client driver=yes
        # to allow user 'guest account' to print.
        guest ok=no
        writable=no
        write list=@adm root yourusername
        valid users=@adm root yourusername

Please note that this assumes configuration was made so that users must
have a valid account to access the printer. To have a public printer,
set guest ok to yes, and remove the valid users line. To add accounts,
set up a regular GNU/Linux account and then set up a Samba password on
the server. For instance:

    # useradd yourusername
    # smbpasswd -a yourusername

  
 After this, restart the Samba daemon.

Obviously, there are a lot of tweaks and customizations that can be done
with setting up a Samba print server, so it is advised to look at the
Samba and CUPS documentation for more help. The smb.conf.example file
also has some good samples that might warrant imitating.

> Windows server - Linux client

Sharing via LPD

Windows 7 has a built-in LPD server - using it will probably be the
easiest approach as it does neither require an installation of Samba on
the client nor heavy configuration on the server. It can be activated in
the Control Panel under Programs -> Activate Windows functions in the
section Print services. The printer must have shared activated in its
properties. Use a share name without any special characters like spaces,
commas, etc.

Then the printer can be added in CUPS, choosing LPD protocol. The
printer address will look like this:

    # lpd://windowspc/printersharename

Before adding the printer, you will most likely have to install an
appropriate printer driver depending on your printer model. Generic
PostScript or RAW drivers might also work.

Sharing via IPP

As above, IPP is also the preferred protocol for printer sharing.
However this way might be a bit more difficult than the native Samba
approach below, since you need a greater effort to set up an IPP-Server
on Windows. The commonly chosen server software is Microsoft's Internet
Information Services (IIS).

Note:This section is incomplete. Here is a description how to set up ISS
in Windows XP and Windows 2000, unfortunately in German [1]

Sharing via Samba

A much simpler way is using Window's native printer sharing via Samba.
There is almost no configuration needed, and all of it can be done from
the CUPS Backend. As above noted, if there are any problems the reason
is mostly related to authentication trouble and Windows access
restrictions.

On the server side enable sharing for your desired printer and ensure
that the user on the client machine has the right to access the printer.

The following section describes how to set up the client, assuming that
both daemons (cupsd and smbd) are running.

Configuration using the web interface

The Samba CUPS back-end is enabled by default, if for any reason it is
not activate it by entering the following command and restarting CUPS.

    # ln -s $(which smbspool) /usr/lib/cups/backend/smb

Next, simply log in on the CUPS web interface and choose to add a new
printer. As a device choose "Windows Printer via SAMBA".

For the device location, enter:

    smb://username:password@hostname/printer_name

Or without a password:

    smb://username@hostname/printer_name

Make sure that the user actually has access to the printer on the
Windows computer and select the appropriate drivers. If the computer is
located on a domain, make sure the user-name includes the domain:

    smb://username:password@domain/hostname/printer_name

If the network contains many printers you might want to set a preferred
printer. To do so use the web interface, go into the printer tab, choose
the desired printer and select 'Set as default' from the drop-down list.

Manual configuration

For manual configuration stop the CUPS daemon and add your printer to
/etc/cups/printers.conf, which might for example look like this

    /etc/cups/printers.conf

    <DefaultPrinter MyPrinter>
    AuthInfoRequired username,password
    Info My printer via SAMBA
    Location In my Office
    MakeModel Samsung ML-1250 - CUPS+Gutenprint v5.2.7        # <= use 'lpinfo -m' to list available models
    DeviceURI smb://username:password@hostname/printer_name   # <= server URI as described in previous section
    State Idle
    Type 4
    Accepting Yes
    Shared No
    JobSheets none none
    QuotaPeriod 0
    PageLimit 0
    KLimit 0
    AllowUser yourusername                                    # <= do not forget to change this
    OpPolicy default
    ErrorPolicy stop-printer
    </Printer>

Then restart the CUPS daemon an try to print a test page.

To set the preferred printer use the following command

    # lpoptions -d desired_default_printer_name

> Troubleshooting

If there are any problems, the first thing to do is enable debug
information by setting

    LogLevel debug

in /etc/cups/cupsd.conf.

Then restart the CUPS daemon and check for error messages in
/var/log/cups/error_log. A convenient way to do so is

    # tail -f /var/log/cups/error_log

which keeps printing new error messages as they occur.

Note: You can also use the web interface to browse this error file.

  

Can't print with GTK applications

If you get "getting printer information failed" when you try to print
from gtk-applications, add this line to your /etc/hosts:

     # serverip 	some.name.org 	ServersHostname

Other operating systems
-----------------------

More information on interfacing CUPS with other printing systems can be
found in the CUPS manual, e.g. on
http://localhost:631/sam.html#PRINTING_OTHER

Retrieved from
"https://wiki.archlinux.org/index.php?title=CUPS_printer_sharing&oldid=254822"

Category:

-   Printers
