Nginx/Init script
=================

Go back to Nginx.

/etc/rc.d/nginx snippet. It must be owned by root with permissions 755.

    #!/bin/bash

    # general config

    NGINX_CONFIG="/etc/nginx/conf/nginx.conf"

    . /etc/conf.d/nginx
    . /etc/rc.conf
    . /etc/rc.d/functions

    function check_config {
      stat_busy "Checking configuration"
      /usr/sbin/nginx -t -q -c "$NGINX_CONFIG"
      if [ $? -ne 0 ]; then
        stat_die
      else
        stat_done
      fi
    }

    case "$1" in
      start)
        check_config
        $0 careless_start
        ;;
      careless_start)
        stat_busy "Starting Nginx"
        if [ -s /var/run/nginx.pid ]; then
          stat_fail
          # probably ;)
          stat_busy "Nginx is already running"
          stat_die
         fi
        /usr/sbin/nginx -c "$NGINX_CONFIG" &>/dev/null
        if [ $? -ne 0 ]; then
          stat_fail
        else
          add_daemon nginx
          stat_done
        fi
        ;;
      stop)
        stat_busy "Stopping Nginx"
        kill -QUIT `cat /var/run/nginx.pid` &>/dev/null
        if [ $? -ne 0 ]; then
          stat_fail
        else
          rm_daemon nginx
          stat_done
        fi
        ;;
      restart)
        check_config
        $0 stop
        sleep 1
        $0 careless_start
        ;;
      reload)
        check_config
        if [ -s /var/run/nginx.pid ]; then
          status "Reloading Nginx Configuration" kill -HUP `cat /var/run/nginx.pid`
        fi
        ;;
      check)
        check_config
        ;;
      *)
        echo "usage: $0 {start|stop|restart|reload|check|careless_start}"
    esac

/etc/conf.d/nginx snippet. It must be owned by root with permissions
755.

    NGINX_CONFIG=/etc/nginx/conf/nginx.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nginx/Init_script&oldid=197542"

Category:

-   Web Server

-   This page was last modified on 23 April 2012, at 15:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
