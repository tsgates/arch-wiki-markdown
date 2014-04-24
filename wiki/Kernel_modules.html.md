Kernel modules
==============

Related articles

-   Boot Debugging
-   Kernels
-   Kernel parameters

Kernel modules are pieces of code that can be loaded and unloaded into
the kernel upon demand. They extend the functionality of the kernel
without the need to reboot the system.

Contents
--------

-   1 Overview
-   2 Obtaining information
-   3 Configuration
    -   3.1 Loading
    -   3.2 Setting module options
        -   3.2.1 Using files in /etc/modprobe.d/
        -   3.2.2 Using kernel command line
    -   3.3 Aliasing
    -   3.4 Blacklisting
        -   3.4.1 Using files in /etc/modprobe.d/
        -   3.4.2 Using kernel command line
-   4 Manual module handling
-   5 Tips and tricks
    -   5.1 Bash function to list module parameters
-   6 See also

Overview
--------

To create a kernel module, you can read The Linux Kernel Module
Programming Guide. A module can be configured as built-in or loadable.
To dynamically load or remove a module, it has to be configured as a
loadable module in the kernel configuration (the line related to the
module will therefore display the letter M).

Modules are stored in /usr/lib/modules/kernel_release. You can use the
command uname -r to get your current kernel release version.

Note:Module names often use underscores (_) or dashes (-); however,
those symbols are interchangeable, both when using the modprobe command
and in configuration files in /etc/modprobe.d/.

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

Configuration
-------------

Today, all necessary module loading is handled automatically by udev, so
if you do not want or need to use any out-of-tree kernel modules, there
is no need to put modules that should be loaded at boot in any
configuration file. However, there are cases where you might want to
load an extra module during the boot process, or blacklist another one
for your computer to function properly.

> Loading

Extra kernel modules to be loaded during boot are configured as a static
list in files under /etc/modules-load.d/. Each configuration file is
named in the style of /etc/modules-load.d/<program>.conf. Configuration
files simply contain a list of kernel module names to load, separated by
newlines. Empty lines and lines whose first non-whitespace character is
# or ; are ignored.

    /etc/modules-load.d/virtio-net.conf

    # Load virtio-net.ko at boot
    virtio-net

See modules-load.d(5) for more details.

> Setting module options

To pass a parameter to a kernel module, you can use a modprobe
configuration file or use the kernel command line.

Using files in /etc/modprobe.d/

Files in /etc/modprobe.d/ directory can be used to pass module settings
to udev, which will use modprobe to manage the loading of the modules
during system boot. Configuration files in this directory can have any
name, given that they end with the .conf extension. The syntax is:

    /etc/modprobe.d/myfilename.conf

    options modname parametername=parametervalue

For example:

    /etc/modprobe.d/thinkfan.conf

    # On ThinkPads, this lets the 'thinkfan' daemon control fan speed
    options thinkpad_acpi fan_control=1

Note:If any of the affected modules is loaded from the initramfs, then
you will need to add the appropriate .conf file to FILES in
/etc/mkinitcpio.conf or use the modconf hook, so that it will be
included in the initramfs.

Using kernel command line

If the module is built into the kernel, you can also pass options to the
module using the kernel command line. For all common bootloaders, the
following syntax is correct:

    modname.parametername=parametercontents

For example:

    thinkpad_acpi.fan_control=1

Simply add this to your bootloader's kernel-line, as described in Kernel
Parameters.

> Aliasing

Aliases are alternate names for a module. For example:
alias my-mod really_long_modulename means you can use modprobe my-mod
instead of modprobe really_long_modulename. You can also use shell-style
wildcards, so alias my-mod* really_long_modulename means that
modprobe my-mod-something has the same effect. Create an alias:

    /etc/modprobe.d/myalias.conf

    alias mymod really_long_module_name

Some modules have aliases which are used to automatically load them when
they are needed by an application. Disabling these aliases can prevent
automatic loading but will still allow the modules to be manually
loaded.

    /etc/modprobe.d/modprobe.conf

    # Prevent Bluetooth autoload
    alias net-pf-31 off

> Blacklisting

Blacklisting, in the context of kernel modules, is a mechanism to
prevent the kernel module from loading. This could be useful if, for
example, the associated hardware is not needed, or if loading that
module causes problems: for instance there may be two kernel modules
that try to control the same piece of hardware, and loading them
together would result in a conflict.

Some modules are loaded as part of the initramfs. mkinitcpio -M will
print out all automatically detected modules: to prevent the initramfs
from loading some of those modules, blacklist them in
/etc/modprobe.d/modprobe.conf. Running mkinitcpio -v will list all
modules pulled in by the various hooks (e.g. filesystems hook, block
hook, etc.). Remember to add that .conf file to the FILES section in
/etc/mkinitcpio.conf, if you have not done so already, and rebuild the
initramfs once you have blacklisted the modules, and reboot afterwards.

Using files in /etc/modprobe.d/

Create a .conf file inside /etc/modprobe.d/ and append a line for each
module you want to blacklist, using the blacklist keyword. If for
example you want to prevent the pcspkr module from loading:

    /etc/modprobe.d/nobeep.conf

    # Do not load the 'pcspkr' module on boot.
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

Using kernel command line

Tip:This can be very useful if a broken module makes it impossible to
boot your system.

You can also blacklist modules from the bootloader.

Simply add modprobe.blacklist=modname1,modname2,modname3 to your
bootloader's kernel line, as described in Kernel parameters.

Note:When you are blacklisting more than one module, note that they are
separated by commas only. Spaces or anything else might presumably break
the syntax.

Manual module handling
----------------------

Kernel modules are handled by tools provided by kmod package. You can
use these tools manually.

To load a module:

    # modprobe module_name

To unload a module:

    # modprobe -r module_name

Or, alternatively:

    # rmmod module_name

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

  
 The following is a variation of the previous function that includes a
full description for each parameter. The output is formatted a little
differently and uses more colors.

    function show_mod_parameter_info ()
    {
      if tty -s <&1
      then
        green="\e[1;32m"
        yellow="\e[1;33m"
        cyan="\e[1;36m"
        reset="\e[0m"
      else
        green=
        yellow=
        cyan=
        reset=
      fi
      newline="
    "

      while read mod
      do
        md=/sys/module/$mod/parameters
        [[ ! -d $md ]] && continue
        d="$(modinfo -d $mod 2>/dev/null | tr "\n" "\t")"
        echo -en "$green$mod$reset"
        [[ ${#d} -gt 0 ]] && echo -n " - $d"
        echo
        pnames=()
        pdescs=()
        pvals=()
        pdesc=
        add_desc=false
        while IFS="$newline" read p
        do
          if [[ $p =~ ^[[:space:]] ]]
          then
            pdesc+="$newline    $p"
          else
            $add_desc && pdescs+=("$pdesc")
            pname="${p%%:*}"
            pnames+=("$pname")
            pdesc=("    ${p#*:}")
            pvals+=("$(cat $md/$pname 2>/dev/null)")
          fi
          add_desc=true
        done < <(modinfo -p $mod 2>/dev/null)
        $add_desc && pdescs+=("$pdesc")
        for ((i=0; i<${#pnames[@]}; i++))
        do
          printf "  $cyan%s$reset = $yellow%s$reset\n%s\n" \
            ${pnames[i]} \
            "${pvals[i]}" \
            "${pdescs[i]}"
        done
        echo

      done < <(cut -d' ' -f1 /proc/modules | sort)
    }

See also
--------

-   modprobe man page
-   Disable PC Speaker Beep

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernel_modules&oldid=296272"

Categories:

-   Kernel
-   Hardware detection and troubleshooting
-   Boot process

-   This page was last modified on 5 February 2014, at 08:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
