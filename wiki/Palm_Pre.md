Palm Pre
========

  ------------------------ ------------------------ ------------------------
  [Tango-preferences-deskt This article or section  [Tango-preferences-deskt
  op-locale.png]           needs to be translated.  op-locale.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Il Palm Pre è uno smartphone prodotto da Palm Inc. dal 2009 in poi,
avente sistema operativo basato su Linux chiamato webOS. Questa pagina
vuole aiutare i possessori di questo smartphone ad integrarlo al meglio
col proprio sistema Arch.

Installazione
=============

Quasi la maggioranza delle applicazioni lato desktop per gestire il Palm
Pre sono scritte in Java, di conseguenza necessitiamo di quest'ultimo.
Installiamo la versione open source chiamata OpenJDK (da root):

    pacman -S openjdk6

Fatto ciò, è importante installare l'SDK distribuito da Palm per
assicurarci la possibilità di ripristinare il sistema operativo del
nostro device in caso di necessità. Visto che è disponibile solamente
pacchettizzato in .deb, su AUR. C'è una correzione da fare al PKGBUILD
visto che quest'ultimo vuole installare una versione di VirtualBox
troppo vecchia e non disponibile su AUR, oltre che la Java virtual
machine distribuita da Oracle. Ecco il PKGBUILD corretto:

    # Contributor: Ryan Corder <ryanc@greengrey.org>

    pkgname=palm-sdk
    pkgver=1.4.5
    pkgrel=1
    pkgdesc="Unofficial package of Palm webOS SDK"
    url="http://developer.palm.com/index.php"
    arch=('i686' 'x86_64')
    license=("unknown")
    depends=('virtualbox_bin' 'palm-novacom=1.0.56') 
    source=("http://cdn.downloads.palm.com/sdkdownloads/1.4.5.465/sdkBinaries/palm-sdk_1.4.5-svn307799-sdk1457-pho465_i386.deb")
    noextract=()
    install=('palm-sdk.install')
    md5sums=('dc85db1897d0aa31e4c50130184ac508')

    build() {
        cd $startdir/src
        
        ar x $startdir/palm-sdk_1.4.5-svn307799-sdk1457-pho465_i386.deb || return 1
        mkdir data || return 1

        tar zxvf $startdir/src/data.tar.gz -C $startdir/pkg || return 1

        rm -rf $startdir/pkg/usr/local || return 1
        rm -rf $startdir/pkg/usr/share || return 1

        mkdir $startdir/pkg/usr/bin || return 1
        
        ln -s /opt/PalmSDK/Current/bin/palm-emulator $startdir/pkg/usr/bin/palm-emulator || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-generator $startdir/pkg/usr/bin/palm-generator || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-help $startdir/pkg/usr/bin/palm-help || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-inspector $startdir/pkg/usr/bin/palminspector || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-install $startdir/pkg/usr/bin/palm-install || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-launch $startdir/pkg/usr/bin/palm-launch || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-log $startdir/pkg/usr/bin/palm-log || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-package $startdir/pkg/usr/bin/palm-package || return 1
        ln -s /opt/PalmSDK/Current/bin/palm-worm $startdir/pkg/usr/bin/palm-worm || return 1    
    }

Questo invece il file palm-sdk.install:

    # $Id: $
    #
    # Description: post-install script for palm-sdk
    # Contributor: Ryan Corder <ryanc@greengrey.org>
    #

     # arg 1:new package version
    post_install() {
        echo
        echo "The following entires will likely be required for you to add to"
        echo "your /etc/hosts file:"
        echo
        echo "# Added for palm-sdk"
        echo "127.0.0.1   qemu"
        echo "# Added for palmtools"
        echo "127.0.0.1   device"
        echo
        echo "Additionally, you should have this entry in your /etc/hosts file anyway:"
        echo
        echo "127.0.0.1   localhost"
        echo
    }

    post_upgrade() {
        post_install $1
    }

    op=$1
    shift

    $op $*

Inserite questi due file in una stessa cartella, spostatevi in essa ed
eseguite:

    makepkg

Finita l'operazione, installate i file tar.pkg.xz con il comando (da
root):

    pacman -U

In ordine, installate prima VirtualBox, poi il Palm SDK. Fatto ciò,
siete pronti anche allo sviluppo di applicazioni per webOS. Se avreste
bisogno di un IDE, questo link contiene tutto il necessario per
sviluppare con Eclipse

Configurazione
==============

Alcune applicazioni, come webOS Doctor, necessitano del daemon novacomd
avviato in background. Per automatizzare ciò, bisogna aggiungere

    novacomd

allo spazio DAEMONS nel file

    /etc/rc.conf

Casomai voleste avviarlo al momento, basta eseguire (con i permessi di
root):

    /etc/rc.d/novacomd start

Per stopparlo:

    /etc/rc.d/novacomd stop

Tips & Tricks
=============

Per eseguire un file .jar, è necessario passare a java l'opzione -jar:

    java -jar filejava

Retrieved from
"https://wiki.archlinux.org/index.php?title=Palm_Pre&oldid=206911"

Category:

-   Mobile devices
