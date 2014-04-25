Bioperl
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Bioperl is a set of scripts in Perl language to aid researchers in
Computational Biology and Bioinformatics.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Extras
-   4 Troubleshooting
-   5 More Resources

Installation
------------

Install bioperl from the AUR.

Configuration
-------------

If you installed from the AUR to the /usr folder (default), the path to
bioperl should be added to the @INC array of perl. This is easily done
editing the PERL5LIB variable in your .bashrc file, like this:

    nano ~/.bashrc

Then adding this line to the end of the file:

    export PERL5LIB=$PERL5LIB:/usr/share/perl5/site_perl/5.10.0

Note: Please take a look to the folder /usr/share/perl5/site_perl/ to
see if the version is the same, the folder 5.10.0 (or a new version)
should contain a folder named BIO. If nor 5.10.0 neither other version
is found, look for the Bio folder in vendor_perl or any other perl5
folder where the Bio folder may have been installed, add the path where
the Bio folder is to the bash file.

After saving the file, for the $PERL5LIB variable to be updated, bash
must be reloaded in terminal:

    bash

It is adviced to install extra modules from CPAN, to avoid having
dependencies errors.

-   Upgrade CPAN

    sudo perl -MCPAN -e shell
    install Bundle::CPAN
    q

-   Install/upgrade Module::Build, and make it your preferred installer

    sudo cpan
    install Module::Build
    o conf prefer_installer MB
    o conf commit
    q

Extras
------

The package Bioperl-run, which provides wrapper modules around many
common bioinformatics applications and tools, is not installed by
default.

    sudo cpan
    d /bioperl/

Which would return something like this:

    Distribution    BIRNEY/bioperl-1.2.2.tar.gz
    Distribution    BIRNEY/bioperl-1.2.3.tar.gz
    Distribution    BIRNEY/bioperl-1.2.tar.gz
    Distribution    BIRNEY/bioperl-1.4.tar.gz
    Distribution    BIRNEY/bioperl-db-0.1.tar.gz
    Distribution    BIRNEY/bioperl-ext-1.4.tar.gz
    Distribution    BIRNEY/bioperl-gui-0.7.tar.gz
    Distribution    BIRNEY/bioperl-run-1.4.tar.gz
    Distribution    BOZO/Fry-Lib-BioPerl-0.15.tar.gz
    Distribution    CJFIELDS/BioPerl-1.6.0.tar.gz
    Distribution    CJFIELDS/BioPerl-1.6.1.tar.gz
    Distribution    CJFIELDS/BioPerl-db-1.6.0.tar.gz
    Distribution    CJFIELDS/BioPerl-network-1.6.0.tar.gz
    Distribution    CJFIELDS/BioPerl-run-1.6.1.tar.gz
    Distribution    CRAFFI/Bundle-BioPerl-2.1.8.tar.gz
    15 items found

Then simply do (check the version compatibility):

    install CJFIELDS/BioPerl-run-1.6.1.tar.gz
    q

Troubleshooting
---------------

If you run into trouble while compiling your perl scripts, with an error
like "Can't locate (Name of the Module) in @INC", Install the missing
Modules like this:

    sudo cpan
    install Module::Name
    q

More Resources
--------------

http://www.bioperl.org/wiki/Installing_Bioperl_for_Unix

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bioperl&oldid=206594"

Category:

-   Mathematics and science

-   This page was last modified on 13 June 2012, at 13:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
