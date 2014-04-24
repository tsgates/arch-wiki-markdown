VMware
======

Related articles

-   Installing Arch Linux in VMware
-   VirtualBox
-   KVM
-   QEMU
-   Xen
-   Moving an existing install into (or out of) a virtual machine

This article is about installing VMware in Arch Linux; you may also be
interested in Installing Arch Linux in VMware.

Note:This article supports only the latest major VMware versions,
meaning VMware Workstation 10 and VMware Player (Plus) 6.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 VMware module patches and installation
        -   2.1.1 3.13.6 kernels
        -   2.1.2 3.13 kernels - patch for Netfilter-enabled systems
            (optional)
    -   2.2 Systemd service
-   3 Launching the application
-   4 Tips and tricks
    -   4.1 Entering the Workstation License Key
        -   4.1.1 From terminal
        -   4.1.2 From GUI
    -   4.2 Extracting the VMware BIOS
        -   4.2.1 Using the modified BIOS
    -   4.3 Using DKMS to manage the modules
        -   4.3.1 Preparation
        -   4.3.2 Build configuration
            -   4.3.2.1 1) Using Git
            -   4.3.2.2 2) Manual setup
        -   4.3.3 Installation
-   5 Troubleshooting
    -   5.1 /dev/vmmon not found
    -   5.2 Kernel headers for version 3.x-xxxx were not found. If you
        installed them[...]
    -   5.3 USB devices not recognized
    -   5.4 vmci/vsock modules not loading automatically
    -   5.5 The installer fails to start
    -   5.6 Incorrect login/password when trying to access VMware
        remotely
    -   5.7 Issues with ALSA output
    -   5.8 Kernel-based Virtual Machine (KVM) is running
-   6 Uninstallation

Installation
------------

Note:VMware Workstation/Player (Plus) will not be manageable with pacman
as the files are not installed with it.

1. Install the correct dependencies: gtkmm (for the GUI),
linux-headers (for module compilation).

2. Download the latest VMware Workstation or VMware Player (Plus) (or a
beta version, if available).

3. Start the installation (--console uses terminal instead of the GUI):

    $ chmod +x VMware-edition-version.release.architecture.bundle
    # ./VMware-edition-version.release.architecture.bundle --console

Note:To ignore fatal errors use -I / --ignore-errors.

4. Read and accept the main application and the OVF Tool component EULAs
to continue.

5. (optional) Enter license key.

6. During installation you will get an error about
"No rc*.d style init script directories" being given. This can be safely
ignored, since Arch has moved to systemd.

Note:VMware Player (Plus) 6 requires a directory to be entered for RC
scripts or it will fail installing them. This will cause module
compilation to fail because it is unable to stop its services. Just
create an empty script called vmware in the directory given to the
installer:

    # touch /etc/init.d/vmware
    # chmod +x /etc/init.d/vmware

Configuration
-------------

Tip:There is also a package called vmware-patch in the AUR with the
intention of trying to automate this section (it also supports older
VMware versions).

> VMware module patches and installation

VMware Workstation 10.0.1 and Player (Plus) 6.0.1 support kernels up to
3.13.5.

3.13.6 kernels

Since 3.13.6 patching vmnet and vmblock is required.

    $ cd /tmp
    $ git clone https://github.com/bawaaaaah/vmware_patch.git
    $ cd /usr/lib/vmware/modules/source
    # tar -xvf vmblock.tar
    # tar -xvf vmnet.tar
    # patch -p1 -i /tmp/vmware_patch/vmblock-patch-kernel-3.13
    # patch -p1 -i /tmp/vmware_patch/vmnet-patch-kernel-3.13
    # tar -cf vmblock.tar vmblock-only
    # tar -cf vmnet.tar vmnet-only
    # rm -r vmblock-only vmnet-only
    # vmware-modconfig --console --install-all

3.13 kernels - patch for Netfilter-enabled systems (optional)

Systems that have enabled the network packet filtering framework
(Netfilter or CONFIG_NETFILTER) on 3.13 kernels (found in:
Networking Support → Networking Options) will fail to build the vmnet
module.

This isn't included in the Arch stock kernel, but for custom kernels a
patch can be found here:

    $ curl http://pastie.org/pastes/8672356/download -o /tmp/vmware-netfilter.patch
    $ cd /usr/lib/vmware/modules/source
    # tar -xvf vmnet.tar
    # patch -p0 -i /tmp/vmware-netfilter.patch
    # tar -cf vmnet.tar vmnet-only
    # rm -r vmnet-only
    # vmware-modconfig --console --install-all

> Systemd service

7. (Optional) Instead of using
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

After which you can enable it on boot, with:

    # systemctl enable vmware

Launching the application
-------------------------

8. Now, open your VMware Workstation (vmware in the console) or VMware
Player (Plus) (vmplayer in the console) to configure & use!

Tip:To (re)build the modules from terminal, use:

    # vmware-modconfig --console --install-all

Tips and tricks
---------------

> Entering the Workstation License Key

From terminal

    # /usr/lib/vmware/bin/vmware-vmx-debug --new-sn XXXXX-XXXXX-XXXXX-XXXXX-XXXXX

Where XXXXX-XXXXX-XXXXX-XXXXX-XXXXX is your license key.

Note:The -debug binary informs the user of an incorrect license.

From GUI

If the above doesn't work, you can try:

    # /usr/lib/vmware/bin/vmware-enter-serial

> Extracting the VMware BIOS

    $ objcopy /usr/lib/vmware/bin/vmware-vmx -O binary -j bios440 --set-section-flags bios440=a bios440.rom.Z
    $ perl -e 'use Compress::Zlib; my $v; read STDIN, $v, '$(stat -c%s "./bios440.rom.Z")'; $v = uncompress($v); print $v;' < bios440.rom.Z > bios440.rom

Using the modified BIOS

If and when you decide to modify the extracted BIOS you can make your
virtual machine use it by moving it to ~/vmware/Virtual machine name:

    $ mv bios440.rom ~/vmware/Virtual machine name/

then adding the name to the Virtual machine name.vmx file:

    ~/vmware/Virtual machine name/Virtual machine name.vmx

    bios440.filename = "bios440.rom"

> Using DKMS to manage the modules

The Dynamic Kernel Module Support (DKMS) can be used to manage
Workstation modules and to void from re-running vmware-modconfig each
time the kernel changes. The following example uses a custom Makefile to
compile and install the modules through vmware-modconfig. Afterwards
they are removed from the current kernel tree.

Preparation

First install dkms from the official repositories.

Then create a source directory for the Makefile and the dkms.conf:

    # mkdir /usr/src/vmware-modules-9/

Build configuration

Fetch the files with git or use the ones below.

1) Using Git

    $ cd /tmp
    $ git clone https://github.com/bawaaaaah/dkms-workstation.git
    $ git checkout fix.new_archlinux_headers_path
    # cp /tmp/dkms-workstation/Makefile /tmp/dkms-workstation/dkms.conf /usr/src/vmware-modules-9/

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
    HEADERS := /usr/lib/modules/$(KERNEL)/build/include
    GCC := $(shell vmware-modconfig --console --get-gcc)
    DEST := /lib/modules/$(KERNEL)/vmware

    TARGETS := vmmon vmnet vmblock vmci vsock

    LOCAL_MODULES := $(addsuffix .ko, $(TARGETS))

    all: $(LOCAL_MODULES)
    	mkdir -p modules/
    	mv *.ko modules/
    	rm -rf $(DEST)
    	depmod

    $(HEADERS)/linux/version.h:
    	ln -s $(HEADERS)/generated/uapi/linux/version.h $(HEADERS)/linux/version.h

    %.ko: $(HEADERS)/linux/version.h
    	vmware-modconfig --console --build-mod -k $(KERNEL) $* $(GCC) $(HEADERS) vmware/
    	cp -f $(DEST)/$@ .

    clean: rm -rf modules/

Installation

The modules can then be installed with:

    # dkms -m vmware-modules -v 9 -k $(uname -r) install

If everything went well, the modules will now be recompiled
automatically the next time the kernel changes.

Troubleshooting
---------------

> /dev/vmmon not found

The full error is:

    Could not open /dev/vmmon: No such file or directory.
    Please make sure that the kernel module `vmmon' is loaded.

This means that at least the vmmon VMware service is not running. If
using the systemd service from step 7. it should be (re)started.

> Kernel headers for version 3.x-xxxx were not found. If you installed them[...]

Install the headers (linux-headers).

Note:Upgrading the kernel and the headers will require you to boot to
the new kernel to match the version of the headers. This is a relatively
common error.

> USB devices not recognized

Tip:Also handled by vmware-patch.

If VMware services are running (see step 7. for a systemd service), your
installation is missing the vmware-USBArbitrator script. To readd it
manually see this forum post.

You may also manually extract the VMware bundle and copy the
vmware-USBArbitrator script from
destination folder/vmware-usbarbitrator/etc/init.d/ to /etc/init.d/:

    $ ./VMware-edition-version.release.architecture.bundle --extract /tmp/vmware-bundle
    # cp /tmp/vmware-bundle/vmware-usbarbitrator/etc/init.d/vmware-USBArbitrator /etc/init.d/

> vmci/vsock modules not loading automatically

The full error is:

    Failed to open device "/dev/vmci": No such file or directory
    Please make sure that the kernel module 'vmci' is loaded.
    Module DevicePowerOn power on failed.
    Failed to start the virtual machine.

This is caused by an issue in the assignment of $mod in
/etc/init.d/vmware:

    Starting VMware services:
      Virtual machine monitor                                   done
      Virtual machine communication interface                   failed
      VM communication interface socket family                  failed
      Blocking file system                                      done
      Virtual ethernet                                          done
      VMware Authentication Daemon                              done

This can be fixed by just not using it:

    /etc/init.d/vmware

    @@ vmwareStartVmci()
    ...
    - vmwareLoadModule "$mod"
    + vmwareLoadModule "$vmci"
    [...]

    @@ vmwareStopVmci()
    ...
    - vmwareUnloadModule "${mod}"
    + vmwareUnloadModule "$vmci"
    [...]

    @@ vmwareStartVsock()
    ...
    - vmwareLoadModule "$mod"
    + vmwareLoadModule "$vsock"
    [...]

    @@ vmwareStopVsock()
    ...
    - vmwareUnloadModule "$mod"
    + vmwareUnloadModule "$vsock"

The vmware services can then be restarted.

> The installer fails to start

If you just get back to the prompt when opening the .bundle, then you
probably have a deprecated or broken version of the VMware installer and
you should remove it (you may also refer to the uninstallation section
of this article):

    # rm -r /etc/vmware-installer

> Incorrect login/password when trying to access VMware remotely

VMware Workstation 10 provides the possibility to remotely manage Shared
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

and restart the vmware systemd service.

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
4.  Open the Virtual machine name.vmx config file of the VM in a text
    editor, located under ~/vmware/Virtual machine name/, and edit the
    sound.fileName field, e.g.:
    sound.fileName="surround51:CARD=Live,DEV=0". Ensure that it also
    reads sound.autodetect="FALSE".
5.  Resume/Power on the VM.

> Kernel-based Virtual Machine (KVM) is running

To disable KVM on boot, you can use something like:

    /etc/modprobe.d/vmware.conf

    blacklist kvm
    blacklist kvm-amd   # For AMD CPUs
    blacklist kvm-intel # For Intel CPUs

Uninstallation
--------------

To uninstall VMware you need the product name (either vmware-workstation
or vmware-player). To list all the installed products:

    $ vmware-installer -l

and uninstall with:

    # vmware-installer -u vmware-product

Remember to also disable and remove the vmware service:

    # systemctl disable vmware
    # rm /etc/systemd/system/vmware.service

You may also want to have a look at the module directories in
/usr/lib/modules/[kernel name]/misc/ for any leftovers.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VMware&oldid=305882"

Category:

-   Virtualization

-   This page was last modified on 20 March 2014, at 15:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
