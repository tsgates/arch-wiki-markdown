Samba/Simple file sharing with KDE4
===================================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: The information  
                           presented here is        
                           outdated. It's better to 
                           follow the main Samba    
                           wiki article (Discuss)   
  ------------------------ ------------------------ ------------------------

If you want to easily share files in read only mode go ahead and read
this section, if you want to add write functionality too, you must read
the section with advanced configuration.

Note:Sadly, simple file sharing functionality is implemented using SUID
perl script, and as Archlinux does not support SUID scripts because of
security reasons (just like any other recent UNIX like system) nor it
has perl-suid package, we will have to get our hands dirty.

Work plan:

1.  install packages
2.  configure samba
3.  modify fileshareset scripts
4.  create C wrapper for fileshareset to work as a SUID binary
5.  configure KDE side of things
6.  share a folder

Packages we will need:

-   kdebase-dolphin this is the interface we will use to share folders
-   samba for the server that will share files
-   kdenetwork-filesharing for System Settings File Sharing part
-   kdebase-runtime basic KDE workspace (but if you're reading this,
    chances are you already have it installed)
-   kdelibs3 for fileshareset (not sure about it, but as of KDE4.4.0
    it's still a dependency)
-   gcc to compile SUID wrapper

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing requisites                                              |
| -   2 Configuring samba                                                  |
| -   3 Modifying fileshareset scripts                                     |
| -   4 Create C wrapper                                                   |
| -   5 Configure KDE                                                      |
| -   6 Share a folder                                                     |
+--------------------------------------------------------------------------+

> Installing requisites

Install all packages and their dependencies:

pacman -S kdebase-dolphin samba kdenetwork-filesharing kdebase-runtime kdelibs3 gcc

Log out and log in again (kdelibs3 are in non standard place and so the
PATH must be updated)

> Configuring samba

A basic config file works OK, though you'll need to create Samba users
(with pdbedit -a -u <user name> as root):

    smb.conf

    [global]
    workgroup=HOME
    server string = Samba Server
    log file = /var/log/samba/&m.log
    max log size = 50
    load printers = No
    dns proxy = No

    [homes]
    comment = Home Directories
    read only = No
    browsable = No
    browseable = No

Alternatively you can configure samba with security = share and add
guest account = <your user name> to get an anonymous Samba server

Remember to add samba to DAEMONS in /etc/rc.conf if you want it to start
at boot time.

> Modifying fileshareset scripts

    for directory in /opt/kde/bin/ /usr/lib/kde4/libexec; do
      cd $directory
      sed 's/\/init.d\//\/rc.d\//g' fileshareset > fileshareset.pl
      rm filesharelist
      ln -s fileshareset.pl filesharelist
    done

> Create C wrapper

Create such files in your home directory:

    kde4.c

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/types.h>
    #include <unistd.h>

    #define EXEC "/usr/lib/kde4/libexec/fileshareset.pl"

    int
    main(int argc, char** argv)
    {
      char **args;

      setegid(0);
      seteuid(0);
      setgid(0);
      setuid(0);

      args = calloc(argc+1, sizeof(char**));
      if (args == 0)
        exit(1);

      for (int i=0; i < argc; i++)
      {
        args[i] = calloc(1,strlen(argv[i]));
        if(args[i] == 0)
          exit(1);
        strcpy(args[i], argv[i]);
      }
      return execv(EXEC, args);
    }

    kde3.c

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/types.h>
    #include <unistd.h>

    #define EXEC "/opt/kde/bin/fileshareset.pl"

    int
    main(int argc, char** argv)
    {
      char **args;

      setegid(0);
      seteuid(0);
      setgid(0);
      setuid(0);

      args = calloc(argc+1, sizeof(char**));
      if (args == 0)
        exit(1);

      for (int i=0; i < argc; i++)
      {
        args[i] = calloc(1,strlen(argv[i]));
        if(args[i] == 0)
          exit(1);
        strcpy(args[i], argv[i]);
      }
      return execv(EXEC, args);
    }

compile them using gcc kde4.c -std=c99 -o kde4 and
gcc kde3.c -std=c99 -o kde3. Copy them to system folders:

    $ copying wrappers

    cp kde3 /opt/kde/bin/fileshareset
    chown root:root /opt/kde/bin/fileshareset
    chmod u+s /opt/kde/bin/fileshareset
    cp kde4 /usr/lib/kde4/libexec/fileshareset
    chown root:root /usr/lib/kde4/libexec/fileshareset
    chmod u+s /usr/lib/kde4/libexec/fileshareset

> Configure KDE

Right click any folder in your home directory and select Properties. Go
to Share tab and click 'Configure File Sharing...', you'll be asked for
root password. (alternatively run kcmshell4 fileshare as root)

In the dialog you need to select checkbox near "Enable Local Network
File Sharing". Check radiobutton besides 'Advanced sharing', unselect
NFS sharing, check 'Simple sharing' again.

Click 'Allowed Users' and select the second option -- 'Only users of a
certain group are allowed to share folders'. Click 'Choose group...'.
Create new group, call it samba-share, do not check any checkboxes in
the dialog, click OK. In the new window add yourself to the group and
all the other users you may want. Click OK.

Click OK in the main dialog.

Log out, log back in.

> Share a folder

When the file sharing is configured you will see a new radio button on
the Share tab -- Shared and Not shared. Change position to Shared, click
OK. On the shared folder should appear now a small globe to indicate
that it is shared.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba/Simple_file_sharing_with_KDE4&oldid=200775"

Category:

-   Networking
