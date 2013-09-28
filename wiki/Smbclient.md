Smbclient
=========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

smbclient is an FTP-like client to access SMB/CIFS resources on servers.
See also: Samba

Installation
------------

smbclient can be installed with:

    # pacman -S smbclient

Essential commands
------------------

To display public shares on the server:

    $ smbclient -L <hostname> -U%

To connect to a share:

    $ smbclient //<hostname>/<share> -U<username>%<password>

Commonly used commands
----------------------

  -------------------------------- -------------------------------------------------------------------------------------------------------------------
  help [command] or ? [command]    show all available commands or give help about a specific command
  put <local name> [remote name]   upload a file
  get <remote name> [local name]   download a file
  ls [mask]                        list current directory content
  cd [directory]                   change current directory; without the argument print working directory
  lcd <directory>                  change local working directory
  mget <mask>                      download all files matching mask
  mput <mask>                      upload all files matching mask
  recurse                          enable recursive directory download/upload with mget/mput commands
  prompt                           toggle prompting on every single file or directory when using mget/mput commands. By default prompting is enabled
   !<local command>                execute a local command and capture output
  -------------------------------- -------------------------------------------------------------------------------------------------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Smbclient&oldid=218051"

Category:

-   Networking
