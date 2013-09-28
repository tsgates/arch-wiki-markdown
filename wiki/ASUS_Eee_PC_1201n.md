ASUS Eee PC 1201n
=================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Asus Eee PC 
                           1201NL.                  
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page contains instructions, tips, pointers, and links for
installing and configuring Arch Linux on the ASUS EEE 1201n PC.

Aside from incompatability with cpufrequtils, the eeepc 1201NL is very
similar to this model, and most of the tips on that page apply to this
model as well.

Installing Wireless
-------------------

The default eee 1201n carries a Realtek 8191 Wireless card, despite what
lspci reports that the computer has a Realtek 8171 (rev 10). The
wireless driver is included in linux 3 kernel and should work out of the
box.

cpufrequtils
------------

The Intel Atom 330 does not support cpufrequtils in any reasonable way,
so it is not recommended that you use cpufrequtils. You can disable it
in /etc/laptop-mode/conf.d/cpufreq.conf:

    CONTROL_CPU_FREQUENCY=0

Because the Atom uses so little power anyway, controlling the FSB using
the "SuperHybrid Engine" should provide significant gain in battery life
without the need for CPU scaling.

  

Hardware Output
---------------

    $ lspci
    00:00.0 Host bridge: nVidia Corporation MCP79 Host Bridge (rev b1)
    00:00.1 RAM memory: nVidia Corporation MCP79 Memory Controller (rev b1)
    00:03.0 ISA bridge: nVidia Corporation MCP79 LPC Bridge (rev b3)
    00:03.1 RAM memory: nVidia Corporation MCP79 Memory Controller (rev b1)
    00:03.2 SMBus: nVidia Corporation MCP79 SMBus (rev b1)
    00:03.3 RAM memory: nVidia Corporation MCP79 Memory Controller (rev b1)
    00:03.5 Co-processor: nVidia Corporation MCP79 Co-processor (rev b1)
    00:04.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1 Controller (rev b1)
    00:04.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0 Controller (rev b1)
    00:06.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1 Controller (rev b1)
    00:06.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0 Controller (rev b1)
    00:08.0 Audio device: nVidia Corporation MCP79 High Definition Audio (rev b1)
    00:09.0 PCI bridge: nVidia Corporation MCP79 PCI Bridge (rev b1)
    00:0b.0 IDE interface: nVidia Corporation MCP79 SATA Controller (rev b1)
    00:10.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:16.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    00:18.0 PCI bridge: nVidia Corporation MCP79 PCI Express Bridge (rev b1)
    05:00.0 VGA compatible controller: nVidia Corporation ION VGA [GeForce 9400M] (rev b1)
    07:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvA Wireless LAN Controller (rev 10)
    09:00.0 Ethernet controller: Atheros Communications AR8132 Fast Ethernet (rev c0)

    $ lsusb
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 002: ID 13d3:5126 IMC Networks 
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1201n&oldid=208393"

Category:

-   ASUS
