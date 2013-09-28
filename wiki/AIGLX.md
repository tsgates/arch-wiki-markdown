AIGLX
=====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

AIGLX is a project that aims to enable GL-accelerated effects on a
standard desktop.

Arch Linux's Xorg package has AIGLX built-in and no configuration is
required.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Cards Supported                                                    |
| -   2 Cards In Testing                                                   |
| -   3 Cards Not Supported                                                |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Cards Supported
---------------

       * ATI: Radeon r100, r200, r300 generations (7000, 8000 models)
       * ATI: Radeon r400 and greater (>9550) through the r300_dri driver or ATI's proprietary driver,     version 7.10 (8.42.3) or later
       * ATI Radeon Xpress 200M. - with 8.3 or newer ati driver, works without problems at good performance
       * Intel: i810 through i965 (Intel Corporation Mobile 915GM/GMS/910GML - driver i915)

Cards In Testing
----------------

       * ATI: Radeon 9500 through X850 (r300 and r400 generations) - Open source drivers only.
       * ATI: R200 - Works slowly.
       * Savage: Any. - Works with slowdown, however, composite window managers cannot be started. 

Cards Not Supported
-------------------

       * ATI: Rage 128. - Driver locking issue.
       * ATI: Mach64. - No DRM support in Fedora, still insecure. The insecure version is available, see mach64
       * Matrox: MGA G200 to G550. - DRI locking. PCI cards probably have other issues as well.
       * Matrox: Millenium P650/P750 (undeclared 'GL_TEXTURE_RECTANGLE_NV' and 'GL_TEXTURE_RECTANGLE_ARB' in libGL.so)
       * 3dfx: Voodoo 1 and 2. - No DRI driver.
       * SiS: 661/741/760 PCI/AGP or 662/761Gx PCIE
       * Intel Corporation 82915G/GV/910GL (driver i915)
       * Via: unichrome 3D driver does not support AIGLX.

See also
--------

-   Composite -- A Xorg extension required by composite managers
-   Compiz -- The original composite/window manager from Novell
-   Xcompmgr -- A simple composite manager capable of drop shadows and
    primitive transparency
-   Cairo Composite Manager -- A versatile and extensible composite
    manager which uses cairo for rendering.
-   Wikipedia:Compositing window manager

Retrieved from
"https://wiki.archlinux.org/index.php?title=AIGLX&oldid=205504"

Categories:

-   X Server
-   Eye candy
