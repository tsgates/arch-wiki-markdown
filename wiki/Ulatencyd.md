Ulatencyd
=========

Ulatency is a daemon that controls how the Linux kernel will spend it's
resources on the running processes. It uses dynamic cgroups to give the
kernel hints and limitations on processes.

It strongly supports the lua scripting language for writing rules and
the scheduler code.

Installation
------------

Kernel options requires:

    PROC_EVENTS=y
    CONFIG_CGROUPS=y
    CONFIG_CGROUP_FREEZER=y
    CONFIG_CGROUP_DEVICE=y
    CONFIG_CGROUP_MEM_RES_CTLR=y
    CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
    CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
    CONFIG_CGROUP_SCHED=y
    CONFIG_FAIR_GROUP_SCHED=y
    CONFIG_RT_GROUP_SCHED=y
    CONFIG_BLK_CGROUP=y
    CONFIG_CFQ_GROUP_IOSCHED=y

Install ulatencyd from the AUR or the ArchAudio/testing repository.

You may wish to get the latest fixes and rules from Git with
ulatencyd-git.

To start ulatencyd:

    # systemctl start ulatencyd.service

If you want ulatencyd start on boot, enable the service file as follows:

    # systemctl enable ulatencyd.service

To verify that it works:

    $  ulatency tree

     /sys/fs/cgroup/cpu
     └─┬»cpu«
       ├ 2 kthreadd
       ├─┬»s_ul«
       │ └ 4975 ulatencyd
       ├─┬»sys_bg«
       │ └ 1928 cron
       ├─┬»sys_idle«
       │ └ 3036 preload
       ...

Configuration
-------------

Some settings are adjustable in /etc/ulatencyd/ulatencyd.conf and the
cgroups that will be used can be changed in /etc/ulatencyd/cgroups.conf

Ulatencyd by default changes the io scheduler for all devices to cfq, to
disable this behavior (for if you configure your schedulers yourself),
simply edit /etc/ulatencyd/rules/io.lua and comment out the lines:

       if self.first_run == true then
         self:set_scheduler(dev, ulatency.get_config("io", "scheduler") or "cfq")
       end

See also
--------

-   Home page
-   FAQ
-   [HOWTO]Writing Rules

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ulatencyd&oldid=250650"

Category:

-   Kernel

-   This page was last modified on 14 March 2013, at 20:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
