Shutdown Pressing Power Button
==============================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: should likely     
                           just be a redirect now   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

First of all, make sure that button module is loaded (check the output
of lsmod). If it is not, load it manually and set it to load at boot.

logind handles the event from pressing the power key, and the behaviour
can be configured in /etc/systemd/logind.conf. See
https://wiki.archlinux.org/index.php/Systemd#ACPI_power_management for
more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Shutdown_Pressing_Power_Button&oldid=233721"

Category:

-   Power management
