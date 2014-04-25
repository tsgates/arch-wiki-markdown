Vagrant
=======

Related articles

-   VirtualBox
-   Libvirt
-   KVM

Vagrant is a tool for managing and configuring virtualised development
environments.

Vagrant has a concept of 'providers', which map to the virtualisation
engine and its API. The most popular and well-supported provider is
Virtualbox; plugins exist for libvirt, kvm, lxc, vmware and more.

Vagrant uses a mostly declarative Vagrantfile to define virtualised
machines. A single Vagrantfile can define multiple machines.

See the Wikipedia article on this subject for more information: Vagrant

Contents
--------

-   1 Installing Vagrant
-   2 Plugins
    -   2.1 vagrant-kvm
    -   2.2 vagrant-lxc

Installing Vagrant
==================

Install vagrant from the AUR.

Plugins
=======

Vagrant has a middleware architecture providing support for powerful
plugins.

Some popular Vagrant plugins are available from the aur, such as
vagrant-vbguest. Other plugins can be installed with Vagrant's built-in
plugin manager:

    $ vagrant plugin install vagrant-vbguest

vagrant-kvm
-----------

This plugin supports KVM as the virtualisation provider.

Vagrant installs a self-contained rainbow environment in /opt which
interacts with the system ruby in Arch in confusing ways. As of vagrant
1.4.3, this invocation will install vagrant-kvm successfully:

    $ CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib" vagrant plugin install vagrant-kvm

vagrant-lxc
-----------

First install lxc from the official repositories, then:

    $ vagrant plugin install vagrant-lxc

Next, configure lxc and some systemd unit files per this comment. The
plugin can now be used with a {ic|Vagrantfile}} like so:

    VAGRANTFILE_API_VERSION = "2"

    Vagrant.configure("2") do |config|

        config.vm.define "main" do |config|
            config.vm.box = 'http://bit.ly/vagrant-lxc-wheezy64-2013-10-23'

            config.vm.provider :lxc do |lxc|
                lxc.customize 'cgroup.memory.limit_in_bytes', '512M'
            end

            config.vm.provision :shell do |shell|
                shell.path = 'provision.sh'
            end
        end
    end

The provision.sh file should be a shell script beside the Vagrantfile.
Do whatever setup is appropriate; for example, to remove puppet, which
is packaged in the above box:

    rm /etc/apt/sources.list.d/puppetlabs.list
    apt-get purge -y puppet facter hiera puppet-common puppetlabs-release ruby-rgen

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vagrant&oldid=295136"

Category:

-   Virtualization

-   This page was last modified on 31 January 2014, at 12:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
