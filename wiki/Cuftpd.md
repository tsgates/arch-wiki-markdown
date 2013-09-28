Cuftpd
======

Summary

This article discusses the installation and configuration of the cuftpd
FTP daemon on Arch Linux systems.

Related

vsftpd

Proftpd

glFtpd

This article describes the installation of the cuftpd FTP daemon on Arch
Linux.

cuftpd is an ftp-server written in Java

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Preparation                                                  |
|     -   1.2 Building                                                     |
|         -   1.2.1 Copying                                                |
|                                                                          |
|     -   1.3 Preparing userdb                                             |
|     -   1.4 Generation keystore                                          |
|     -   1.5 Start server                                                 |
+--------------------------------------------------------------------------+

Installation
------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: TO DO (Discuss)  
  ------------------------ ------------------------ ------------------------

> Preparation

Install the requirements from the Official Repositories:

    $ pacman -S xinetd zip unzip openssl inetutils mercurial

Install from Java JDK, JRE and Maven2 from Arch User Repository:

-   JDK https://aur.archlinux.org/packages.php?ID=51906
-   JRE https://aur.archlinux.org/packages.php?ID=51908
-   Maven2 https://aur.archlinux.org/packages.php?ID=44684

Add a user for cuftpd

    useradd cuftpd

Change to the new user

    su cuftpd

Make necessary directories

    mkdir src ftpd

> Building

Enter src and download sources by following commnads

    cd src

    hg clone https://bitbucket.org/jevring/cunet
    hg clone https://bitbucket.org/jevring/cuftp
    hg clone https://bitbucket.org/jevring/cuftpd
    hg clone https://bitbucket.org/jevring/cunet
    hg clone https://bitbucket.org/jevring/cutools

Build all sources Build all dependencies in the following order using
the following commands.

1.  cutools
2.  cunet
3.  cuftp
4.  cuftpd
5.  OPTIONAL: cubnc (recommended, you wouldnt be here if you didnt want
    multisite, so compile it!)

Or you can use

    cd cutools && mvn clean install && cd ../cunet && mvn clean install && cd ../cuftp && mvn clean install && cd ../cuftpd && mvn clean install && cd ..

Copying

Copy files from target subdirectory

    cp -r cuftpd/data ~/ftpd/
    cp cuftpd/target/*.jar ~/ftpd/lib/

Make directories

    mkdir ~/ftpd/data/logs
    mkdir ~/ftpd/site

> Preparing userdb

Edit cuftpd.xml and select local user database Example

    <user>
     <authentication>
      <type>1</type>......

> Generation keystore

Create a self-signed server and a self-signed client key each in its own
keystore. When you promt for password enter "client". When you choose
another password dont forget enter it into cuftpd.xml

    cd ~/ftpd/data
    keytool -genkey -v -keyalg RSA -keystore server.keystore -dname "CN=Server, OU=Bar, O=Foo, L=Some, ST=Where, C=UN"
    keytool -genkey -v -keyalg RSA -keystore client.keystore -dname "CN=Client, OU=Bar, O=Foo, L=Some, ST=Where, C=UN"

> Start server

Run server as standalone for debugging

    cd ~/ftpd && java -jar lib/cuftpd-1.5-SNAPSHOT.jar

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: make rc. script  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cuftpd&oldid=244391"

Category:

-   File Transfer Protocol
