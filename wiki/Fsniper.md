Fsniper
=======

Fsniper is a directory monitor that can be used to execute predefined
actions on files that enter the monitored directory. This can, for
example, be used to monitor your downloads folder and sort downloaded
files automatically into your file system.

Unlike cron jobs or bash scripts, fsniper uses inotify to monitor file
changes. This enable it to react immediately and efficiently to changes
of the file system.

Installation
------------

Fsniper is available from the AUR.

Configuration
-------------

Fsniper comes with a self-explanatory example.conf found in
/usr/share/sniper/ that can be copied to ~/.config/fsniper/config for
modification and personalisation.

     watch {
       # watch the ~/drop directory for new files
       ~/drop {
           # matches any mimetype beginning with image/
           image/* {
               # %% is replaced with the filename of the new file
               handler = echo found an image: %%
           }
           # matches any file ending with .extension
           *.extension {
               # the filename is added to the end of the handler line if %% is not present
               handler = echo glob handler 1: 
               # the second handler will be run if the first exits with a return code of 1
               handler = echo glob handler 2: %%
           }
           # run handlers on files that match this regex
           /.*regex.*/ {
               handler = echo regex handler
           }
           # generic handler to catch files that nothing else did
           * {
               handler = mv %% ~/downloads/
           }
       }
     }

Once configured, fsniper can be started by typing

     $ fsniper --daemon

Daemonizing
-----------

Fsniper can also be started automatically at boot time as an rc.d daemon
by placing the following script as /etc/rc.d/fsniper:

(Replace <your-user-name> with your user name(s))

     daemon_name=fsniper
     . /etc/rc.conf
     . /etc/rc.d/functions
     USERS=( '<your-user-name>' )
     for USER in ${USERS[@]}
     do
     	PID=$(pidof -o %PPID /usr/bin/fsniper)
     	case "$1" in
     	  start)
     		  stat_busy "Starting $daemon_name"
     		  [ -z "$PID" ] && su -c "/usr/bin/fsniper --daemon" $USER
     		  if [ $? -gt 0 ]; then
     			  stat_fail
     		  else
     			  add_daemon fsniper
     			  stat_done
     		  fi
     		  ;;
     	  stop)
     		  stat_busy "Stopping $daemon_name"
     		  [ ! -z "$PID" ] && kill $PID > /dev/null
     		  if [ $? -gt 0 ]; then
     			  stat_fail
     		  else
     			  rm_daemon fsniper
     			  stat_done
     		  fi
     		  ;;
     	  restart)
     		  $0 stop
     		  sleep 1
     		  $0 start
     		  ;;
     	  *)
       echo "usage: $0 {start|stop|restart}"
     esac
     done
     exit 0

The daemon can then be started by typing

     # rc.d start fsniper

or by placing fsniper in the daemons section of your /etc/rc.conf.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fsniper&oldid=246778"

Category:

-   File systems
