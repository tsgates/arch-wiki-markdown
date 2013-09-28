Puppet
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: This wiki entry   
                           is a work-in-progress.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

From Puppet web site:

Puppet is IT automation software that helps system administrators manage
infrastructure throughout its lifecycle, from provisioning and
configuration to patch management and compliance. Using Puppet, you can
easily automate repetitive tasks, quickly deploy critical applications,
and proactively manage change, scaling from 10s of servers to 1000s,
on-premise or in the cloud.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Facter                                                       |
|         -   2.1.1 Ruby-Facter 1.7.0                                      |
|                                                                          |
|     -   2.2 Packages                                                     |
|     -   2.3 Services                                                     |
|         -   2.3.1 Puppet 3.2.0rc1                                        |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
============

Puppet packages are available in AUR. Install either puppet or
puppet-git. The maintainer of the puppet AUR packages is not interested
in shipping patches to minimize work as well as avoid confusion as to
where bugs should go. So I will collect my patches here.

Configuration
=============

Puppet's main configuration file is puppet.conf which is located at
/etc/puppet/puppet.conf. You have 3 options to place settings depending
if it is a master/agent  
 [main]  
 [agent]  
 [master]  

Bare minimum of settings are:

-   server: The hostname of the puppet server. Default = puppet
-   report: Most users should set this to true.
-   pluginsync: Most users should set this to true.
-   certname: The certified name of the machine (unique identifier)
    default = fqdn

Puppet will look for node configuration in
/etc/puppet/manifests/site.pp.

After starting puppet by daemon/cron/standalone, it will generate
certificates in /etc/puppet/ssl/ directory.

On the puppet master you need to accept this certificate:
sudo puppet cert sign <name>.

Facter
------

Facter is a package that gathers facts about the system it runs on. Use
with puppet facts find facter.

Facter requires both ifconfig as well as ip to gather network related
facts.

> Ruby-Facter 1.7.0

With facter 1.7.0 the new ifconfig in arch will give proper output to IP
adresses,   
but netmask/mtu are still a problem.

Netmask has been adressed on github version of facter.

Packages
--------

"Pacman" is supported by puppet. Installing packages works out of the
box with puppet 3.1.0 and the git packages.

Services
--------

> Puppet 3.2.0rc1

Has been released and has been uploaded to aur. The diff below needs to
be changed accordingly.

Puppet has trouble with systemd on arch linux. This diff fixes it:

    --- puppet-3.1.0-orig/lib/puppet/provider/service/systemd.rb    2013-02-25 08:49:29.000000000 +0100
    +++ puppet-3.1.0/lib/puppet/provider/service/systemd.rb 2013-02-26 16:59:36.828276309 +0100
    @@ -3,9 +3,10 @@
     Puppet::Type.type(:service).provide :systemd, :parent => :base do
       desc "Manages `systemd` services using `/bin/systemctl`."
     
    -  commands :systemctl => "/bin/systemctl"
    +  commands :systemctl => "/usr/bin/systemctl"
      
       #defaultfor :osfamily => [:redhat, :suse]
    +  defaultfor :osfamily => [:archlinux]
     
       def self.instances
         i = []

Apply in /usr/lib/ruby/gems/1.9.1/gems.

When pupet 3.2.0 is release this won't be needed anymore patch has been
sent upstream.

If you want to enable the "storeconfig" option in
/etc/puppet/puppet.conf you will also need this patch:

    diff -urN puppet-3.1.1-orig/lib/puppet/rails/resource.rb puppet-3.1.1/lib/puppet/rails/resource.rb
    --- puppet-3.1.1-orig/lib/puppet/rails/resource.rb      2013-03-13 20:53:21.766846140 +0100
    +++ puppet-3.1.1/lib/puppet/rails/resource.rb   2013-03-13 21:01:07.337490296 +0100
    @@ -84,7 +86,11 @@
       end
     
       def [](param)
    -    super || parameter(param)
    +    if param == 'id'
    +      super
    +    else
    +      super || parameter(param)
    +    end
       end
     
       # Make sure this resource is equivalent to the provided Parser resource.

Apply in the same place.

Before you apply above patch read this:using_stored_configuration

See also
========

-   Puppet Dashboard - Software based on or using puppet in this wiki.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Puppet&oldid=255425"

Category:

-   System administration
