DXPC
====

Differential X Protocol Compressor

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Install                                                            |
| -   2 Desktop machine (machine which runs X server)                      |
| -   3 Remote machine (machine which runs X apps)                         |
| -   4 What now?                                                          |
+--------------------------------------------------------------------------+

Install
-------

    pacman -S dxpc

Desktop machine (machine which runs X server)
---------------------------------------------

Start dxpc server proxy

    dxpc -w

Remote machine (machine which runs X apps)
------------------------------------------

Login to remote machine with port 4000 tunnel

    ssh user@host -R 4000:127.0.0.1:4000

Start dxpc client proxy

    dxpc -w 127.0.0.1

Set up new DISPLAY variable

    export DISPLAY=:8.0

What now?
---------

Now you may run X apps and save traffic (from 3:1 to 6:1) and time.

By default dxpc transfers compressed traffic through port #4000. You may
change it with -p key.

By default dxps uses 8th display. You may change it with -d key.

If you remove -w key, then desktop dxpc will connect to remote dxpc. So
you should run remote dxpc first and change ssh tunnel.

For additional information see 'man 1 dxpc'.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DXPC&oldid=205832"

Category:

-   X Server
