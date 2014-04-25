Motd
====

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Core        
                           utilities.               
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

motd (Message of the day). The contents of /etc/motd are displayed by
login(1) after a successful login but just before it executes the login
shell.

It is a good place to display your Terms of Service to remind users of
your local policies or anything you wish to tell them. A sample script
that can be used to create /etc/motd:

    #!/bin/bash
    #define the filename to use as output
    motd="/etc/motd"
    # Collect useful information about your system
    # $USER is automatically defined
    HOSTNAME=`uname -n`
    KERNEL=`uname -r`
    CPU=`uname -p`
    ARCH=`uname -m`
    # The different colours as variables
    W="\033[01;37m"
    B="\033[01;34m"
    R="\033[01;31m" 
    X="\033[00;37m"
    clear > $motd # to clear the screen when showing up
    echo -e "$R#=============================================================================#" >> $motd
    echo -e "	$W Welcome $B $USER $W to $B $HOSTNAME                " >> $motd
    echo -e "	$R ARCH   $W= $ARCH                                   " >> $motd
    echo -e "	$R KERNEL $W= $KERNEL                                 " >> $motd
    echo -e "	$R CPU    $W= $CPU                                    " >> $motd
    echo -e "$R#=============================================================================#" >> $motd
    echo -e "$X" >> $motd

Retrieved from
"https://wiki.archlinux.org/index.php?title=Motd&oldid=305344"

Category:

-   System administration

-   This page was last modified on 17 March 2014, at 16:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
