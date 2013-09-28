init Rosetta
============

This article draws a parallel between the old SysVinit and the current
systemd initialization.

Keep in mind that you can always omit the .service and .target
extensions, especially if you're temporarily editing the kernel
parameters when bootloader menu shows up. Easier to remember, as well.

> Commands

  SysVinit                                 systemd                                               Information
  ---------------------------------------- ----------------------------------------------------- ------------------------------------------------
   rc.d {start | stop | restart} daemon     systemctl {start | stop | restart} daemon.service    Change service state.
   rc.d list                                systemctl list-unit-files --type=service             List Services.
   chkconfig daemon {on | off}              systemctl {enable | disable} daemon.service          Turn service on or off.
   chkconfig daemon --add                   systemctl daemon-reload                              Use when you create or modify configs/scripts.

> Targets table

  SysV Runlevel   systemd Target                                          Notes
  --------------- ------------------------------------------------------- ----------------------------------------------------------------------------------------------
  0               runlevel0.target, poweroff.target                       Halt the system.
  1, s, single    runlevel1.target, rescue.target                         Single user mode.
  2, 4            runlevel2.target, runlevel4.target, multi-user.target   User-defined/Site-specific runlevels. By default, identical to 3.
  3               runlevel3.target, multi-user.target                     Multi-user, non-graphical. Users can usually login via multiple consoles or via the network.
  5               runlevel5.target, graphical.target                      Multi-user, graphical. Usually has all the services of runlevel 3 plus a graphical login.
  6               runlevel6.target, reboot.target                         Reboot
  emergency       emergency.target                                        Emergency shell

Retrieved from
"https://wiki.archlinux.org/index.php?title=Init_Rosetta&oldid=235037"

Category:

-   Boot process
