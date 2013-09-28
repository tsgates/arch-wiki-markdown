AppArmor
========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

AppArmor is a MAC (Mandatory Access Control) system, implemented upon
LSM (Linux Security Modules).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preventing circumvention of path-based MAC via links               |
| -   2 Implementation Status                                              |
|     -   2.1 AUR/apparmor package                                         |
|                                                                          |
| -   3 Links                                                              |
| -   4 AppArmor Packages                                                  |
| -   5 Kernel Configuration                                               |
| -   6 Bootloader Configuration                                           |
|     -   6.1 Enable                                                       |
|         -   6.1.1 Disable                                                |
|                                                                          |
| -   7 System Configuration                                               |
|     -   7.1 Mounts (/etc/fstab securityfs)                               |
|                                                                          |
| -   8 UserSpace Tools                                                    |
|     -   8.1 Users                                                        |
|     -   8.2 Maintainers                                                  |
|                                                                          |
| -   9 More Info                                                          |
| -   10 See also                                                          |
+--------------------------------------------------------------------------+

Preventing circumvention of path-based MAC via links
----------------------------------------------------

AppArmor can be circumvented via hardlinks in the standard POSIX
security model. However, the kernel now includes the ability to prevent
this vulnerability, without needing the patches distributions like
Ubuntu have applied to their kernels as workarounds.

See Sysctl#Preventing_link_TOCTOU_vulnerabilities for details.

Implementation Status
---------------------

AppArmor is currently available in the Arch Linux kernel, but it has to
be activated on kernel boot.

The userspace support requires AUR packages.

-   https://aur.archlinux.org/packages.php?ID=42279

Not all the packages work out-of-the-box, but it is a work in progress.
If you know how to build profiles yourself you shouldn't have too many
problems. Also there is an AUR kernel which includes apparmor specific
patches from Ubuntu's launchpad.

> AUR/apparmor package

Added lot of features:

-   apparmor-parser
-   libapparmor
-   apparmor-utils
-   apparmor-profiles
-   apparmor-notify
-   apparmor-lib
-   apparmor-perl
-   apparmor-python
-   apparmor-ruby
-   apparmor-dbus
-   apparmor-profile-editor

But we still miss following features (TODO):

-   init (rc.d) scripts! http://aur.pastebin.com/beQ4BjGX
-   chase missing dependencies
-   test everything
-   make list of files that should go to backup=() arrays in packages...
-   changehat modules for PAM(!), Apache and Tomcat (btw those are
    dependent on libapparmor)
-   out-of-box-experience know-how
    -   make some package with profiles for all [core] packages enabled
        by default without need for any further user configuration
    -   etc...

-   apparmor gnome applet (can't build, deprecated...)

Links
-----

-   Official pages
    -   Kernel: https://apparmor.wiki.kernel.org/
        http://wiki.apparmor.net/index.php/Main_Page
    -   Userspace: https://launchpad.net/apparmor

-   http://www.kernel.org/pub/linux/security/apparmor/AppArmor-2.6/
-   http://wiki.apparmor.net/index.php/AppArmor_Core_Policy_Reference

-   http://ubuntuforums.org/showthread.php?t=1008906 (Tutorial)
-   https://help.ubuntu.com/community/AppArmor
-   FS#21406
-   http://stuff.mit.edu/afs/sipb/contrib/linux/Documentation/apparmor.txt
-   https://apparmor.wiki.kernel.org/index.php/Kernel_interfaces
-   https://apparmor.wiki.kernel.org/index.php/AppArmor_versions
-   http://manpages.ubuntu.com/manpages/oneiric/man5/apparmor.d.5.html
-   http://manpages.ubuntu.com/manpages/oneiric/man8/apparmor_parser.8.html
-   https://apparmor.wiki.kernel.org/index.php/Distro_CentOS
-   http://bodhizazen.net/aa-profiles/
-   https://wiki.ubuntu.com/ApparmorProfileMigration
-   wikipedia:Linux_Security_Modules
-   https://apparmor.wiki.kernel.org/index.php/Gittutorial

AppArmor Packages
-----------------

-   Arch's linux package has AppArmor support
-   aur/apparmor

Kernel Configuration
--------------------

Here is configuration of ArchLinux kernel which enables AppArmor (just
FYI, you do not need to touch it):

     CONFIG_SECURITY_APPARMOR=y
     CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=0
     # CONFIG_DEFAULT_SECURITY_APPARMOR is not set

However, integration of AppArmor into the 2.6.36 kernel is not quite
complete. It is missing network mediation and some of the interfaces for
introspection. See here for details. There are compatibility patches
that can be applied to every recent kernel to reintroduce these
interfaces. The patchset is pretty small and should be applied if you
decide to use AppArmor. (Note: the patchset for 2.6.39 works with Kernel
3.0.x)

Bootloader Configuration
------------------------

> Enable

To test profiles, or enforce the use of AppArmor it must be enabled at
boot time. To do this add apparmor=1 security=apparmor to the kernel
boot parameters.

After reboot you can test if AppArmor is really enabled using this
command as root:

     # cat /sys/module/apparmor/parameters/enabled 
     Y

(Y=enabled, N=disabled, no such file = module not in kernel)

Disable

AppArmor will be disabled by default in Arch Linux, so you will not need
to disable it explicitly until you will build your own kernel with
AppArmor enabled by default. If so, Add apparmor=0 security="" to kernel
boot parameters.

System Configuration
--------------------

> Mounts (/etc/fstab securityfs)

https://apparmor.wiki.kernel.org/index.php/Kernel_interfaces

     none     /sys/kernel/security securityfs defaults            0      0

UserSpace Tools
---------------

> Users

You can currently install userspace tools from AUR.

> Maintainers

You need userspace tools that are compatible with your kernel version.
The compatibility list can be found here:
https://apparmor.wiki.kernel.org/index.php/AppArmor_versions e.g.:
Kernel 2.6.36 is compatible with AppArmor 2.5.1

More Info
---------

AppArmor, like most other LSMs, supplements rather than replaces the
default Discretionary access control. As such it's impossible to grant a
process more privileges than it had in the first place.

Ubuntu, SUSE and a number of other distributions use it by default. RHEL
(and it's variants) use SELinux which requires good userspace
integration to work properly. People tend to agree that it is also much
much harder to configure correctly.

Taking a common example - A new Flash vulnerability: If you were to
browse to a malicious website AppArmor can prevent the exploited plugin
from accessing anything that may contain private information. In almost
all browsers, plugins run out of process which makes isolating them much
easier.

AppArmor profiles (usually) get stored in easy to read text files in
/etc/apparmor.d

Every breach of policy triggers a message in the system log, and many
distributions also integrate it into DBUS so that you get real-time
violation warnings popping up on your desktop.

See also
--------

-   TOMOYO Linux
-   SELinux

Retrieved from
"https://wiki.archlinux.org/index.php?title=AppArmor&oldid=254481"

Categories:

-   Security
-   Kernel
