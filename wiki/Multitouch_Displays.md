Multitouch Displays
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Since Linux Kernel 3.2, multitouch devices are handled by the
hid-multitouch module, see Kernel Modules.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Configuration (USB devices)                                        |
| -   2 Rotating the touch screen                                          |
| -   3 Drivers                                                            |
|     -   3.1 eGalax                                                       |
|         -   3.1.1 Invert Y-axis                                          |
+--------------------------------------------------------------------------+

Configuration (USB devices)
---------------------------

Find the vendor ID (VID) and product ID (PID) for your touchscreen using
lsusb:

    $ lsusb

    ...
    Bus 004 Device 002: ID 0eef:725e D-WAV Scientific Co., Ltd 
    ...

Here, VID=0eef (eGalax) and PID=725e. Now, get the MT_CLASS_*
definitions from [1]. Currently vendor specific classes are available
for 3M Cypress and eGalax. If none of this matches your device, you can
try to experiment with the other MT_CLS_*. In this example

    #define MT_CLS_EGALAX                           0x0103

You need to convert MT_CLS_* to decimal (In this case, 0x0103 is 259 in
decimal).

After loading the hid-multitouch, see Kernel Modules, you need to pass
the devices' options with

    # echo BUS VID PID MT_CLASS_* > /sys/module/hid_multitouch/drivers/hid\:hid-multitouch/new_id

In this example, the touchscreen is an USB device, so BUS=3 and the
previous command looks like this:

    # echo 3 0eef 725e 259 > /sys/module/hid_multitouch/drivers/hid\:hid-multitouch/new_id

Reboot. If the touchscreen is detected you should submit your devices'
details (relevant lsusb line) to the linux-input mailing list.

If the touchscreen is not working properly, you may need to install a
specific driver for your touchscreen, see #Drivers.

Rotating the touch screen
-------------------------

Store and mark the following script executable (call the script to see
its input options):

    #!/bin/bash

    ## script to rotate touch screens
    ## will include support for rotating specific monitors

    ###############################################
    #					      #
    #	 Touch_rotate for Asus T101mt	      #
    #             written by Mark Lee             #
    #					      #
    ###############################################

    function main () {  ## main insertion function
    args=("$@");  ## store the arguments in an array
    check-arg;  ## read and check the arguments
    resolve-rotate;  ## resolve the rotation
    rotate-screen;  ## rotate the screen
    }

    function help-man () {  ## print the help manual
    echo "
     where options are:
      [usage]: touch_rotate [options]
      
      -r or -rotate             | rotate the screen; ex. -r right
                                |   <left,right,normal,upside-down>
      -c or -counter-clockwise  | rotate the screen counter clockwise
      -m or -monitor            | set the monitor to rotate; ex. -m native
                                |  <primary,external>
      -i or -id                 | set the id of the touch screen device
      --help                    | print this help screen

      Examples:
         touch_rotate -m native -r right

      Press "Ctrl-C" to exit any time
    "
    }

    function check-arg () {  ## read and check console arguments
    for ((i = 0; i <= ${#args}; i++)); do  ## loop for all arguments passed
      case ${args[$i]} in  ## parse each argument
        -c|-C|-counter-clockwise)
           counter="yes";  ## toggle to rotate counter clockwise
           ;;       
        -r|-R|-rotate|-Rotate)
           rot="${args[$[i + 1]]}";  ## set the new rotation
           ;;
        -m|-M|-monitor|-Monitor)
          mon="${args[$[i + 1]]}";  ## set the monitor to control
          ;;
        -i|-I|-id)
          id="$id";  ## set the id of the device
          ;;
        -help|--help|/?)  ## help menu
          help-man;  ## print the help menu
          exit;  ## exit the script
          ;;
        -*)  ## for all other options
          echo "Unrecognized option: ${args[$i]}"
          help-man;  ## print the help menu
          ;;
      esac;
    done;
    if [ -z "$mon" ]; then  ## check if monitor was specified
       mon="primary";  ## set the monitor to be the primary monitor
    fi;
    if [ "$mon" == "primary" ]; then
       mon="$(xrandr | awk '$2~/^connected/ {print $1}')";  ## set the monitor to be the connected monitor
    fi;
    if [ "$counter" == "yes" ]; then  ## if user wants to rotate counter clockwise
       rot=$(xrandr -q --verbose | awk "/$mon/ {print \$5}");  ## capture the current rotation
       resolve-rotate;  ## convert the current rotation to an integer
       rot=$[$[int_rot + 1] % 4];  ## increment the rotation by one and divide by four
    fi;
    if [ -z "$rot" ]; then  ## check if a rotation was specified
       echo "Which orientation do you want your display to be?";
       select rot in normal left upside-down right; do  ## print menu of possible rotations
          break;  ## break the loop
       done;
    fi;
    if [ -z "$id" ]; then  ## if the id of the device is not specified
       id=$(xinput -list | awk '/MultiTouch/ {print $6}' | awk -F'=' '{print $2}');  ## get the id of the touch screen
    fi;
    }

    function resolve-rotate () {  ## resolve the touch screen matrix
    case $rot in
      normal|0)
        int_rot=0;
        rot_mat="1 0 0 0 1 0"
        ;;
      left|1)
        int_rot=1;
        rot_mat="0 -1 1 1 0 0"
        ;;
      inverted|upside-down|2)
        int_rot=2;
        rot_mat="-1 0 1 0 -1 1"
        ;;
      right|3)
        int_rot=3;
        rot_mat="0 1 0 -1 0 1"
        ;;
    esac;
    }


    ## touch cursor jumps around when in any other orientation than normal
    function rotate-screen () {  ## rotate the touch screen
    xrandr -o $int_rot;  ## rotate the display screen
    xinput set-float-prop $id "Coordinate Transformation Matrix" $rot_mat 0 0 1;  ## rotate the touch screen
    }

    main $@;  ## call the main function and pass console arguments

Drivers
-------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> eGalax

The driver for eGalax tocushcreens is available from the eGalax website.
Also, it is availbale as xf86-input-egalax-linux3 from the Arch User
Repository.

Invert Y-axis

If after installing the eGalax driver the Y-axis of the touchscreen is
inverted, edit the file /etc/eGTouchd.ini an change the value of
Direction from 0 to 2:

    /etc/eGtouchd.ini

    ...
    DetectRotation 0
    Direction 2
    Orientation 0
    ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Multitouch_Displays&oldid=242895"

Category:

-   Other hardware
