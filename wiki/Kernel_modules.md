Kernel modules
==============

> Summary

This article covers the various methods for operating with kernel
modules.

> Related

Boot Debugging

Kernels

Kernel parameters

> Resources

modprobe man page

Kernel modules are pieces of code that can be loaded and unloaded into
the kernel upon demand. They extend the functionality of the kernel
without the need to reboot the system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Obtaining information                                              |
| -   3 Loading                                                            |
| -   4 Removal                                                            |
| -   5 Configuration                                                      |
|     -   5.1 Using files in /etc/modprobe.d/                              |
|     -   5.2 Using kernel command line                                    |
|                                                                          |
| -   6 Aliasing                                                           |
| -   7 Blacklisting                                                       |
|     -   7.1 Using files in /etc/modprobe.d/                              |
|     -   7.2 Using kernel command line                                    |
|                                                                          |
| -   8 Tips and tricks                                                    |
|     -   8.1 Bash function to list module parameters                      |
|                                                                          |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

Overview
--------

To create a kernel module, you can read this guide. A module can be
configured to be build-in or loadable. To dynamically load or remove a
module, it has to be configured as a loadable module in the kernel
configuration (the line related to the module will therefore display the
letter M).

Modules are stored in /usr/lib/modules/kernel_release. You can use the
command uname -r to get your current kernel release version.

Note:Module names often use underscores (_) or dashes (-), however those
symbols are interchangeable both when using the modprobe command and in
configuration files in /etc/modprobe.d/.

Obtaining information
---------------------

To show what kernel modules are currently loaded:

    $ lsmod

To show information about a module:

    $ modinfo module_name

To list the options that are set for a loaded module:

    $ systool -v -m module_name

To display the comprehensive configuration of all the modules:

    $ modprobe -c | less

To display the configuration of a particular module:

    $ modprobe -c | grep module_name

List the dependencies of a module (or alias), including the module
itself:

    $ modprobe --show-depends module_name

Loading
-------

The /sbin/modprobe command handles the addition and removal of modules
from the Linux kernel. To manually load (or add) a module, run:

    # modprobe module_name

Most modules should be loaded on-demand. Modules to be unconditionally
loaded at boot can be specified in /etc/modules-load.d/, for example:

    /etc/modules-load.d/virtio-net.conf

    #Load 'virtio-net.ko' at boot.

    virtio-net

Removal
-------

To remove (or unload) a module, use the following command:

    # modprobe -r module_name

Or, alternatively:

    # rmmod module_name

Configuration
-------------

To pass a parameter to a kernel module you can use a modprobe conf file
or use the kernel command line. See also Systemd#Kernel_modules.

> Using files in /etc/modprobe.d/

The /etc/modprobe.d/ directory can be used to pass module settings to
udev, which will use modprobe to manage the loading of the modules
during system boot. You can use configuration files with any name in the
directory, given that they end with the .conf extension. The syntax is:

    /etc/modprobe.d/myfilename.conf

    options modname parametername=parametercontents

For example:

    /etc/modprobe.d/thinkfan.conf

    #On Thinkpads, this lets the 'thinkfan' daemon control fan speed.

    options thinkpad_acpi fan_control=1

Note:If any of the modules affected are loaded while booting (from the
init ramdisk) then you will need to add the appropriate .conf-file to
FILES in mkinitcpio.conf.

> Using kernel command line

If the module is built into the kernel you can also pass options to the
module using the kernel command line. For all common Bootloaders the
following syntax is correct:

    modname.parametername=parametercontents

for example:

    thinkpad_acpi.fan_control=1

Simply add this to your bootloaders kernel-line as described in Kernel
Parameters.

Aliasing
--------

Aliases are alternate names for a module. For example: "alias my-mod
really_long_modulename" means you can use "modprobe my-mod" instead of
"modprobe really_long_modulename". You can also use shell-style
wildcards, so "alias my-mod* really_long_modulename" means that
"modprobe my-mod-something" has the same effect. Create an alias:

    /etc/modprobe.d/myalias.conf

    alias mymod really_long_module_name

Some modules have aliases which are used to autoload them when they are
needed by an application. Disabling these aliases can prevent
auto-loading, but will still allow the modules to be manually loaded.

    /etc/modprobe.d/modprobe.conf

    #Prevent Bluetooth autoload.

    alias net-pf-31 off

Blacklisting
------------

Blacklisting, in the context of kernel modules, is a mechanism to
prevent the kernel module from loading. This could be useful if, for
example, the associated hardware is not needed, or if loading that
module causes problems: for instance there may be two kernel modules
that try to control the same piece of hardware, and loading them
together would result in a conflict.

Some modules are loaded as part of the initramfs. mkinitcpio -M will
print out all autodetected modules: to prevent the initramfs from
loading some of those modules, blacklist them in
/etc/modprobe.d/modprobe.conf. Running mkinitcpio -v will list all
modules pulled in by the various hooks (e.g. filesystem hook, SCSI hook,
etc.). Remember to add that .conf file to the FILES section in
/etc/mkinitcpio.conf (if you have not done so already) and rebuild the
initramfs once you have blacklisted the modules, and to reboot
afterwards.

> Using files in /etc/modprobe.d/

Create a .conf file inside /etc/modprobe.d/ and append a line for each
module you want to blacklist, using the blacklist keyword. If for
example you want to prevent the pcspkr module from loading:

    /etc/modprobe.d/nobeep.conf

    #Do not load the 'pcspkr' module on boot.

    blacklist pcspkr

Note:The blacklist command will blacklist a module so that it will not
be loaded automatically, but the module may be loaded if another
non-blacklisted module depends on it or if it is loaded manually.

However, there is a workaround for this behaviour; the install command
instructs modprobe to run a custom command instead of inserting the
module in the kernel as normal, so you can force the module to always
fail loading with:

    /etc/modprobe.d/blacklist.conf

    ...
    install module_name /bin/false
    ...

This will effectively blacklist that module and any other that depends
on it.

> Using kernel command line

Tip:This can be very useful if a broken module makes it impossible to
boot your system.

You can also blacklist modules from the bootloader.

Simply add modprobe.blacklist=modname1,modname2,modname3 to your
bootloader's kernel line, as described in Kernel Parameters.

Note:When you are blacklisting more than one module, note that they are
separated by commas only. Spaces or anything else might presumably break
the syntax.

Tips and tricks
---------------

> Bash function to list module parameters

Here is a nice bash function to be run as root that will show a list of
all the currently loaded modules and all of their parameters, including
the current value of the parameter. It uses /proc/modules to retrieve
the current list of loaded modules, then access the module file directly
with modinfo to grab a description of the module and descriptions for
each param (if available), finally it accesses the sysfs filesystem to
grab the actual parameter names and currently loaded values.

    function aa_mod_parameters () 
    { 
        N=/dev/null;
        C=`tput op` O=$(echo -en "\n`tput setaf 2`>>> `tput op`");
        for mod in $(cat /proc/modules|cut -d" " -f1);
        do
            md=/sys/module/$mod/parameters;
            [[ ! -d $md ]] && continue;
            m=$mod;
            d=`modinfo -d $m 2>$N | tr "\n" "\t"`;
            echo -en "$O$m$C";
            [[ ${#d} -gt 0 ]] && echo -n " - $d";
            echo;
            for mc in $(cd $md; echo *);
            do
                de=`modinfo -p $mod 2>$N | grep ^$mc 2>$N|sed "s/^$mc=//" 2>$N`;
                echo -en "\t$mc=`cat $md/$mc 2>$N`";
                [[ ${#de} -gt 1 ]] && echo -en " - $de";
                echo;
            done;
        done
    }

Here is some sample output:

    # aa_mod_parameters

    >>> ehci_hcd - USB 2.0 'Enhanced' Host Controller (EHCI) Driver
            hird=0 - hird:host initiated resume duration, +1 for each 75us (int)
            ignore_oc=N - ignore_oc:ignore bogus hardware overcurrent indications (bool)
            log2_irq_thresh=0 - log2_irq_thresh:log2 IRQ latency, 1-64 microframes (int)
            park=0 - park:park setting; 1-3 back-to-back async packets (uint)

    >>> processor - ACPI Processor Driver
            ignore_ppc=-1 - ignore_ppc:If the frequency of your machine gets wronglylimited by BIOS, this should help (int)
            ignore_tpc=0 - ignore_tpc:Disable broken BIOS _TPC throttling support (int)
            latency_factor=2 - latency_factor: (uint)

    >>> usb_storage - USB Mass Storage driver for Linux
            delay_use=1 - delay_use:seconds to delay before using a new device (uint)
            option_zero_cd=1 - option_zero_cd:ZeroCD mode (1=Force Modem (default), 2=Allow CD-Rom (uint)
            quirks= - quirks:supplemental list of device IDs and their quirks (string)
            swi_tru_install=1 - swi_tru_install:TRU-Install mode (1=Full Logic (def), 2=Force CD-Rom, 3=Force Modem) (uint)

    >>> video - ACPI Video Driver
            allow_duplicates=N - allow_duplicates: (bool)
            brightness_switch_enabled=Y - brightness_switch_enabled: (bool)
            use_bios_initial_backlight=Y - use_bios_initial_backlight: (bool)

See also
--------

-   Disable PC Speaker Beep

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernel_modules&oldid=252023"

Categories:

-   Kernel
-   Hardware detection and troubleshooting
-   Boot process
