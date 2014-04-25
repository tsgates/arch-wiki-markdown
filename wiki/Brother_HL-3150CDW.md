Brother HL-3150CDW
==================

This guide explains how to install a Brother HL-3150CDW color laser
printer using CUPS.

Contents
--------

-   1 Prerequisites
-   2 Installation
    -   2.1 Download and extract drivers
    -   2.2 Adapt the drivers to systemd
    -   2.3 Install in your system
-   3 References

Prerequisites
-------------

This tutorial assumes you have already configured the CUPS printer
server. There is plenty of existing information to get this working. By
the other hand, I assume you have pure systemd archlinux system.

Installation
------------

> Download and extract drivers

-   Download the drivers: LPRDriver and cupswrapperdriver
-   Install rpmextract: pacman -S rpmextract
-   make a directory, for example mkdir ~/brother
-   extract the contents of rpm in that directory: cd ~/brother,
    rpmextract.sh *.rpm
-   it makes two subdirectories: usr and opt

> Adapt the drivers to systemd

The cupswrapper is for init.d systems, but archlinux now uses systemd.
So we have to adapt cupswrapper. Do that:

-   In
    ./opt/brother/Printers/hl3150cdw/cupswrapper/cupswrapperhl3150cdw,
    change all the ocurrences of

    if [  -e /etc/init.d/cups ]; then
       /etc/init.d/cups restart

for

    systemctl restart cups.service

-   You have to do the same with stop and start cups service.
-   At final, you should have the
    ./opt/brother/Printers/hl3150cdw/cupswrapper/cupswrapperhl3150cdw
    with the following contents:

    contents of cupswrapperhl3150cdw


    #! /bin/sh
    #
    # Brother Print filter
    # Copyright (C) 2005-2012 Brother. Industries, Ltd.

    # This program is free software; you can redistribute it and/or modify it
    # under the terms of the GNU General Public License as published by the Free
    # Software Foundation; either version 2 of the License, or (at your option)
    # any later version.
    #
    # This program is distributed in the hope that it will be useful, but WITHOUT
    # ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    # FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
    # more details.
    #
    # You should have received a copy of the GNU General Public License along with
    # this program; if not, write to the Free Software Foundation, Inc., 59 Temple
    # Place, Suite 330, Boston, MA  02111-1307  USA
    #

    printer_model=""hl3150cdw""
    printer_name=`echo $printer_model | tr '[a-z]' '[A-Z]'`
    device_name=`echo $printer_name | eval sed -e 's/MFC/MFC-/' -e 's/DCP/DCP-/' -e 's/HL/HL-/' -e 's/FAX/FAX-/'`
    pcfilename=`echo $printer_name | tr -d '[A-Z]'`
    device_model="Printers"
    tmp_filter=/var/tmp/brother_lpdwrapper_${printer_model}

    if [ -d "/usr/share/cups/model" ]; then
      mkdir -p /usr/share/cups/model/Brother
    else
      mkdir -p /usr/share/ppd/Brother
    fi

    if [ -d "/usr/share/ppd" ]; then
      mkdir -p /usr/share/ppd/Brother       
    else
      mkdir -p /usr/share/cups/model/Brother
    fi



    if [ "$1" = '-e' ]; then
      lpadmin -x ${printer_name}
      rm -f /usr/share/cups/model/Brother/brother_${printer_model}_printer_en.ppd
      rm -f /usr/share/ppd/Brother/brother_${printer_model}_printer_en.ppd
      rm -f /usr/lib/cups/filter/brother_lpdwrapper_${printer_model}
      rm -f /usr/lib64/cups/filter/brother_lpdwrapper_${printer_model}
      rm -f /opt/brother/${device_model}/${printer_model}/cupswrapper/brcupsconfpt1
    #  rm -f /usr/local/Brother/${device_model}/${printer_model}/cupswrapper/brcupsconfpt1
      systemctl restart cups.service
      exit 0
    fi

    if [ "$1" = "-r" ]; then
      lpadmin -x ${printer_name}
      systemctl restart cups.service
      exit 0
    fi
    if [ "$1" = "help" ] || [ "$1" = "-h" ]; then
      echo   'option -h : help'
      echo   '       -i : install'
      echo   '       -e : uninstall'
      echo   '       -r : remove printer'
      exit 0
    fi
    #mkdir -p /usr/local/Brother/${device_model}/${printer_model}/filter
    #mkdir -p /usr/lib/cups/filter

    if [ -e "/opt/brother/${device_model}/${printer_model}/lpd/filter${printer_model}" ]; then
      :
    else
      echo "ERROR : Brother LPD filter is not installed."
    fi
    rm -f /usr/share/cups/model/Brother/brother_${printer_model}_printer_en.ppd
    if [ -d "/usr/share/cups/model" ]; then
      ppd_file_name=/usr/share/cups/model/Brother/brother_${printer_model}_printer_en.ppd
    else
      ppd_file_name=/usr/share/ppd/Brother/brother_${printer_model}_printer_en.ppd
    fi

    if [ -e "/opt/brother/${device_model}/${printer_model}/cupswrapper/brother_${printer_model}_printer_en.ppd" ];	then
    cp "/opt/brother/${device_model}/${printer_model}/cupswrapper/brother_${printer_model}_printer_en.ppd" $ppd_file_name
    fi

    chmod 644 $ppd_file_name

    if [ -d /usr/share/ppd ]
    then
    if [ -d /usr/share/cups/model ]
    then
    	cp $ppd_file_name /usr/share/ppd/Brother/brother_${printer_model}_printer_en.ppd
    	chmod 644 /usr/share/ppd/Brother/brother_${printer_model}_printer_en.ppd
    fi
    fi

    #
    #	create temporary CUPS Filter
    #

    cat <<!ENDOFWFILTER! >$tmp_filter
    #! /bin/sh
    #
    # Copyright (C) 2005-2012 Brother. Industries, Ltd.
    #                                    Ver1.10

    # This program is free software; you can redistribute it and/or modify it
    # under the terms of the GNU General Public License as published by the Free
    # Software Foundation; either version 2 of the License, or (at your option)
    # any later version.
    #
    # This program is distributed in the hope that it will be useful, but WITHOUT
    # ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    # FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
    # more details.
    #
    # You should have received a copy of the GNU General Public License along with
    # this program; if not, write to the Free Software Foundation, Inc., 59 Temple
    # Place, Suite 330, Boston, MA  02111-1307  USA
    #

    LOGFILE="/dev/null"
    LOGLEVEL="1"
    LOGCLEVEL="7"
    DEBUG=0
    NUPENABLE=1
    LOG_LATESTONLY=1


    touch /tmp/${printer_model}_latest_print_info
    chmod 600 -R /tmp/${printer_model}_latest_print_info

    errorcode=0

    if [ \$DEBUG != 0 ]; then
        LOGFILE=/tmp/br_cupsfilter_debug_log
    fi

    PPDC=\`printenv | grep "PPD="\`
    PPDC=\`echo \$PPDC | sed -e 's/PPD=//'\`

    if [ "\$PPDC" = "" ]; then
        PPDC="/usr/share/cups/model/Brother/brother_${printer_model}_printer_en.ppd"
    fi


    if [ \$LOGFILE != "/dev/null" ]; then
      if [ \$LOG_LATESTONLY == "1" ]; then
        rm -f \$LOGFILE
        date                                                           >\$LOGFILE
      else
        if [ -e \$LOGFILE ]; then
    	    date                                                        >>\$LOGFILE
        else
    	    date                                                        >\$LOGFILE
        fi
      fi
        echo "arg0 = \$0"                                           >>\$LOGFILE
        echo "arg1 = \$1"                                           >>\$LOGFILE
        echo "arg2 = \$2"                                           >>\$LOGFILE
        echo "arg3 = \$3"                                           >>\$LOGFILE
        echo "arg4 = \$4"                                           >>\$LOGFILE
        echo "arg5 = \$5"                                           >>\$LOGFILE
        echo "arg6 = \$6"                                           >>\$LOGFILE
        echo "PPD  = \$PPD"                                         >>\$LOGFILE
    fi

    cp  /opt/brother/Printers/${printer_model}/inf/br${printer_model}rc  /tmp/br${printer_model}rc_\$$
    chmod 777 -R /tmp/br${printer_model}rc_\$$
    export BRPRINTERRCFILE=/tmp/br${printer_model}rc_\$$

    INPUT_TEMP_PS=\`mktemp /tmp/br_input_ps.XXXXXX\`

    nup="cat"
    if [ "\`echo \$5 | grep 'Nup='\`" != '' ] && [ \$NUPENABLE != 0 ]; then

    	if   [ "\`echo \$5 | grep 'Nup=64'\`" != '' ]; then
    		nup="psnup -64"
    	elif [ "\`echo \$5 | grep 'Nup=32'\`" != '' ]; then
    		nup="psnup -32"
    	elif [ "\`echo \$5 | grep 'Nup=25'\`" != '' ]; then
    		nup="psnup -25"
    	elif [ "\`echo \$5 | grep 'Nup=16'\`" != '' ]; then
    		nup="psnup -16"
    	elif [ "\`echo \$5 | grep 'Nup=8'\`" != '' ]; then
    		nup="psnup -8"
    	elif [ "\`echo \$5 | grep 'Nup=6'\`" != '' ]; then
    		nup="psnup -6"
    	elif [ "\`echo \$5 | grep 'Nup=4'\`" != '' ]; then
    		nup="psnup -4"
    	elif [ "\`echo \$5 | grep 'Nup=2'\`" != '' ]; then
    		nup="psnup -2"
    	elif [ "\`echo \$5 | grep 'Nup=1'\`" != '' ]; then
    		nup="cat"
    	fi
    	echo   "NUP=\$nup"                                      >>\$LOGFILE
       if [ -e /usr/bin/psnup ]; then
           if [ \$# -ge 7 ]; then
    	       cat \$6  | \$nup > \$INPUT_TEMP_PS
           else
    	       cat       | \$nup > \$INPUT_TEMP_PS
           fi
       else
           if [ \$# -ge 7 ]; then
    	       cp \$6  \$INPUT_TEMP_PS
           else
    	       cat    > \$INPUT_TEMP_PS
           fi
       fi
    else
       if [ \$# -ge 7 ]; then
          cp \$6  \$INPUT_TEMP_PS
       else
          cat    > \$INPUT_TEMP_PS
       fi
    fi
    if [ -e "/opt/brother/${device_model}/${printer_model}/lpd/filter${printer_model}" ]; then
           :
    else
        echo "ERROR: /opt/brother/${device_model}/${printer_model}/lpd/filter${printer_model} does not exist"   >>\$LOGFILE
        echo "ERROR: /opt/brother/${device_model}/${printer_model}/lpd/filter${printer_model} does not exist"   >>/tmp/${printer_model}_latest_print_info
        errorcode=30
        exit
    fi

    CUPSOPTION=\`echo "\$5 Copies=\$4" | sed -e 's/BrMirror=OFF/MirrorPrint=OFF/' -e 's/BrMirror=ON/MirrorPrint=ON/' -e 's/BrChain/Chain/' -e 's/BrBrightness/Brightness/' -e 's/BrContrast/Contrast/' -e 's/BrHalfCut/HalfCut/' -e 's/BrAutoTapeCut/AutoCut/' -e 's/BrHalftonePattern/Halftone/' -e 's/Binary/Binary/' -e 's/Dither/Dither/' -e 's/ErrorDiffusion/ErrorDiffusion/' -e 's/BrSheets/Sheets/' -e 's/multiple-document-handling/Collate/' -e 's/separate-documents-collated-copies/ON/' -e 's/separate-documents-uncollated-copies/OFF/'\`
    if [ -e "/opt/brother/${device_model}/${printer_model}/cupswrapper/brcupsconfpt1" ]; then
    	
      if [ \$DEBUG = 0 ]; then
         /opt/brother/${device_model}/${printer_model}/cupswrapper/brcupsconfpt1  ${printer_name}  \$PPDC 0 "\$CUPSOPTION" "${printer_model}" \$BRPRINTERRCFILE>> /dev/null
      else
         /opt/brother/${device_model}/${printer_model}/cupswrapper/brcupsconfpt1  ${printer_name}  \$PPDC \$LOGCLEVEL "\$CUPSOPTION" "${printer_model}" \$BRPRINTERRCFILE>>\$LOGFILE
      fi
    fi

    if [ \$DEBUG -lt 10 ]; then
        cat    \$INPUT_TEMP_PS | /opt/brother/${device_model}/${printer_model}/lpd/filter${printer_model} 
        echo br${printer_model}rc_\$$   > /tmp/${printer_model}_latest_print_info
        cat  /tmp/br${printer_model}rc_\$$  >> /tmp/${printer_model}_latest_print_info
        rm -f /tmp/br${printer_model}rc_\$$

        if [ \$LOGLEVEL -gt 2 ];  then
    	   if [ \$LOGFILE != "/dev/null" ]; then
    	     echo ""                                                >>\$LOGFILE
    	     echo "    ------PostScript Data-------"                >>\$LOGFILE
    	     cat    \$INPUT_TEMP_PS                                  >>\$LOGFILE
    	   fi
        fi
    fi
    rm -f  \$INPUT_TEMP_PS

    exit $errorcode

    !ENDOFWFILTER!

    chmod 755 $tmp_filter

    #
    #	check /usr/lib/cups/filter
    #
    if [ -d /usr/lib/cups/filter ]; then
    	brotherlpdwrapper=/usr/lib/cups/filter/brother_lpdwrapper_${printer_model}
    	rm -f  $brotherlpdwrapper
    	cp $tmp_filter	$brotherlpdwrapper
    fi

    #
    #	check /usr/lib64/cups/filter
    #
    if [ -e /usr/lib64/cups/filter ]; then
    	brotherlpdwrapper64=/usr/lib64/cups/filter/brother_lpdwrapper_${printer_model}
    	rm -f  $brotherlpdwrapper64
    	cp $tmp_filter	$brotherlpdwrapper64
    fi

    #
    #	remove temporary script file
    #
    rm -f  $tmp_filter

    #chmod a+w /opt/brother/${device_model}/${printer_model}/inf/br${printer_model}rc
    #chmod a+w /opt/brother/${device_model}/${printer_model}/inf
    systemctl stop cups.service
    systemctl restart cups.service

    sleep 2s

    uris=$(lpinfo -v)

    for uri in $uris
    do
    	URI=$(echo $uri | grep ${device_name} | grep usb)
    	if [ "$URI" != '' ];then
    		break;
    	fi
    done

    if [ "$URI" = '' ];then
    	for uri in $uris
    	do
    		URI=$(echo $uri | grep ${device_name} )
    		if [ "$URI" != '' ];then
    			break;
    		fi
    	done
    fi

    if [ "$URI" = '' ];then
    	for uri in $uris
    	do
    		URI=$(echo $uri | grep -i Brother | grep usb )
    		if [ "$URI" != '' ];then
    			break;
    		fi
    	done
    fi	

    if [ "$URI" = '' ];then
    	for uri in $uris
    	do
    		URI=$(echo $uri | grep usb )
    		if [ "$URI" != '' ];then
    			break;
    		fi
    	done
    fi


    if [ "$URI" = '' ];then
    	URI="usb:/dev/usb/lp0"
    fi

    echo lpadmin -p ${printer_name} -E -v $URI -P $ppd_file_name
    lpadmin -p ${printer_name} -E -v $URI -P $ppd_file_name
    								
    exit 0

-   The diff is here:

    # diff cupswrapperhl3150cdw-old cupswrapperhl3150cdw


    50,55c50
    < if [  -e /etc/init.d/cups ]; then
    <    /etc/init.d/cups restart
    < elif [  -e /etc/init.d/cupsys ]; then
    <    /etc/init.d/cupsys restart
    < fi
    < #  /etc/init.d/cups restart
    ---
    >   systemctl restart cups.service
    57a53
    > 
    60,65c56
    < if [  -e /etc/init.d/cups ]; then
    <    /etc/init.d/cups restart
    < elif [  -e /etc/init.d/cupsys ]; then
    <    /etc/init.d/cupsys restart
    < fi
    < #  /etc/init.d/cups restart
    ---
    >   systemctl restart cups.service
    291,303c282,283
    < if [ -e /etc/init.d/lpd ]; then
    <    /etc/init.d/lpd stop
    < fi
    < if [  -e /etc/init.d/lprng ]; then
    <    /etc/init.d/lprng stop
    < fi
    < 
    < 
    < if [  -e /etc/init.d/cups ]; then
    <    /etc/init.d/cups restart
    < elif [  -e /etc/init.d/cupsys ]; then
    <    /etc/init.d/cupsys restart
    < fi
    ---
    > systemctl stop cups.service
    > systemctl restart cups.service

> Install in your system

-   As root, copy the contents of ~/brother/opt to /opt and
    ~/brother/usr/bin/brprintconf_hl3150cdw to /usr/bin/
-   As root:

    # cd /opt/brother/Printers/hl3150cdw/cupswrapper/
    # ./cupswrapperhl3150cdw

-   It automatically adds a printer in cups, with usb interface. In my
    case, I can't print any page with USB, but if you change USB by
    lpd://<your IP printer>/BINARY_P1, everything is OK (remember than
    HL-3150CDW has wifi connection)

References
----------

-   bbs thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-3150CDW&oldid=283233"

Category:

-   Printers

-   This page was last modified on 16 November 2013, at 18:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
