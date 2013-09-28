Parallels
=========

This article is about running Arch as guest operation system on
Parallels.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Installation of Arch as guest.                                     |
| -   3 Configuring Xorg                                                   |
| -   4 Parallels Tools                                                    |
|     -   4.1 Overview                                                     |
|     -   4.2 Installation                                                 |
|     -   4.3 configuration                                                |
|     -   4.4 Using the Tools                                              |
|         -   4.4.1 Sharing Folders                                        |
|         -   4.4.2 Dynamic Display Resolution                             |
|                                                                          |
| -   5 Appendix A: Alternatives to Parallels                              |
+--------------------------------------------------------------------------+

Overview
--------

Parallels is a software, which allows you to setup virtual machines and
run different operation systems without need to reboot your computer. A
more complete description on virtualisation can be found on Wikipedia.
At the moment of writing Parallels is released in version 6. The current
kernel version is 2.6.36 and 2.6.37 is considered stable.

Installation of Arch as guest.
------------------------------

Parallels supports Linux guests out of the box. For Arch you can chose
"other linux - kernel 2.6". There is not much to say on installation -
the steps are the same, as if you would install Arch on a real machine.

Configuring Xorg
----------------

Follow the instructions at Xorg. The xf86-video-vesa video driver works
great with Xorg running inside Parallels:

    # pacman -S xf86-video-vesa

Parallels Tools
---------------

> Overview

To improve the interoperability between the host and the guest operation
systems, Parallels provides you a package with kernel modules and
userspace tools called "Parallels Tools". Here is the list of features.

> Installation

Choose "install Parallels Tools" from the "Virtual Machine" menu.
Parallels Tools are located on a cd-image, which was connected to you
virtual machine. You have to mount it first:

    # mount /dev/sr0 /mnt/cdrom

The installation-script expects to find your init-scripts in
/etc/init.d/. The installation will fail, if the directory is not
present. To fix it you either create /etc/init.d/ or define
def_sysconfdir environment variable by doing the following (thanks
AlandyS for this post in Parallels-forum):

    # export def_sysconfdir=/etc/rc.d

The installation-script expects to find /etc/X11/xorg.conf too. Your
xorg configuration will be fixed to work with Parallels Tools. The
installation will fail, if xorg.conf is not present. Create it:

    # touch /etc/X11/xorg.conf

After the installation you can move xorg.conf to /etc/X11/xorg.conf.d/
and call it something like 10-parallels.conf if you want. It is be
probably a more appropriate location, but you do not have to - it will
work as it is now too.

Then you can run the installer-script and follow the instructions:

    # cd /mnt/cdrom

    # ./install

At the moment of writing Paralles Tools fails to compile agains kernel
2.6.36 / 2.6.37 due to some changes in the kernel api. You will need to
patch Paralles Tools to fix the problem. Copy everything from /mnt/cdrom
to a writeable directory:

    $ cp -r /mnt/cdrom/* ~/parallels_tools/

extract the source code of the kernel modules:

    $ mkdir ~/kmods_src/

    $ cd ~/kmods_src/

    $ tar xzf ~/parallels_tools/kmods/prl_mod.tar.gz

save the following patch to a file named prl_tools-2.6.37.patch:

    diff -cr prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/inode.c prl_mod_patched/prl_fs/SharedFolders/Guest/Linux/prl_fs/inode.c
    *** prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/inode.c	2010-12-20 20:53:25.000000000 +0100
    --- prl_mod_patched/prl_fs/SharedFolders/Guest/Linux/prl_fs/inode.c	2011-01-09 00:35:59.084213064 +0100
    ***************
    *** 368,374 ****
      	init_buffer_descriptor(&bd, &pattr, PATTR_STRUCT_SIZE, 0, 0);
      	ret = host_request_attr(sb, p, buflen, &bd);
      	if (ret == 0)
    ! 		ret = inode_setattr(dentry->d_inode, attr);
      	dentry->d_time = 0;
      	PRLFS_STD_INODE_TAIL
      }
    --- 368,378 ----
      	init_buffer_descriptor(&bd, &pattr, PATTR_STRUCT_SIZE, 0, 0);
      	ret = host_request_attr(sb, p, buflen, &bd);
      	if (ret == 0)
    ! 	{
    ! 		setattr_copy(dentry->d_inode, attr);
    ! 		mark_inode_dirty(dentry->d_inode);
    ! 		ret = 0;
    ! 	}
      	dentry->d_time = 0;
      	PRLFS_STD_INODE_TAIL
      }
    diff -cr prl_mod/prl_tg/Toolgate/Guest/Linux/prl_tg/prltg.c prl_mod_patched/prl_tg/Toolgate/Guest/Linux/prl_tg/prltg.c
    *** prl_mod/prl_tg/Toolgate/Guest/Linux/prl_tg/prltg.c	2010-12-20 20:53:35.000000000 +0100
    --- prl_mod_patched/prl_tg/Toolgate/Guest/Linux/prl_tg/prltg.c	2011-01-09 00:22:17.200882662 +0100
    ***************
    *** 959,978 ****
      	goto out;
      }
      
    - #ifdef HAVE_UNLOCKED_IOCTL
      static long prl_vtg_unlocked_ioctl(struct file *filp,
      			unsigned int cmd, unsigned long arg)
      {
      	return prl_vtg_ioctl(NULL, filp, cmd, arg);
      }
    - #endif
      
      static struct file_operations prl_vtg_fops = {
      	.write		= prl_tg_write,
    ! 	.ioctl		= prl_vtg_ioctl,
    ! #ifdef HAVE_UNLOCKED_IOCTL
      	.unlocked_ioctl	= prl_vtg_unlocked_ioctl,
    - #endif
      	.open		= prl_vtg_open,
      	.release	= prl_vtg_release,
      };
    --- 959,974 ----
      	goto out;
      }
      
      static long prl_vtg_unlocked_ioctl(struct file *filp,
      			unsigned int cmd, unsigned long arg)
      {
      	return prl_vtg_ioctl(NULL, filp, cmd, arg);
      }
      
      static struct file_operations prl_vtg_fops = {
      	.write		= prl_tg_write,
    ! //	.ioctl		= prl_vtg_ioctl,
      	.unlocked_ioctl	= prl_vtg_unlocked_ioctl,
      	.open		= prl_vtg_open,
      	.release	= prl_vtg_release,
      };

Apply the patch to your copy of Parallels Tools:

    $ cd ~/kmods_src

    $ cat ~/prl_tools-2.6.37.patch 

Note: if you see the following output (bash: patch not found) you need
to install the patch tool first (# pacman -S patch)

If the soruce was patched successfully you should see following output:

    patching file prl_fs/SharedFolders/Guest/Linux/prl_fs/inode.c
    patching file prl_tg/Toolgate/Guest/Linux/prl_tg/prltg.c

create an archive with the patched version of Parallels Tools and
replace the original:

    $ cd ~/kmods_src

    $ tar czf ../prl_mod.tar.gz *

    $ rm ~/parallels_tools/kmods/prl_mod.tar.gz

    $ mv ../prl_mod.tar.gz ~/parallels_tools/kmods

After patching run the installation-script again:

    $ cd ~/parallels_tools/

    $ ./install

If using 2.6.39, try this patch instead (following the above
directions):

    diff -ur kmods_orig//prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c kmods//prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c
    --- kmods_orig//prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c	2011-05-26 10:17:49.000000000 -0700
    +++ kmods//prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c	2011-07-17 15:28:05.553103476 -0700
    @@ -241,11 +241,19 @@
     	return get_sb_nodev(fs_type, flags, data, prlfs_fill_super);
     }
     #else
    +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)
     int prlfs_get_sb(struct file_system_type *fs_type,
     	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
     {
     	return get_sb_nodev(fs_type, flags, data, prlfs_fill_super, mnt);
     }
    +#else
    +static struct dentry *prlfs_mount(struct file_system_type *fs_type,
    +	int flags, const char *dev_name, void *raw_data)
    +{
    +	return mount_nodev(fs_type, flags, raw_data, prlfs_fill_super);
    +}
    +#endif
     #endif
     #else
     static struct super_block *prlfs_read_super(struct super_block *sb,
    @@ -261,9 +269,14 @@
     	.owner		= THIS_MODULE,
     	.name		= "prl_fs",
     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
    +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)
     	.get_sb		= prlfs_get_sb,
     	.kill_sb	= kill_anon_super,
     #else
    +	.mount		= prlfs_mount,
    +	.kill_sb	= kill_anon_super,
    +#endif
    +#else
     	.read_super	= prlfs_read_super,
     #endif
     	/*  .fs_flags */
    diff -ur kmods_orig//prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c kmods//prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c
    --- kmods_orig//prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c	2011-05-26 10:17:58.000000000 -0700
    +++ kmods//prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.c	2011-07-17 15:54:10.729722326 -0700
    @@ -55,7 +55,11 @@
     	struct inode *inode;
     	int err;
     
    +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 39)
     	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
    +#else
    +	err = kern_path(path, LOOKUP_FOLLOW, &nd);
    +#endif
     	if (err)
     		return ERR_PTR(err);
     	inode = nd.path.dentry->d_inode;
    diff -ur kmods_orig//prl_pv/Paravirt/Guest/Linux/pv_main.c kmods//prl_pv/Paravirt/Guest/Linux/pv_main.c
    --- kmods_orig//prl_pv/Paravirt/Guest/Linux/pv_main.c	2011-05-26 11:06:56.000000000 -0700
    +++ kmods//prl_pv/Paravirt/Guest/Linux/pv_main.c	2011-07-17 16:05:17.233042837 -0700
    @@ -51,8 +51,10 @@
     	set_kset_name("prl_pv"),
     #endif
     #ifdef CONFIG_PM
    +#ifndef CONFIG_ARCH_NO_SYSDEV_OPS
     	.suspend = prl_pv_suspend,
     	.resume = prl_pv_resume,
    +#endif
     #endif /* CONFIG_PM */
     };

> configuration

Edit /etc/rc.conf and add to the MODULES=() array the following:

    MODULES=(... prl_fs prl_pv prl_fs_freeze prl_tg prl_eth ...)

> Using the Tools

Sharing Folders

you can specify which folders on your hosts system you would like to
share with your guests under "virtual machine > configuration >
sharing". Then you mount a shared folder like this:

    # mount -t prl_fs name_of_share /mnt/name_of_share

Dynamic Display Resolution

a very helpful tool is prlcc. It changes the resolution of your display
(in the guest operation system - not the host) automatically, when your
change the size of the window. If this tool is not running the content
of the window gets stretched or shrunken. prlcc usually gets started
automatically and runs in the background. If not, just run following:

    $ prlcc &

Appendix A: Alternatives to Parallels
-------------------------------------

Parallels is a popular virtualization solution for the mac platform, but
it is not the only one. There is a competitive product from VMware
called VMware Fusion and of course the free and awesome VirtualBox from
Oracle (former Sun Microsystems). For Windwos VMware provides a free
product called VMware Player, which lets you run (but not create, as far
as i know) virtual machines.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Parallels&oldid=206949"

Category:

-   Virtualization
