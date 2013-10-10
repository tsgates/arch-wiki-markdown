Linksys Wireless B
==================

  

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
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

Installing the Linksys Wireless "B" Version 4 NIC under Arch Linux
------------------------------------------------------------------

> pcmcia:

1.  install ndiswrapper, pacman -S ndiswrapper
2.  Download the Windows XP Drivers for pcmcia here: [1].
3.  unzip "winxp-8180(169).zip" (make sure you use the quotes so you
    won't get a token error.)
4.  type: ndiswrapper -i NET8180.INF
5.  type: ndiswrapper -l (it should then list the installed drivers)
6.  type: ndiswrapper -m (will save module information.)
7.  type: depmod -a
8.  modprobe ndiswrapper

  

-   Edit /etc/rc.conf
-   in the MODULES line, add ndiswrapper,

-   Follow the Wireless setup wiki for further information: [2]

  
 pci:

1.  Follow the pcmcia instructions with these exceptions for step 2 and
    3, because it uses a different chipset.
2.  Download and extract the windows driver from here [3]
3.  run ndiswrapper -i on all 3 .inf files

Retrieved from
"https://wiki.archlinux.org/index.php?title=Linksys_Wireless_B&oldid=238907"

Category:

-   Wireless Networking
