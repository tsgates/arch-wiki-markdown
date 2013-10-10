VMware
======

> Summary

This article will explain how to install and configure VMware
Workstation/Player in Arch.

> Related

Installing Arch Linux in VMware

VirtualBox

KVM

QEMU

Xen

Moving an existing install into (or out of) a virtual machine

This article is about installing VMware in Arch Linux; you may also be
interested in Installing Arch Linux in VMware.

Note:This article supports only the latest major VMware versions,
meaning VMware Workstation 9 and VMware Player 5.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Module tool paths                                            |
|         -   2.1.1 1) A short-term solution                               |
|         -   2.1.2 2) A long-term solution                                |
|                                                                          |
|     -   2.2 VMware module patches and installation                       |
|         -   2.2.1 3.7 kernels and up                                     |
|         -   2.2.2 3.8 / 3.9 kernels                                      |
|         -   2.2.3 3.5 / 3.6 / 3.7 kernels                                |
|                                                                          |
|     -   2.3 Systemd service                                              |
|                                                                          |
| -   3 Launching the application                                          |
| -   4 Tips & Tricks                                                      |
|     -   4.1 Entering the Workstation License Key from terminal           |
|     -   4.2 Extracting the VMware BIOS                                   |
|         -   4.2.1 Using the modified BIOS                                |
|                                                                          |
|     -   4.3 Copy-On-Write (CoW)                                          |
|     -   4.4 Using DKMS to manage the modules                             |
|         -   4.4.1 Preparation                                            |
|         -   4.4.2 Build configuration                                    |
|             -   4.4.2.1 1) Using Git                                     |
|             -   4.4.2.2 2) Manual setup                                  |
|                                                                          |
|         -   4.4.3 Installation                                           |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Could not open /dev/vmmon: No such file or directory.        |
|     -   5.2 Kernel headers for version 3.x-xxxx were not found. If you   |
|         installed them[...]                                              |
|     -   5.3 USB devices not recognized                                   |
|         -   5.3.1 1) The vmware-USBArbitrator script is missing          |
|         -   5.3.2 2) The vmware-usbarbitrator binary is segfaulting      |
|                                                                          |
|     -   5.4 process XXXX: Attempt to remove filter function [...]        |
|     -   5.5 The installer fails to start                                 |
|     -   5.6 Incorrect login/password when trying to access VMware        |
|         remotely                                                         |
|     -   5.7 Issues with ALSA output                                      |
|                                                                          |
| -   6 Uninstallation                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Note: VMware Workstation/Player will not be manageable with pacman as
the files are not installed with it.

1. Download the latest VMware Workstation or VMware Player (you may also
try the testing (Beta/RC) versions).

2. Start the installation (--console uses terminal instead of the GUI):

    $ chmod +x VMware-<edition>-<version>.<release>.<architecture>.bundle
    # ./VMware-<edition>-<version>.<release>.<architecture>.bundle --console

3. Read & accept the EULA to continue.

4. Set System service scripts directory to /etc/init.d.

5. (Optional) If Eclipse is installed, enter the directory path to the
Integrated Virtual Debugger.

6. You will now get an error about the
"rc*.d style init script directories" not being set. This can, however,
be safely ignored.

Configuration
-------------

Tip:There is also a package called vmware-patch in the AUR with the
intention of trying to automate this section (it also supports older
VMware versions).

Note:Ensure you have installed the correct headers required for building
the modules (linux from [core] uses linux-headers).

> Module tool paths

7. The module tool paths of certain Workstation scripts now need to be
pointed to /usr/bin/ instead of /sbin/. These include the service script
in /etc/init.d/ and some other ones in /usr/bin/.

1) A short-term solution

A short-term solution consists of editing the files directly. You will
need to redo this upon every update.

-   For Workstation:

    # perl -p -i -e 's|/sbin/(?!modprobe)|/usr/bin/|g' /etc/init.d/vmware /usr/bin/vm-support /usr/bin/vmplayer /usr/bin/vmware /usr/bin/vmware-hostd /usr/bin/vmware-wssc-adminTool

-   For Player:

    # perl -p -i -e 's|/sbin/(?!modprobe)|/usr/bin/|g' /etc/init.d/vmware /usr/bin/vm-support /usr/bin/vmplayer

2) A long-term solution

You could also just create symlinks with:

    # ln -s /usr/bin/insmod /usr/bin/lsmod /usr/bin/modinfo /usr/bin/rmmod /sbin/

> VMware module patches and installation

VMware Workstation 9 and Player 5 both support kernels up to 3.9.

Note:This section is currently useful only for VMware Workstation and
Player lower than 9.0.2 and 5.0.2, respectively.

Note:Due to different VMware versions, you may need to set the vmreqver
or plreqver variable for VMware Workstation or Player respectively in
the patch-modules_3.X.0.sh script.

The following patches will also install the modules afterwards by
executing # vmware-modconfig --console --install-all.

3.7 kernels and up

With the arrival of 3.7 the directory structure of the uapi sources (and
thus the headers) has changed. The missing kernel header version.h can
be symlinked with:

    # ln -s /usr/src/linux-$(uname -r)/include/generated/uapi/linux/version.h /usr/src/linux-$(uname -r)/include/linux/

You can replace "$(uname -r)" with any kernel not currently running.

Note:You will need to redo this upon every kernel update.

3.8 / 3.9 kernels

In addition to the header symlink outlined above 3.8/3.9 kernels also
need this (packaged together with the script in here):

    $ cd /tmp
    $ curl -O https://raw.github.com/willysr/SlackHacks/master/vmware/vmware-3.8/vmware9.0.1_kernel3.8.zip
    $ bsdtar -xvf vmware9.0.1_kernel3.8.zip
    # ./patch-modules_3.8.0.sh

3.5 / 3.6 / 3.7 kernels

A change in the format of the kernel exception table introduced back in
April affecting the vmmon module is known to cause crashes in Fedora
guests. The patch here creates a portable exception table (packaged
together with the script in here, which will also reload the vmmon
module):

    $ cd /tmp
    $ curl -O http://communities.vmware.com/servlet/JiveServlet/download/2103172-94260/vmware9_kernel35_patch.tar.bz2
    $ tar -xvf --strip-components=1 vmware9_kernel35_patch.tar.bz2  # The "--strip-components=1" flag extracts the files only
    # ./patch-modules_3.5.0.sh

> Systemd service

8. (Optional) Instead of using
# /etc/init.d/vmware {start|stop|status|restart} directly to manage the
services you may also create a .service file (or files):

    /etc/systemd/system/vmware.service

    [Unit]
    Description=VMware daemon

    [Service]
    ExecStart=/etc/init.d/vmware start
    ExecStop=/etc/init.d/vmware stop
    PIDFile=/var/lock/subsys/vmware
    TimeoutSec=0
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

To start the .service on boot:

    # systemctl enable vmware

Launching the application
-------------------------

9. Now, open your VMware Workstation (vmware in the console) or VMware
Player (vmplayer in the console) to configure & use!

Tip:To (re)build the modules, use:

    # vmware-modconfig --console --install-all

Tips & Tricks
-------------

> Entering the Workstation License Key from terminal

    # /usr/lib/vmware/bin/vmware-vmx-debug --new-sn XXXXX-XXXXX-XXXXX-XXXXX-XXXXX

Where XXXXX-XXXXX-XXXXX-XXXXX-XXXXX is your license key.

> Extracting the VMware BIOS

    $ objcopy /usr/lib/vmware/bin/vmware-vmx -O binary -j bios440 --set-section-flags bios440=a bios440.rom.Z
    $ perl -e 'use Compress::Zlib; my $v; read STDIN, $v, '$(stat -c%s "./bios440.rom.Z")'; $v = uncompress($v); print $v;' < bios440.rom.Z > bios440.rom

Using the modified BIOS

If and when you decide to modify the extracted BIOS you can make your
virtual machine use it by moving it to ~/vmware/<Virtual machine name>:

    $ mv bios440.rom ~/vmware/<Virtual machine name>/

then adding the name to the <Virtual machine name>.vmx file:

    ~/vmware/<Virtual machine name>/<Virtual machine name>.vmx

    bios440.filename = "bios440.rom"

> Copy-On-Write (CoW)

CoW comes with some advantages, but can negatively affect performance
with large files that have small random writes (e.g. database files and
virtual machine images):

    $ chattr +C ~/vmware/<Virtual machine name>/<Virtual machine name>.vmx

Note:From the chattr man page: "For btrfs, the C flag should be set only
on new or empty files. If set on a file which already has data blocks,
it is undefined when the blocks assigned to the file will be fully
stable. If set on a directory, only new files will be affected."

> Using DKMS to manage the modules

The Dynamic Kernel Module Support (DKMS) can be used to manage
Workstation modules and to void from re-running vmware-modconfig each
time the kernel changes. The following example uses a custom Makefile to
compile and install the modules through vmware-modconfig. Afterwards
they are removed from the current kernel tree.

Preparation

First install dkms from the Community repository:

    # pacman -S dkms

then create a source directory for the Makefile and the dkms.conf:

    # mkdir /usr/src/vmware-modules-9/

Build configuration

Fetch the files from Git or use the ones below.

1) Using Git

    $ cd /tmp
    $ git clone git://github.com/djod4556/dkms-workstation.git
    # cp /tmp/dkms-workstation.git/Makefile /tmp/dkms-workstation.git/dkms.conf /usr/src/vmware-modules-9/

2) Manual setup

The dkms.conf describes the module names and the
compilation/installation procedure. AUTOINSTALL="yes" tells the modules
to be recompiled/installed automatically each time:

    /usr/src/vmware-modules-9/dkms.conf

    PACKAGE_NAME="vmware-modules"
    PACKAGE_VERSION="9"

    MAKE[0]="make all"
    CLEAN="make clean"

    BUILT_MODULE_NAME[0]="vmmon"
    BUILT_MODULE_LOCATION[0]="modules"

    BUILT_MODULE_NAME[1]="vmnet"
    BUILT_MODULE_LOCATION[1]="modules"

    BUILT_MODULE_NAME[2]="vmblock"
    BUILT_MODULE_LOCATION[2]="modules"

    BUILT_MODULE_NAME[3]="vmci"
    BUILT_MODULE_LOCATION[3]="modules"

    BUILT_MODULE_NAME[4]="vsock"
    BUILT_MODULE_LOCATION[4]="modules"

    DEST_MODULE_LOCATION[0]="/extra/vmware"
    DEST_MODULE_LOCATION[1]="/extra/vmware"
    DEST_MODULE_LOCATION[2]="/extra/vmware"
    DEST_MODULE_LOCATION[3]="/extra/vmware"
    DEST_MODULE_LOCATION[4]="/extra/vmware"

    AUTOINSTALL="yes"

and now the Makefile:

    /usr/src/vmware-modules-9/Makefile

    KERNEL := $(KERNELRELEASE)
    HEADERS := /usr/src/linux-$(KERNEL)/include
    GCC := $(shell vmware-modconfig --console --get-gcc)
    DEST := /lib/modules/$(KERNEL)/vmware

    TARGETS := vmmon vmnet vmblock vmci vsock

    LOCAL_MODULES := $(addsuffix .ko, $(TARGETS))

    all: $(LOCAL_MODULES)
            mkdir -p modules/
            mv *.ko modules/
            rm -rf $(DEST)
            depmod

    /usr/src/linux-$(KERNEL)/include/linux/version.h:
            ln -s /usr/src/linux-$(KERNEL)/include/generated/uapi/linux/version.h /usr/src/linux-$(KERNEL)/include/linux/

    %.ko: /usr/src/linux-$(KERNEL)/include/linux/version.h
            vmware-modconfig --console --build-mod -k $(KERNEL) $* $(GCC) $(HEADERS) vmware/
            cp -f $(DEST)/$*.ko .

    clean:
            rm -rf modules/

Installation

The modules can then be registered:

    # dkms -m vmware-modules -v 9 -k $(uname -r) add

built:

    # dkms -m vmware-modules -v 9 -k $(uname -r) build

and installed:

    # dkms -m vmware-modules -v 9 -k $(uname -r) install

If everything went well, the modules will now be recompiled
automatically the next time the kernel changes.

Troubleshooting
---------------

> Could not open /dev/vmmon: No such file or directory.

The full error is:

    Could not open /dev/vmmon: No such file or directory.
    Please make sure that the kernel module `vmmon' is loaded.

This means that at least the vmmon VMware service is not running. If
using the .service file from step 8. all VMware services can be started
with:

    # systemctl start vmware

otherwise use:

    # /etc/init.d/vmware start

> Kernel headers for version 3.x-xxxx were not found. If you installed them[...]

Install them with:

    # pacman -S linux-headers

Note:Upgrading the kernel and the headers will require you to boot to
the new kernel to match the version of the headers. This is a relatively
common error.

> USB devices not recognized

Tip:Also handled by vmware-patch.

1) The vmware-USBArbitrator script is missing

For some reason, some installations are missing the vmware-USBArbitrator
script. To readd it manually see this forum post.

You may also manually extract the VMware bundle and copy the
vmware-USBArbitrator script from
<destination folder>/vmware-usbarbitrator/etc/init.d/ to /etc/init.d/:

    $ ./VMware-<edition>-<version>.<release>.<architecture>.bundle --extract /tmp/vmware-bundle
    # cp /tmp/vmware-bundle/vmware-usbarbitrator/etc/init.d/vmware-USBArbitrator /etc/init.d/

2) The vmware-usbarbitrator binary is segfaulting

This could also mean that the vmware-usbarbitrator binary called in the
script is segfaulting:

    # vmware-usbarbitrator

    Pipe unexpectedly closed.	

    # vmware-usbarbitrator --info -f

    VTHREAD initialize main thread 2 "usbArb" pid 6426
    Segmentation fault

This is caused by an empty /etc/arch-release (owned by filesystem). It
is used by the service to alter its behavior based on the distribution's
release version.

To fix it, add a version string in the form of <year>.<month>(.<day>)
(e.g. 2013.04.01).

> process XXXX: Attempt to remove filter function [...]

The full error is, for example:

    process 6094: Attempt to remove filter function 0xadcc96f0 user data 0xb795aba0, but no such filter has been added
      D-Bus not built with -rdynamic so unable to print a backtrace
    Aborted

This means that the hal daemon is not running. Install hal from the AUR
and start the daemon with:

    # hald

> The installer fails to start

If you just get back to the prompt when opening the .bundle, then you
probably have a deprecated or broken version of the VMware installer and
you should remove it (you may also refer to the uninstallation section
of this article):

    # rm -r /etc/vmware-installer

> Incorrect login/password when trying to access VMware remotely

VMware Workstation 9 provides the possibility to remotely manage Shared
VMs through the vmware-workstation-server service. However, this will
fail with the error "incorrect username/password" due to incorrect PAM
configuration of the vmware-authd service. To fix it, edit
/etc/pam.d/vmware-authd like this:

    /etc/pam.d/vmware-authd

    #%PAM-1.0
    auth     required       pam_unix.so
    account  required       pam_unix.so
    password required       pam_permit.so
    session  required       pam_unix.so

and restart VMware services with:

    # systemctl restart vmware

Now you can connect to the server with the credentials provided during
the installation.

Note:libxslt may be required for starting virtual machines.

> Issues with ALSA output

The following instructions from Bankim Bhavsar's wiki show how to
manually adjust the ALSA output device in a VMware .vmx file. This might
help with quality issues or with enabling proper HD audio output:

1.  Suspend/Power off the VM.
2.  Run aplay -L
3.  If you are interested in playing 5.1 surround sound from the guest,
    look for surround51:CARD=vendor-name,DEV=num. If you are
    experiencing quality issues, look out for a line starting with
    front.
4.  Open the <Virtual machine name>.vmx config file of the VM in a text
    editor, located under ~/vmware/<Virtual machine name>/, and edit the
    sound.fileName field, e.g.:
    sound.fileName="surround51:CARD=Live,DEV=0". Ensure that it also
    reads sound.autodetect="FALSE".
5.  Resume/Power on the VM.

Uninstallation
--------------

To uninstall VMware you need the product name (either vmware-workstation
or vmware-player). To list all the installed products:

    # vmware-installer -l

and uninstall with:

    # vmware-installer -u <vmware-product>

Manually included symlinks have to be removed manually in /sbin/:

    # rm /sbin/insmod /sbin/lsmod /sbin/modinfo /sbin/rmmod

Remember to also remove the .service file:

    # systemctl disable vmware
    # rm /etc/systemd/system/vmware.service

You may also want to have a look at the kernel directories in /usr for
any leftovers. The now unnecessary #3.7 kernels and up patching step
leaves header directories in /usr/src/ (full path:
/usr/src/linux-[kernel name]/include/linux/version.h).

The module directories are located in
/usr/lib/modules/[kernel name]/misc/.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VMware&oldid=255776"

Category:

-   Virtualization
