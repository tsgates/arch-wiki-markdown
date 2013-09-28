Pacman DB in tmpfs
==================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

    /etc/rc.d/pacdbtmp

    #!/bin/bash
    tmpfs_size=100m
    pacman_archive=/var/lib/pacman.tar.gz
    pacman_sync=var/lib/pacman/sync
    [ -d /$pacman_sync ] || mkdir /$pacman_sync
    mounted=$(grep -c /$pacman_sync /proc/mounts)
    case "$1" in
      stop)
        [ $mounted = 0 ] && exit 1
        umount /$pacman_sync
      ;;
      start)
        [ $mounted -gt 0 ] && exit 1
        creates=$(ls -1 /$pacman_sync)
        mount -t tmpfs tmpfs -o size=$tmpfs_size /$pacman_sync
        for create in $creates ; do
          mkdir -p /$pacman_sync/$create
          [ -f /$pacman_sync/../${create}.db.tar.gz ] && tar -C /$pacman_sync/$create/ -xzf /$pacman_sync/../${create}.db.tar.gz
        done
      ;;
      restart)
        $0 stop
        $0 start
      ;;
      *)
        echo "start or stop"
      ;;
    esac

Finally modify your daemons list.

    DAEMONS=(syslog-ng pacdbtmp...)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman_DB_in_tmpfs&oldid=214652"

Categories:

-   Scripts
-   Package management
