Working with the serial console
===============================

Configure your Arch Linux machine so you can connect to it via the
serial console port (com port). This will enable you to administer the
machine even if it has no keyboard, mouse, monitor, or network attached
to it (a headless server).

As of Arch Linux 2007.x, installation of Arch Linux is possible via the
serial console as well.

A basic environment for this scenario is two machines connected using a
serial cable (9-pin connector cable). The administering machine can be
any Linux or Windows machine with a terminal emulator program (PuTTY or
Minicom, for example).

The configuration instructions below will enable GRUB menu selection,
boot messages, and terminal forwarding to the serial console.

Contents
--------

-   1 Configuration
    -   1.1 Configure console access on the target machine
        -   1.1.1 GRUB2 and systemd
            -   1.1.1.1 Without GRUB2, systemd only
        -   1.1.2 GRUB v1 and No systemd
-   2 Making Connections
    -   2.1 Connect using a terminal emulator program
        -   2.1.1 Minicom
        -   2.1.2 Screen
        -   2.1.3 Serialclient
        -   2.1.4 Windows Options
-   3 Installing Arch Linux using the serial console
-   4 Troubleshooting
    -   4.1 Ctrl-C and Minicom

Configuration
-------------

> Configure console access on the target machine

GRUB2 and systemd

If you configure the serial console in GRUB2 systemd will create a getty
listener on the same serial device as GRUB2 by default. So, this is the
only configuration needed for Arch running with systemd.   
  
 Edit /etc/default/grub   
  
 1. Edit the GRUB_CMDLINE_DEFAULT="" line to start the console on
/dev/ttyS0  
  GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,38400n8"   
  
 2. Add a serial console section  

 # Serial console GRUB_TERMINAL=serial GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"
  
  
 3. Rebuild the grub.cfg file  
  grub-mkconfig > /boot/grub/grub.cfg   
  
 Now you are done. After reboot getty will be listening on device
/dev/ttyS0 with settings 38400 8N1 and systemd will automatically start
a getty session to listen on the same device with the same settings.

Without GRUB2, systemd only

This step is not needed if you have configured GRUB2 to listen on the
serial interface. If you do not want GRUB2 to listen on the serial
device, but only want getty listening after boot then follow these
steps.   
  
 1. To start getty listening on /dev/ttyS0 use systemctl  
  systemctl start getty@ttyS0.service   
  
 You can check to see the speed getty is useing with systemctl, but
should be 38400 8N1  
  systemctl status serial-getty@ttyS0.service   
  
 2. To have getty listening on /dev/ttyS0 every boot create this symlink
 ln -s /usr/lib/systemd/system/serial-getty@.service   /etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service
  
  
 Now after reboot getty will be listening on device /dev/ttyS0 with
settings 38400 8N1

GRUB v1 and No systemd

1. Edit the GRUB config file:

    vi /boot/grub/menu.lst

Add these lines to the general area of the configuration:

 serial --unit=0 --speed=9600 terminal --timeout=5 serial console

Add the console parameters at the end of your current kernel line:

 console=tty0 console=ttyS0,9600

For example, the kernel line should look something like this after
modification:

 kernel /vmlinuz-linux root=/dev/md0 ro md=0,/dev/sda3,/dev/sdb3 vga=773 console=tty0 console=ttyS0,9600

Note:When the terminal --timeout=5 serial console line is added to your
menu.lst grub configuration, your boot sequence will now show a series
of "Press any key to continue" messages. If no key is pressed, the boot
menu will appear on whichever (serial or console) appears first in the
'terminal' configuration line. The lines will look like this upon boot:

 Press any key to continue. Press any key to continue. Press any key to continue. Press any key to continue. Press any key to continue. Press any key to continue. Press any key to continue.

2. Edit the inittab file:

    vi /etc/inittab

Add a new agetty line below the existing ones:

 c0:2345:respawn:/sbin/agetty 9600 ttyS0 linux

3. Edit the securetty file:

    vi /etc/securetty

Below the existing ttys, add an entry for the the serial console:

 ttyS0

4. Reboot the machine

Note:In all of the steps above, ttyS1 can also be used in case your
machine has more than one serial port.

Making Connections
------------------

> Connect using a terminal emulator program

Perform these steps on the machine used to connect the remote console.

Minicom

1. Install Minicom:

    pacman -S minicom

2. Start Minicom in setup mode:

    minicom -s

3. Using the textual navigation menu, change the serial port settings to
the following:

 Serial Device: /dev/ttyS0 Bps/Par/Bits: 9600 8N1

Press Enter to exit the menus (pressing Esc will not save changes).

4. Remove the modem Init and Reset strings:

Under the 'Modem and Dialing' menu, delete the Init and Reset strings.

5. Save the setup:

From the main menu, choose 'save setup as dfl'.

6. Exit Minicom:

From the main menu, choose 'Exit from Minicom'.

7. Connect to the target machine:

While the serial cable is connected to the target machine, start the
Minicom program:

    minicom

8. Exiting Minicom

To finish the session, press 'ctrl-A' and then 'X'.

Screen

Screen is able to connect to a serial port. It will connect to a
standard 9600 speed port without options.

    screen /dev/ttyS0

A different baud rate (e.g. 115200) may be specified on the commmand
line.

    screen /dev/ttyS0 115200

If needed, see the section "WINDOW TYPES" in the screen man page for
details on setting other connection parameters.

Serialclient

Serialclient[1] is a client for serial connection in command line in
your shell. Install it doing:

    pacman -S ruby
    gem install serialclient

Then, you can use like this:

    serialclient -p /dev/ttyS0

Windows Options

On Windows machines, connect to the serial port using programs like
PuTTY or Hyper Terminal.

Installing Arch Linux using the serial console
----------------------------------------------

1. Connect to the target machine using the method described above.

2. Boot the target machine using the Arch Linux installation CD.

3. When the bootloader appears, select "Boot Arch Linux (<arch>)" and
press tab to edit

4. Append console=ttyS0 and press enter

5. Systemd should now detect ttyS0 and spawn a serial getty on it,
allowing you to proceed as usual

Note:After setup is complete, the console settings will not be saved on
the target machine; in order to avoid having to connect a keyboard and
monitor, configure console access on the target machine before
rebooting.

Note:While a port speed of 9600 is used in all of the examples in this
document, working with higher values is recommended (List of available
speeds is displayed in Minicom by pressing 'Ctrl-A' and then 'P')

Troubleshooting
---------------

> Ctrl-C and Minicom

If you are having trouble sending a Control-C command through minicom
you need to switch off hardware flow control in the device settings
(minicom -s), which then enables the break.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Working_with_the_serial_console&oldid=301973"

Category:

-   Other hardware

-   This page was last modified on 25 February 2014, at 00:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
