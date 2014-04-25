Cgroups
=======

cgroups (aka control groups) is a Linux kernel feature to limit, police
and account the resource usage of certain processes (actually process
groups). Compared to other approaches like the 'nice' command or
/etc/security/limits.conf, cgroups are more flexible.

Control groups can be used in multiple ways:

-   create and manage them on the fly using tools like cgcreate, cgexec,
    cgclassify etc
-   the "rules engine daemon", to automatically move certain
    users/groups/commands to groups (/etc/cgrules.conf and
    /usr/lib/systemd/system/cgconfig.service)
-   through other software such as Linux Containers (LXC) virtualization

Unfortunately this feature is often underappreciated due to lack of easy
"how-to" style documentation. This is an attempt of fixing the
problem. :)

Contents
--------

-   1 Installing
-   2 Managing Resource Groups with Systemd
-   3 Simple usage
    -   3.1 Ad-hoc groups
    -   3.2 Persistent group configuration
-   4 Useful examples
    -   4.1 Matlab
-   5 Documentation

Installing
----------

First, install the utilities for managing cgroups; you need to install
the libcgroup package from the AUR.

Managing Resource Groups with Systemd
-------------------------------------

You can enable the cgconfig service with systemd.

    # systemctl enable cgconfig.service

This will gives you the capability to track more easily any error in
your cgconfig.conf file with this command:

    $ systemctl status cgconfig.service

Simple usage
------------

> Ad-hoc groups

One of the powers of cgroups is that you can create "ad-hoc" groups on
the fly. In fact, you can even grant the privileges to create custom
groups to regular users. Run this as root (replace $USER with your user
name and groupname with the name you want to give to the cgroup):

    sudo cgcreate -a $USER -g memory,cpu:groupname

That's it! Now all the tunables in the group groupname are writable by
your user:

    $ ls -l /sys/fs/cgroup/memory/groupname
    total 0
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 cgroup.event_control
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 cgroup.procs
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 cpu.rt_period_us
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 cpu.rt_runtime_us
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 cpu.shares
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 notify_on_release
    -rwxrwxr-x 1 user root 0 Sep 25 00:39 tasks

Cgroups are hierarchical, so you can create as many subgroups as you
like. Let's say that, as a normal user, you want to run a bash shell
under a new subgroup called 'foo':

    cgcreate -g memory,cpu:groupname/foo
    cgexec   -g memory,cpu:groupname/foo bash

There we go! Just to make sure:

    $ cat /proc/self/cgroup
    11:memory:/groupname/foo
    6:cpu:/groupname/foo

A new subdirectory was created for this group. To limit the memory usage
of all processes in this group to 10 MB, run the following:

    $ echo 10000000 > /sys/fs/cgroup/memory/groupname/foo/memory.limit_in_bytes

Note that the memory limit applies to RAM use only -- once tasks hit
this limit, they will begin to swap. But it won't affect the performance
of other processes significantly.

Similarly you can change the CPU priority ("shares") of this group. By
default all groups have 1024 shares. A group with 100 shares will get a
~10% portion of the CPU time:

    $ echo 100 > /sys/fs/cgroup/cpu/groupname/foo/cpu.shares

You can find more tunables or statistics by listing the cgroup
directory.

You can also change the cgroup of already running processes. To move all
'bash' commands to this group:

    $ pidof bash
    13244 13266
    $ cgclassify -g memory,cpu:groupname/foo `pidof bash`
    $ cat /proc/13244/cgroup
    11:memory:/groupname/foo
    6:cpu:/groupname/foo

> Persistent group configuration

Note:when using Systemd > = 205 to manage cgroups, you can ignore
enterly this file.

If you want your cgroups to be created at boot, you can define them in
/etc/cgconfig.conf instead. For example, the "groupname" has a
permission for $USER and users of group $GROUP to manage limits and add
tasks. A subgroup "groupname/foo" group definitions would look like
this.

    /etc/cgconfig.conf 

    group groupname {
      perm {
    # who can manage limits
        admin {
          uid = $USER;
          gid = $GROUP;
        }
    # who can add tasks to this group
        task {
          uid = $USER;
          gid = $GROUP;
        }
      }
    # create this group in cpu and memory controllers
      cpu { }
      memory { }
    }

    group groupname/foo {
      cpu {
        cpu.shares = 100;
      }
      memory {
        memory.limit_in_bytes = 10000000;
      }
    }

> Note:

-   Comments should begin at the start of a line! The # character for
    comments must appear as the first character of a line. Else,
    cgconfigparser will have problem parsing it but will only report
    cgroup change of group failed as the error, unless you started
    cgconfig with Systemd
-   The permissions section is optional.
-   The /sys/fs/cgroup/ hierarchy directory containing all controllers
    sub-directories is already created and mounted at boot as a virtual
    file system. This gives the ability to create a new group entry with
    the $CONTROLLER-NAME { } command. If for any reason you want to
    create and mount hierachies in another place, you will then need to
    write a second entry in /etc/cgconfig.conf following this way :

     mount {    
       cpuset = /your/path/groupname;
    }

This is equivalent to these shell commands:

     
    # mkdir /your/path/groupname
    # mount -t /your/path -o cpuset groupname /your/path/groupname

Useful examples
---------------

> Matlab

Matlab does not have any protection against taking all your machine's
memory or CPU. Launching a large calculation can thus trash your system.
Here's the what I have put in /etc/cgconfig.conf to protect from this
(replace $USER with your username):

    /etc/cgconfig.conf 

    # Prevent Matlab from taking all memory
    group matlab {
        perm {
            admin {
                uid = $USER;
            }
            task {
                uid = $USER;
            }
        }

        cpuset {
            cpuset.mems="0";
            cpuset.cpus="0-5";
        }
        memory {
    # 5 GiB limit
            memory.limit_in_bytes = 5368709120;
        }
    }

Note:Don't forget to change $USER to the actual username Matlab will be
run by!!!

This cgroup will bind Matlab to cores 0 to 5 (I have 8, so Matlab will
only see 6) and cap its memory usage to 5 GiB. The "cpu" resource
constrain can also be defined to prevent CPU usage, but I find the
"cpuset" constrain to be sufficient.

Launch matlab like this:

    $ cgexec -g memory,cpuset:matlab /opt/MATLAB/2012b/bin/matlab -desktop

Make sure to use the right path to the executable.

Documentation
-------------

-   For information on controllers and what certain switches and
    tunables mean, refer to kernel's Documentation/cgroup (or install
    linux-docs and see /usr/src/linux/Documentation/cgroup
-   A detailed and complete Resource Management Guide can be found in
    the fedora project documentation.

For commands and configuration files, see relevant man pages, e.g.
man cgcreate or man cgrules.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cgroups&oldid=296758"

Categories:

-   Kernel
-   Virtualization

-   This page was last modified on 10 February 2014, at 12:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
