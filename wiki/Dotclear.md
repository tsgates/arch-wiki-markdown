Dotclear
========

  

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Before You Install                                                 |
| -   3 Installation                                                       |
|     -   3.1 Step 1: Check PHP Configuration                              |
|     -   3.2 Step 2: Prepare MySQL Database                               |
|     -   3.3 Step 3 : Install dotclear                                    |
+--------------------------------------------------------------------------+

Introduction
============

This document describes how to set up the dotclear open source blogging
engine on an Arch Linux system.

Before You Install
==================

Note: This howto assumes you have a LAMP already setup and ready to go.
If you haven't set one up yet, see LAMP.

Installation
============

Step 1: Check PHP Configuration
-------------------------------

    # vim /etc/php/php.ini

Goto:

    ; available extensions

and enable, if not already enabled:

    extension=gd.so
    extension=gettext.so
    extension=iconv.so
    extension=mysql.so

Step 2: Prepare MySQL Database
------------------------------

You need to create a dotclear database for the blog to write stuff to.
One can choose dotclear2 for the db name, dotclear for the username, and
dotclearpass for the password. Assuming you've already accessed your
mysql install and set a root password:

    $  mysql -u root -p
    mysql> CREATE DATABASE dotclear2;
    mysql> GRANT ALL PRIVILEGES ON dotclear2.* TO "dotclear2"@"localhost" IDENTIFIED BY "dotclearpass";
    mysql> FLUSH PRIVILEGES;
    mysql> QUIT;

Step 3 : Install dotclear
-------------------------

Package is in AUR : https://aur.archlinux.org/packages.php?ID=31467

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dotclear&oldid=197520"

Category:

-   Web Server
