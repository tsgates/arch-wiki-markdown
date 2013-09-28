Execute on USB insert
=====================

Suppose you want to execute a certain program on the insertion of a USB
dongle. Personally, I added this feature because I was getting
frustrated with the computer locking up and all keyboard and mouse input
was lost (The sysrq keys were not working).

There is an added security feature so that only dongles with the correct
key can run the program.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Setting up a USB dongle                                            |
| -   3 Security                                                           |
| -   4 exdongle script                                                    |
| -   5 Disable Trackpad on Mouse Connection                               |
| -   6 Notes                                                              |
+--------------------------------------------------------------------------+

Installation
------------

Put a copy of the exdongle script (given below) in your path.

Add the following line to your udev USB mount rule (Modify to fit your
configuration):

     ACTION=="add", RUN+="/usr/bin/exdongle run /media/%k-%E{dir_name}"

Run the configuration option, for example

     exdongle conf -k "$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM" -p "-10" -s "on"

This sets the configuration to a random key value (only programs with
the correct keys can be run on the computer), and the runtime priority
to -10.

Setting up a USB dongle
-----------------------

First, write a script that you want to run when the dongle is inserted.

For example:

    test.sh

    #!/bin/sh

    DISPLAY=:0 xterm

Now run the new option:

     exdongle new <Dongle mount point> test.sh

Now, whenever you insert the dongle, a root shell will be opened under
the X server running on display :0. This may be useful for some
administrative purposes.

Security
--------

There may be security issues with this, and it is probably best used
only on a personal computer.

exdongle script
---------------

    /usr/bin/exdongle

    #!/bin/sh

    # exdongle mkexdongle

    ###############################################################################

    CONFFILE="/etc/exdongle.conf"

    ###############################################################################

    function usage() {

      echo ""
      echo "USAGE: $0 new <DIR> <PROG>"
      echo "       $0 del <DIR>"
      echo "       $0 conf [-k KEY] [-p PRIORITY] [-s SWITCH]"
      echo "       $0 run <DIR>"
      echo ""
      echo "  new:"
      echo "    DIR <S>:    The directory on the dongle to execute"
      echo "    SCRIPT <S>: The script to run on dongle"
      echo ""
      echo "  del:"
      echo "    DIR [S]: The directory on the dongle to execute"
      echo ""
      echo "  conf:"
      echo "    -k <S>: specify key"
      echo "    -p <N>: priority to run script at"
      echo "    -s <on|off>: Activate or deactivate exdongle"
      echo ""
      echo "  run:"
      echo "    DIR <S>: Directory to find script in"
      echo ""

      exit 0

    }

    ###############################################################################

    function new() {

      if [ ! "$#" -eq 3 ]; then
        usage $@;
        exit 1;
      fi

      DIR="$2"
      PROG="$3"
      PLOC="$DIR/.$(hostname).$key"

      rm "$PLOC" &> /dev/null
      cp "$PROG" "$PLOC"

      exit 0

    }

    ###############################################################################

    function del() {

      DIR="$2"
      PLOC="$DIR/.$(hostname).$key"

      if [ -e "$PLOC" ]; then
        rm -f "$PLOC"
      fi

      exit 0

    }

    ###############################################################################

    function conf() {

      shift
      while getopts "k:p:s:" optname; do
        case "$optname" in
          k)
            key="$OPTARG"
            ;;
          p)
            priority="$OPTARG"
            ;;
          s)
            if [ "$OPTARG" = "on" ] || [ "$OPTARG" = "off" ]; then
              switch="$OPTARG"
            fi
            ;;
        esac
      done

      echo "# exdongle configuration file" > "$CONFFILE"
      echo "key=\"$key\"" >> "$CONFFILE"
      echo "priority=\"$priority\"" >> "$CONFFILE"
      echo "switch=\"$switch\"" >> "$CONFFILE"

      chmod 0600 "$CONFFILE"

      exit 0

    }

    ###############################################################################

    function run() {

      if [ ! "$switch" = "on" ]; then
        exit 0
      fi

      if [ ! "$#" -eq 2 ]; then
        usage $@
        exit 1
      fi

      DIR="$2"
      PLOC="$DIR/.$(hostname).$key"
      ELOC="/tmp/.exdongle.prog"

      if [ ! -e "$PLOC" ]; then
        echo "No executable file found!" 1>&2
        exit 0
      fi

      rm -f "$ELOC"
      cp "$PLOC" "$ELOC"
      chmod 0500 "$ELOC"
      nice -n "$priority" $ELOC
      rm -f "$ELOC"
      exit 0

    }

    ###############################################################################

    if [ ! "$UID" == "0" ]; then
      echo "You must be root to perform this operation" 1>&2
      exit 1
    fi

    if [ -e "$CONFFILE" ]; then
      . "$CONFFILE"
    fi

    case "$1" in
      new)
        new "$@"
        ;;
      del)
        del "$@"
        ;;
      conf)
        conf "$@" 
        ;;
      run)
        run "$@"
        ;;
      *)
        usage "$@"
        ;;
    esac

    exit 0

Disable Trackpad on Mouse Connection
------------------------------------

Adapted from Howto Forge.

Notes
-----

Some notes:

-   The programs/scripts used should be self contained, the only file
    treated is the one passed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Execute_on_USB_insert&oldid=210720"

Category:

-   Hardware detection and troubleshooting
