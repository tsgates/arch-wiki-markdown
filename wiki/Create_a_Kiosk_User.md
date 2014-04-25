Create a Kiosk User
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Sometimes it's nice to have a gmail user to give people without accounts
on your computer a quick way to access their Gmail account (this can be
easily modified to use Yahoo or any other service) this is easy as Linux
is so configurable.

    #!/bin/sh
    sudo useradd -p password gmail
    sudo cat /etc/shadow | sed "s|gmail:.*:\([0-9]*\):\([0-9]*\):\([0-9]*\):\([0-9]*\):::|gmail::\1:\2:\3:\4:::|" | sudo tee  /etc/shadow # Remove password from gmail user.
    sudo pacman -S ratpoison
    pacman -S uzbl-tabbed
    cd /home/gmail
    echo "exec ratpoison" > .xinitrc
    echo "exec uzbl-browser google.com/mail" > .ratpoisonrc
    mkdir -p .config/uzbl
    echo "set always_insert_mode = 1" > .config/uzbl/config

And that should be it, you can now login with your login manager as
gmail and go straight to your gmail.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Create_a_Kiosk_User&oldid=206641"

Category:

-   Security

-   This page was last modified on 13 June 2012, at 14:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
