Hwdetect
========

hwdetect is a hardware detection script primarily used to load or list
modules for use in rc.conf or mkinitcpio.conf. The script makes use of
information exported by the sysfs subsystem employed by the Linux
kernel.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Example                                                            |
| -   4 Tips                                                               |
+--------------------------------------------------------------------------+

Installation
------------

The hwdetect package is available from the official repositories.

Usage
-----

The latest usage information can be found here or by running
hwdetect --help.

Example
-------

You can use the following method to disable MOD_AUTOLOAD in rc.conf.
This should improve boot times, as time will not be spent discovering
modules.

    # hwdetect --modules

The command should output something similar to the following (of course,
output depends on the system):

    MODULES=(ac battery button processor thermal video cdrom ....) 

Copy this output to replace the MODULES section in /etc/rc.conf and
change MOD_AUTOLOAD from "yes" to "no". The system should now skip the
auto-load and boot faster.

Note:If any of the module names change (unlikely) or you install new
hardware on your computer, you will need to generate the list of modules
again and update MODULES.

Tips
----

To generated a list of modules currently not used, run:

    # hwdetect --modules-not-loaded

or use the following script:

    modules-not-loaded

    eval $(hwdetect --modules)
    for m in ${MODULES[*]}; do
        if ! grep -sq $(echo $m|tr - _) <(lsmod); then
            echo $m;
        fi
    done

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hwdetect&oldid=234771"

Category:

-   Hardware detection and troubleshooting
