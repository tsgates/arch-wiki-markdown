OpenNebula
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

"OpenNebula is the industry standard for on-premise IaaS cloud
computing, offering the most feature-rich, flexible solution for the
comprehensive management of virtualized data centers to enable private,
public and hybrid (cloudbursting) clouds. OpenNebula interoperability
makes cloud an evolution by leveraging existing IT infrastructure,
protecting your investments, and avoiding vendor lock-in."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Configuration specific to QEMU-KVM                           |
|     -   2.2 Configuration specific to Xen                                |
|     -   2.3 Configuration specific to VMware                             |
|                                                                          |
| -   3 Troubleshooting                                                    |
| -   4 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Install the opennebula package from the AUR. For those interested in
running the latest bleeding edge version of OpenNebula, install the
opennebula-unstable package, also in the AUR.

Configuration
-------------

OpenNebula supports multiple hypervisors (QEMU-KVM, Xen, VMware) which
means that the configuration of your OpenNebula deployment is dependent
on which hypervisor technology you plan on using, but because OpenNebula
uses libvirt for managing virtual machines (VMs) some of the OpenNebula
configuration is hypervisor agnostic. The hypervisor agnostic
configuration will be in this section and the hypervisor dependent
configuration will be in the appropriate sub-sections.

See also: libvirt

> Configuration specific to QEMU-KVM

To be added later

See also: QEMU and KVM

> Configuration specific to Xen

TODO

See also: Xen

> Configuration specific to VMware

TODO

See also: VMware

Troubleshooting
---------------

TODO

Resources
---------

-   OpenNebula's Official Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenNebula&oldid=207221"

Category:

-   Virtualization
