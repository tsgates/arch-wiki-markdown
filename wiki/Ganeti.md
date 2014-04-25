Ganeti
======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Described        
                           package ganeti is        
                           outdated, the            
                           #Installing From Source  
                           part should be merged    
                           into the PKGBUILD.       
                           Further, rc.conf is      
                           mentioned. (Discuss)     
  ------------------------ ------------------------ ------------------------

From Ganeti project page:

Ganeti is a cluster virtual server management software tool built on top
of existing virtualization technologies such as Xen or KVM and other
Open Source software.

Warning:This is a very rough draft. Following the directions may or may
not cause your entire server cluster to erupt into flames.

Contents
--------

-   1 Installing From Source
-   2 KVM
-   3 Xen
-   4 LXC

Installing From Source
----------------------

There is currently an AUR package, ganeti, that is incomplete and not
updated. For now, build from source.

Create the ganeti backing store. If you have pysical volumes to create
your backing on then this is pointless. Ganeti will complain if you give
it less than 20G.

    $ dd if=/dev/zero of=ganeti_backing_store.img bs=4k count=25000000

Prequisites to install with pacman:

    # pacman -S drbd iproute pyopenssl python-pyinotify pycurl ctypes socat python-paramiko haskell python-simplejson python-pyparsing python2-pyparsing python2-pyinotify start-stop-daemon

    $ wget 'http://ganeti.googlecode.com/files/ganeti-2.5.1.tar.gz'
    $ tar -xvzf ganeti-2.5.1.tar.gz.
    $ cd ganeti-2.5.1

On Arch the problem here is that we don't have the system python as
python3. Which sorta sucks for building this.

Most of ganeti will support

    $ PYTHON=python2.7 ./configure --localstatedir=/var --sysconfdir=/etc

however 'autotools/build-bash-completion' fails even this because it has
a '#!/usr/bin/python' shebang hardcoded. Fix this with a text editor,
changing it to '#!/usr/bin/python2.7'

Then, again

    $ PYTHON=python2.7 ./configure --localstatedir=/var --sysconfdir=/etc

This will actually succeed.

    $ make
    $ su
    # make install

Fix PYTHONPATH

    # ln -s /usr/local/lib/python2.7/site-packages/ganeti/ /usr/lib/python2.7/site-packages/ganeti

Fix shebangs

    # for i in `find /usr/local -mmin 8 -type f | xargs`; do head -n 1 $i | grep python && echo $i >> it; done
    # for i in `cat it`; do sed -i 's/#!\/usr\/bin\/python/#!\/usr\/bin\/python2.7/' $i;done

Note the use of -mmin 8 in the find above, that was specific to me, you
may need to adjust it depending on how smoothly this is going.

Create ganeti's needed dirs:

    # mkdir /etc/ganeti
    # mkdir -p /srv/ganeti{os,export}
    # mkdir -p /var/{log,lib}/ganeti

Pick a name for your cluster:

    # echo 192.168.0.199 mycluster.lan mycluster >> /etc/hosts

If this is your first interaction with ganeti, try not to recoil at the
use of /etc/hosts. Ganeti basically refuses to do anything without name
service records for everything. Try not to worry too much about this.
Also note that the name of the cluster is its own thing and can't be the
name of the root node, it must have a unique ip and fqdn.

KVM
---

Lets fire up some networking.

    # modprobe bridge

/etc/network/br1

    DESCRIPTION='A static ethernet connection for interface eth1'
    INTERFACE='br1'
    CONNECTION='bridge'
    BRIDGE_INTERFACES="eth1"
    IP='static'
    ADDR='192.168.0.1'
    NETMASK='255.255.255.0'
    BROADCAST='192.168.0.255'

/etc/rc.conf

    NETWORKS=(br1 br0)
    NETWORK_PERSIST="no"

netcfg br1

This creates a br1 interface and assigns it a static IP address. For
more sophisticated setups, see the netcfg article.

Lets get some disk backing: Make sure you created a
ganeti_backing_store.img

    # modprobe loop
    # losetup /dev/loop0 ganeti_backing_store.img
    # pvcreate /dev/loop0

You can ignore any 'file descriptor leak' errors here. That's a problem
with bash, not you, though it should get fixed.

    # vgcreate ganeti /dev/loop0

Load the necessary kernel modules, either for Intel processors

    # modprobe kvm
    # modprobe kvm-intel

or AMD processors

    # modprobe kvm
    # modprobe kvm-amd

At this point begins the period where you will attempt various
incantations beginning with gnt-cluster init, they will fail, and you
will have to start over.

The following I found useful.

    # rm -fr /var/{log,lib}/ganeti/*
    # rm -fr /srv/ganeti
    # pkill ganeti
    # pkill gnt
    # mkdir -p /srv/ganeti/{os,export}

Create your ganeti cluster:

    gnt-cluster init --nic-parameters=link=br1 --master-netdev=br1 --enabled-hypervisor=kvm --vg-name ganeti mycluster

Xen
---

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

LXC
---

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ganeti&oldid=269933"

Category:

-   Virtualization

-   This page was last modified on 5 August 2013, at 10:03.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
