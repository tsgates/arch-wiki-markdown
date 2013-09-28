Pacbuilder
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Pacbuilder is a small but powerful script to automatically recompile the
whole system, repos or just a single package (with or without its
dependencies). This is quite useful once you have edited
/etc/makepkg.conf with some customized CFLAGS.

See Makepkg - Architecture, compile flags for more about specifying
CFLAGS.

To see actual CFLAGS and CXXFLAGS run:

    pacbuilder --gccinfo

  
 Most used command:

    pacbuilder --builddeps --keepdeps --verbose --noconfirm --install $packagename

or

    pacbuilder -Sbkvn $packagename

> Help

    $ pacbuilder -h
    ------------------------------- 
     PacBuilder, by Andrea Cimitan                                                                                    
    -------------------------------                                                                                   
                                                                                                                     
    A tool to massively recompile packages from sources                                                               
    It currently fetches both ABS and AUR                                                                             

    USAGE:
      pacbuilder [options] package|repository

    OPTIONS:
      General:
        --help                  print this help
        --clean                 remove previous log
        --gccinfo               print current compilation flags
        --nocolor               do not use any color           
        --notitle               do not print the title         
        --noresume              do not resume                  
      Install:                                                 
      (-S),    --install        build specified packages
      (-S) -b, --builddeps      build and install the dependencies
      (-S) -e, --edit           be verbose and edit PKGBUILD
      (-S) -f, --force          force install, overwrite conflicting files
      (-S) -k, --keepdeps       keep makedepends after install
      (-S) -s, --search <regex> search for packages matching <regex>
      (-S) -u, --sysupgrade     build the updated packages
      (-S) -v, --verbose        print makepkg output
      Additional parameters:
        -p, --pretend           print the final list of packages to be installed
        -n, --noconfirm         do not ask for any confirmation
        -m, --match <regex>     only install packages matching <regex>
        -d, --deplist           recursively list all dependencies first
            --export <dir>      copy packages into a dir after build
      Type:
        --world                 recompile both deps and explicit
        --explicit              recompile explicitely installed packages
        --devel                 recompile only installated devel packages
      Target repository:
        --core                  recompile packages in core
        --extra                 recompile packages in extra
        --testing               recompile packages in testing
        --community             recompile packages in community
        --aur                   recompile packages in aur

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacbuilder&oldid=206296"

Categories:

-   Package development
-   Package management
