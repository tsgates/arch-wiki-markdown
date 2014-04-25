Oracle
======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Installation:    
                           Packages and AUR         
                           reference too old, Dutch 
                           version is up-to-date    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This document will help you install Oracle Database 11gR1 on Arch Linux.
If you only want to connect to Oracle databases running elsewhere, see
the instructions for installing the Oracle client.

By using the install method 2 you will be able to finalize the long
installation process with only a few steps.

Contents
--------

-   1 Install method 1 - manual
    -   1.1 Pre installation
    -   1.2 AUR helper
        -   1.2.1 Required packages for Oracle database installation
        -   1.2.2 Configuration
    -   1.3 Graphical installation
        -   1.3.1 Installing Oracle database software
    -   1.4 Oracle Enterprise Manager installation (optional)
-   2 Install method 2 - AUR
    -   2.1 Installation
-   3 Post installation
    -   3.1 Creating initial database
        -   3.1.1 Graphical
        -   3.1.2 Scripted
        -   3.1.3 Testing database
    -   3.2 Starting oracle during the boot
    -   3.3 Setting permissions for normal users
-   4 Transfer existing Oracle installation
-   5 Known issues
-   6 See also

Install method 1 - manual
-------------------------

This section will guide you through installing Oracle onto a fresh
installation of archlinux. This is a general approach that has been
tested with kernel 2.6.28.ARCH x86_64 and Oracle 11g R1 64-bit. This
should in principle work with other versions of Oracle.

> Pre installation

> AUR helper

To ease the installation process you may find useful to install an AUR
helper:

    # pacman -U ftp://ftp.berlios.de/pub/aurbuild/aurbuild-1.8.4-1-any.pkg.tar.gz

Required packages for Oracle database installation

Install packages unzip sudo base-devel icu gawk gdb libelf sysstat
libstdc++5.

Install a Java runtime environment, like jre7-openjdk and jdk7-openjdk.

From the AUR, install ksh (other implementations like these may work),
beecrypt, rpm and libaio.

Oracle database 32-bit requires unixodbc.

Optional lib32 packages on x86_64 are: lib32-libstdc++5 lib32-glibc
lib32-gcc-libs.

Oracle database require 32-bit libaio and unixodbc on x86_64 but is not
necessary under Arch linux.

Note:The following step is not required in newer Arch Linux installation
after the binary directories merge

Some prerequisite symbolic links for Oracle Universal Installer.

    # ln -s /usr/bin/rpm /bin/rpm
    # ln -s /usr/bin/ksh /bin/ksh
    # ln -s /bin/awk /usr/bin/awk
    # ln -s /bin/tr /usr/bin/tr
    # ln -s /usr/bin/basename /bin/basename

Arch x86_64:

    # ln -s /usr/lib /usr/lib64

Configuration

Create users and group for Oracle database:

    # groupadd oinstall
    # groupadd dba
    # useradd -m -g oinstall -G dba oracle

Set password for the user oracle:

    # passwd oracle

Optional: Add oracle to the sshd_config file.

    # pacman -S openssh

Add this line to /etc/ssh/sshd_config:

    AllowUsers oracle

Add oracle to /etc/sudoers. This will give oracle super user privilege.

    oracle    ALL=(ALL) ALL

Add these lines to /etc/sysctl.d/99-sysctl.conf (Review Oracle
documentation to adjust these settings).

    # oracle kernel settings
    fs.file-max = 6553600
    kernel.shmall = 2097152
    kernel.shmmax = 2147483648
    kernel.shmmni = 4096
    kernel.sem = 250 32000 100 128
    net.ipv4.ip_local_port_range = 1024 65535
    net.core.rmem_default = 4194304
    net.core.rmem_max = 4194304
    net.core.wmem_default = 262144
    net.core.wmem_max = 262144

Add these lines to /etc/security/limits.conf (Review Oracle
documentation to adjust these settings)

    # oracle settings
    oracle           soft    nproc   2047
    oracle           hard    nproc   16384
    oracle           soft    nofile  1024
    oracle           hard    nofile  65536

Optional: You may reboot now if you want the changes to take effect.

Create some directories for Oracle database. You can chose the directory
path. Here is an example.

    mkdir -p /oracle/inventory /oracle/recovery /oracle/product/db

Set permissions for the directories.

    chown -R oracle:dba /oracle
    chmod 777 /tmp

Create or update oracle bashrc /home/oracle/.bashrc. Here is an example
of the oracle user settings.

    export ORACLE_BASE=/oracle
    export ORACLE_HOME=/oracle/product/db
    export ORACLE_SID=xdb
    export ORACLE_INVENTORY=/oracle/inventory
    export ORACLE_BASE ORACLE_SID ORACLE_HOME
    export PATH=$ORACLE_HOME/bin:$PATH
    export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
    export EDITOR=nano
    export VISUAL=nano

> Graphical installation

Installing Oracle database software

Download the Oracle database from here:
http://www.oracle.com/technology/software/products/database/index.html

Unzip the Oracle database.

Arch i686:

    unzip linux_11gR1_database_1013.zip -d /media

Arch x86_64:

    unzip linux.x64_11gR1_database_1013.zip -d /media

Optional: Arch x86_64 (only required if the installer will not launch
automatically ... at the time of this writing there was an issue with
the packaged unzip in the 64-bit Oracle installer):

    cd /media/database/install
    mv unzip unzipx
    ln -s /usr/bin/unzip 

Change the permissions for the extracted Oracle database.

    chmod -R 777 /media/database
    chown -R oracle:oinstall /media/database

Enter the directory where you extracted the Oracle database.

In oder to run oracle installation script you need to export the X
display as a normal user:

    DISPLAY=:0.0; export DISPLAY; xhost +

Login as the user oracle and export the X display:

    su oracle
    DISPLAY=:0.0; export DISPLAY

Enter the database directory and run the Oracle Universal Installer as
the user oracle.

    cd /media/database
    ./runInstaller -ignoreSysPrereqs

During the Graphical installation:

1.  Click on "Next".
2.  Choose "Enterprise Edition" Installation Type and click on "Next"
3.  Oracle Base should be: /oracle. Don't change it, unless you know
    what you're doing.
    1.  Change the default "Name" to orarch or something else.
    2.  The predefined path in /etc/rc.d/oracledb is "db", ie:
        /oracle/product/db. If you want to use a different path you'll
        have to change /etc/rc.d/oracledb, so that the startup script
        can locate ORACLE_HOME directory.
    3.  After changing the defaults, click on "Next".

4.  Since Oracle database requires certain distro requirement, you'll
    have to manually check them and then click on "Next".
5.  Chose "Software Install Only" and click on "Next".
6.  There is only one DBA group for oracle database. Click on "Next".
7.  Install "Summary" shows what's going to be installed. Click on
    "Install".
8.  The installation will take some time, especially the "Linking" part.
    Be patient! If you get an error message ignore it by clicking on
    "Continue".
    1.  At the end of the installation you'll have to open another
        terminal, and execute /oracle/product/db/root.sh as root. Don't
        click on "OK" yet.
    2.  When running root.sh, you'll be offered to use /usr/local/bin as
        the full pathname. Press the "Enter" key here.
    3.  Now you can click on "OK"

9.  Installation is finished, click on "Exit" and "Yes", you really want
    to exit.

> Oracle Enterprise Manager installation (optional)

This section describes how to install the web based OEM available in
10g+.

Depending on your settings the OUI may have already installed this.

Login or su to oracle, then run the following commands (answering the
prompts approriately). This may take a while.

    cd ${ORACLE_HOME}/bin
    ./emca -repos create
    ./emca -config dbcontrol db

Test this out by navigating to the enterprise manager (adjust the
servername (localhost) apporpriately).

    https://localhost:1158/em/console

You can control OEM with the following commands.

    emctl status dbconsole
    emctl stop dbconsole
    emctl start dbconsole

Install method 2 - AUR
----------------------

> Installation

Note: This installation method creates a database automatically. The
Oracle database will therefore be ready to be used after the
installation.

Step 1. Download the Arch Linux package oracle from AUR. Download the
Oracle database 11gR1:
http://www.oracle.com/technology/software/products/database/index.html

Step 2. Extract the Arch Linux package into a directory. Copy the Oracle
database 11gR1 into that directory as well.

INFO: The default install configuration in  ee.rsp.patch is:

    ORACLE_BASE="/home/oracle/app/oracle"
    ORACLE_HOME="/home/oracle/app/oracle/product/11.1.0/orarch"
    ORACLE_HOME_NAME="orarch"
    s_globalDBName="archlinux"
    s_dbSid="archlinux"
    s_superAdminSamePasswd="orarchdbadmin"
    s_superAdminSamePasswdAgain="orarchdbadmin"

Optional: You can either change the default password now or later after
the installation. If you change the ee.rsp.patch file, you need to
update the md5sums in the PKGBUILD file. To obtain the md5sum, run
(makepkg -g) or:

    md5sum ee.rsp.patch 

Create the Oracle database package by using makepkg:

    makepkg -s

Step 3. Install the package that makepkg has created by using pacman.
You may get an error stating "/bin/ksh already exists", just remove that
file and pacman will continue.

Pacman will now install the Oracle database by executing Oracle's own
installation script(./runInstaller -silent -ignoreSysPrereqs).

The installation will take som time, please be patient. Do not exit
terminal during database installation, especially when the installation
script is executing configuration assistants:

    .... 
    Starting to execute configuration assistants
    Configuration assistant "Oracle Net Configuration Assistant" succeeded 
    ...

The installation script ends something like this:

    The following configuration scripts need to be executed as the "root" user.
    #!/bin/sh
    #Root script to run
    /home/oracle/oraInventory/orainstRoot.sh
    /home/oracle/app/oracle/product/11.1.0/orarch/root.sh
    To execute the configuration scripts:
       1. Open a terminal window
       2. Log in as "root"
       3. Run the scripts
       
    The installation of Oracle Database 11g was successful.
    Please check '/home/oracle/oraInventory/logs/silentInstall2009-03-03_07-24-10PM.log'
    for more details.

Step 4. Run these scripts as root:

    # cd /home/oracle/oraInventory
    # ./orainstRoot.sh
    # cd /home/oracle/app/oracle/product/11.1.0/orarch
    # ./root.sh

Step 5. The default user for the Oracle database is "oracle". Since the
password is not set for the user oracle, you need to run passwd as root:

    passwd oracle

Step 6. Login as the user oracle.

    su oracle

Create the file /home/oracle/.bashrc and add these lines to the .bashrc
file:

    export ORACLE_SID=archlinux
    export ORACLE_HOME=/home/oracle/app/oracle/product/11.1.0/orarch
    export PATH=$PATH:$ORACLE_HOME/bin

Step 7. If you haven't altered the  ee.rsp.patch file, you need to
change the administration password for SYS and SYSTEM.

Note: If the database isn't mounted or opened. Login as the user oracle
and try this first:

    su oracle

    sqlplus '/as sysdba'

    SQL> startup mount;
    SQL> alter database open; 

Changing the password for the SYSTEM user:

    sqlplus '/as sysdba'

    SQL> show user
    USER is "SYS"

    SQL> passw system
    Changing password for system
    New password:
    Retype new password:
    Password changed

    SQL> quit

Changing the password for the SYS user:

    sqlplus system/secretpassword

    SQL> show user;
    USER is "SYSTEM"

    SQL> passw sys
    Changing password for sys
    New password: 
    Retype new password: 
    Password changed

    SQL> quit

Post installation
-----------------

> Creating initial database

Graphical

You have only installed the Oracle database software. Now you need to
create a database. Login as the user oracle:

    su oracle

Export the ORACLE_HOME binary directory:

    export ORACLE_HOME=/oracle/product/db
    export PATH=$PATH:$ORACLE_HOME/bin

Run database installation script:

    dbca

During the graphical installation:

1.  Click on "Next".
2.  Check "Create a Database" and click on "Next".
3.  Check "General Purpose or Transaction Processing" and click on
    "Next".
4.  Chose a database name and SID. Example: Global Database Name:
    archlinux, SID: archlinux. And then click on "Next".
5.  Uncheck "Configure Enterprise Manager", leave it empty and click on
    "Next".
6.  Check "Use the Same Administrative Password for All Accounts", set
    password and click on "Next".
7.  Check "File System" and click on "Next".
8.  Check "Use Database File Locations from Template" and click on
    "Next".
9.  Uncheck "Specify Flash Recovery Area" and click on "Next".
10. No need for "Sample Schemas", click on "Next".
11. If you do not know what you're doing, check "Typical" and click on
    "Next"
12. Check "Keep the enhanced 11g default security settings" and click on
    "Next".
13. Uncheck "Enable automatic maintenance tasks" if you wish to do it by
    yourself and click on "Next".
14. View your filesystem layout and click on "Next".
15. "Create Database" is checked by default. Click on "Finish" to create
    database.
16. Summary of following operations to be performed, click on "OK".
17. When database creation is complete, click on "Exit".

Scripted

This section walks you through doing a scripted initial database
creation.

Note:The scripts assume they are the first database to be installed on
this system. If this is not the case review the xdb-create.sh script and
comment out the portions which deal with the *.ora files.

Download the following tar file with a set of scripted database
installation scripts.

    wget http://sites.google.com/site/mbasil77/Home/instanceCreateXdb.tgz

Extract the directory

    tar xzf instanceCreateXdb.tgz

Move into instanceCreateXdb directory

    cd instanceCreateXdb

File list

-   CreateDB.sql
-   CreateDBCatalog.sql
-   initxdb.dbs.ora
-   initxdb.ora
-   listener.ora
-   postDBCreation.sql
-   sqlnet.ora
-   sysObjects.sql
-   tnsnames.ora
-   xdb-create.sh
-   xdb-create.sql
-   xdb-secfix.sh

Script notes

-   the files assume a database sid of xdb
-   the files assume an oracle base of /oracle/product/db
-   review all memory and storage parameters against Oracle
    documentation

Setup filesystem (as root)

    ./xdb-create.sh

Install database from script (this will take a long time)

    su oracle
    sqlplus / as sysdba @/oracle/admin/xdb/scripts/xdb-create.sql

Testing database

Login as the user oracle and run export ORACLE_SID="yourSID" etc., ie:

    export ORACLE_SID=xdb
    export ORACLE_HOME=/oracle/product/db
    export PATH=$PATH:$ORACLE_HOME/bin

Running oraenv should confirm the exported configuration:

    oraenv

    ORACLE_SID = [xdb] ? 
    The Oracle base for ORACLE_HOME=/oracle/product/db 
    is /oracle

Check if the database is shutting down or starting:

    sqlplus '/as sysdba'

    SQL> shutdown immediate;
    Database closed.
    Database dismounted.
    ORACLE instance shut down.

    SQL> startup mount;

    ORACLE instance started.

    Total System Global Area  385003520 bytes
    Fixed Size		    1300100 bytes
    Variable Size		  234883452 bytes
    Database Buffers	  142606336 bytes
    Redo Buffers		    6213632 bytes
    Database mounted.
    Database opened.

Type "quit" when you want to leave SQL prompt:

    SQL> quit

> Starting oracle during the boot

If you want to start with your oracle SID, replace ":N" with ":Y" in
/etc/oratab:

    <your sid>:<oracle home>:N
    <your sid>:<oracle home>:Y

Example from Scripted database creation (/etc/oratab):

    xdb:/oracle/product/db:Y

To start the oracle database daemon during boot, add "oracledb" in your
/etc/rc.conf:

    DAEMONS=(oracledb syslog-ng dbus !network netfs crond ntpd alsa hal wicd fam)

Note: If the daemon doesn't start, please check that the ORACLE_HOME
path matches your current oracle directory in /etc/rc.d/oracledb:

    export ORACLE_HOME=/oracle/product/db

    $ pwd
    /oracle/product/db

Test starting the daemon as root:

    /etc/rc.d/oracledb start

    Starting Oracle: 
    LSNRCTL for Linux: Version 11.1.0.6.0 - Production on 27-FEB-2009 23:14:45
    ...
    The command completed successfully
    Processing Database instance "archlinux": log file 
    /oracle/product/db/startup.log
    OK

Now you'll login to your oracle database each time you reboot:

    su oracle
    export ORACLE_SID=xdb
    oraenv
    sqlplus '/as sysdba'

Install Method 2:

    su oracle
    export ORACLE_SID=archlinux
    oraenv
    sqlplus '/as sysdba'

> Setting permissions for normal users

Since there is only one user(oracle) that has access to the oracle
database, you need to add your normal user to the group "dba". In this
case "joe" is the normal user:

    # gpasswd -a joe dba

The group changes will take effect after you logout and login again. The
user oracle has the permissions to access the oracle home directory, ie
/home/oracle:

    drwx------ 6 oracle dba 4096 2009-02-27 23:27 oracle

You need to grant the group "dba" permission to execute the binary files
in the oracle home directory:

    chmod -R g+x /home/oracle

Now you'll be able to run the oracle database as the normal user.

Transfer existing Oracle installation
-------------------------------------

Moving or transferring Oracle can be quite useful in the following
conditions:

-   replacing hardware
-   setting up several dev machines
-   running lean system (no desktop manager, java, etc)

The installation of Oracle requires several packages. However, just
running an Oracle database is much simpler and has far fewer
requirements, as shown below.

In principle transferring Oracle should work across distros.
Transferring from RHEL/Centos 5.2 to ARCH 2009.02 has been tested
successfully.

To prep Oracle for a move shutdown database services

    dbstop ${ORACLE_HOME}
    lsnrctl stop

Optional: stop OEM if it is running

    emctl stop dbconsole

If you are running other Oracle daemons stop them as well

This section assumes the following conditions about the existing Oracle
installation:

-   oracle root is /oracle
-   oracle data is at /oracle/oradata/<sid>

Tar up entire Oracle installation and data.

    cd /
    tar czf oracle.tgz /oracle

Using ssh and sftp or your method of choice transfer oracle.tgz to the
root (/) of the target system.

Login to target system as root and unpack the tar

    cd /
    tar xzf oracle.tgz
    chmod 755 -R /oracle
    chown -R oracle:dba /oracle

Update the system:

    pacman -Syu python unzip sudo
    pacman -U ftp://ftp.berlios.de/pub/aurbuild/aurbuild-1.8.4-1-any.pkg.tar.gz

Install required package run Oracle database and required daemons

    aurbuild -s libaio
    pacman -S sysstat

Configure server for oracle

    Oracle#Configuration

Setup OEM (optional)

    Oracle#Oracle_Enterprise_Manager_installation_.28optional.29

Execute appropriate/desired post installation steps

    Oracle#Post_Installation

Known issues
------------

The Oracle Universal Installer (ie, in silent mode) seems create errors
when installing on other paths than "../app/oracle/..".

Two consistent errors using the current libraries will occur. The first
one can be ignored:

    INFO: / usr/lib64/libstdc + + so.5:. Undefined reference to `memcpy@GLIBC_2.14 '
    collect2: error: ld returned 1 exit status

Ignore this message by clicking the "Continue" button.
Unfortunately,this has the consequence of the Lexical Compiler not
working. The Lexical Compiler is used to generate the Chinese and
Japanese dictionaries.

  
 The second error needs to be fixed as it can cause the emconsole to
fail eventually. Fortunately, the fix is easy:

    su oracle
    cd $ORACLE_HOME/sysman/lib
    make -f ins_emagent.mk "agent"

The last gcc call fails, which is what is causing the error. We need to
add the -lnnz11 flag after the -lcore11 flag for this to make
successfully, therefore, enter the following into the terminal:

    gcc -o /oracle/product/db/sysman/lib/emdctl -L/oracle/product/db/lib/ -L/oracle/product/db/sysman/lib/  -L/oracle/product/db/lib/stubs/       `cat /oracle/product/db/lib/sysliblist` -Wl,-rpath,/oracle/product/db/lib -lm    `cat /oracle/product/db/lib/sysliblist` -ldl -lm   -L/oracle/product/db/lib /oracle/product/db/sysman/lib//s0nmectl.o -lnmectl -lclntsh -L/oracle/product/db/lib  -L/oracle/product/db/sysman/lib/ -lnmemso -lcore11 -lnnz11 -Wl,-rpath,/oracle/product/db/lib/:/oracle/product/db/sysman/lib/:/oracle/product/db/jdk/jre/lib/amd64/server:/oracle/product/db/jdk/jre/lib/amd64 -L/oracle/product/db/jdk/jre/lib/amd64/server -L/oracle/product/db/jdk/jre/lib/amd64 -z lazyload -ljava -ljvm -lverify -z nolazyload -Wl,-rpath,/oracle/product/db/lib/:/oracle/product/db/sysman/lib/:/oracle/product/db/jdk/jre/lib/amd64/server:/oracle/product/db/jdk/jre/lib/amd64 -Wl,--allow-shlib-undefined    `cat /oracle/product/db/lib/sysliblist` -ldl -lm

The make will succeed and you can now choose continue in the Oracle
installer.

See also
--------

Most of the steps are based on this oracle installation guide for ubuntu
users. This guide includes step by step graphical examples:
http://www.pythian.com/blogs/1355/installing-oracle-11gr1-on-ubuntu-810-intrepid-ibex

Retrieved from
"https://wiki.archlinux.org/index.php?title=Oracle&oldid=292168"

Category:

-   Database management systems

-   This page was last modified on 10 January 2014, at 00:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
