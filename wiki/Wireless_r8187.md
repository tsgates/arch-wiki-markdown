Wireless r8187
==============

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:The kernel has rtl8187 and staging/r8187se now. The binary driver
this page discusses is from circa 2005 and the content is from 2006. If
there is someone still needing to use it, please remove the
Template:Deletion tag. The binary driver can be found at the linked page
by looking for a link similar to
ftp://WebUser:nQJ4P7b@207.232.93.28/cn/wlan/ .

Instalation
-----------

-   Download linux26x-8187(110).zip from
    http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=1&PFid=1&Level=6&Conn=5&DownTypeID=3&GetDown=false&Downloads=true#RTL8187L
-   Unpack it to folder rtl8187_linuxdrv_V1.1 (Keep the source file
    around; when you update kernels you may have to rebuild the file
    set)

-   Unpack the source code:

    $ tar -zxvf stack.tar.gz
    $ tar -zxvf drv.tar.gz

-   Build and insert modules:

    $ cd ieee80211/
    # make clean;make
    $ cd ..
    $ cd beta-8187/
    # make clean;make (still in root console)
    # insmod r8187.ko

lsmod shows that all of these modules have been installed, and the
adapter is functional (but LED is not).

-   Write a script "load":

    #!/bin/sh
    insmod ieee80211_crypt-rtl.ko
    insmod ieee80211_crypt_wep-rtl.ko
    insmod ieee80211_crypt_tkip-rtl.ko
    insmod ieee80211_crypt_ccmp-rtl.ko
    insmod ieee80211-rtl.ko
    insmod r8187.ko

-   Write a script "unload":

    #!/bin/sh
    rmmod r8187.ko
    rmmod ieee80211-rtl.ko
    rmmod ieee80211_crypt_ccmp-rtl.ko
    rmmod ieee80211_crypt_tkip-rtl.ko
    rmmod ieee80211_crypt_wep-rtl.ko
    rmmod ieee80211_crypt-rtl.ko

-   Put the ieeexxxxxxx.ko modules, the r8187.ko module and the scripts
    "load" and "unload" in a folder RTLmodules. To bring up the wireless
    interface wlan0, run the script "load", to bring it down, run
    "unload".

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wireless_r8187&oldid=253580"

Category:

-   Wireless Networking
