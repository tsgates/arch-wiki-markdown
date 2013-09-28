ASUS Eee PC 1018P
=================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Pm-utils
--------

To pm-suspend get working:

    echo 'SUSPEND_MODULES="xhci_hcd"' > /etc/pm/config.d/00sleep_module

    echo 'SUSPEND_MODULES="xhci_hcd"' > /etc/pm/config.d/unload_modules

Fn Keys
-------

After installing aur/acpi-eeepc-generic and

    cp /etc/acpi/eeepc/models/acpi-eeepc-1001P-events.conf /etc/acpi/eeepc/models/acpi-eeepc-1018P-events.conf

Some keys (like F1 - suspend) starts to working correctly. Suspend key
need to be configured to pm-suspend.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1018P&oldid=208391"

Category:

-   ASUS
