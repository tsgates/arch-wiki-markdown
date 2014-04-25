Mount encrypted volumes in parallel
===================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: The approach     
                           described was            
                           implemented pre-systemd. 
                           Hence, the modified      
                           rc.sysinit is gone on a  
                           typical Arch install.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is a simple change to rc.sysinit that allows mounting of your
encypted volumes in parallel, which can speed up boot immensely if you
have more than one non-root encrypted partition.

NOTE: You cannot use ASK in /etc/crypttab when using this tweak.

Contents
--------

-   1 Installing
-   2 The Code
-   3 TODO
-   4 See Also

Installing
==========

Just find this section in /etc/rc.sysinit (mine was at line 164), and
replace that entire stanza with the following.

The Code
========

    # Set up non-root encrypted partition mappings
    if [ -f /etc/crypttab -a -n "$(/bin/grep -v ^# /etc/crypttab | /bin/grep -v ^$)" ]; then
    	/sbin/modprobe -q dm-mod 2>/dev/null
    	stat_busy "Unlocking encrypted volumes:"
    	csfailed=0
    	CS=/sbin/cryptsetup.static
    	do_crypt() {
    		if [ $# -ge 3 ]; then
    			cname="$1"
    			csrc="$2"
    			cpass="$3"
    			shift 3
    			copts="$*"
    			echo "Unlocking ${cname}.."
    			# For some fun reason, the parameter ordering varies for
    			# LUKS and non-LUKS devices.  Joy.
    			if [ "${cpass}" = "SWAP" ]; then
    				# This is DANGEROUS! The only possible safety check
    				# is to not proceed in case we find a LUKS device
    				# This may cause dataloss if it is not used carefully
    				if $CS isLuks $csrc 2>/dev/null; then
    					false
    				else
    					$CS -d /dev/urandom $copts create $cname $csrc >/dev/null
    					if [ $? -eq 0 ]; then
    						stat_append "creating swapspace.."
    						/sbin/mkswap -L $cname /dev/mapper/$cname >/dev/null
    					fi
    				fi
    			elif [ "${cpass}" = "ASK" ]; then
    				printf "\nOpening '${cname}' volume:\n"
    				if $CS isLuks $csrc 2>/dev/null; then
    					$CS $copts luksOpen $csrc $cname < /dev/console
    				else
    					$CS $copts create $cname $csrc < /dev/console
    				fi
    			elif [ "${cpass:0:1}" != "/" ]; then
    				if $CS isLuks $csrc 2>/dev/null; then
    					echo "$cpass" | $CS $copts luksOpen $csrc $cname >/dev/null
    				else
    					echo "$cpass" | $CS $copts create $cname $csrc >/dev/null
    				fi
    			else
    				if $CS isLuks $csrc 2>/dev/null; then
    					$CS -d $cpass $copts luksOpen $csrc $cname >/dev/null
    				else
    					$CS -d $cpass $copts create $cname $csrc >/dev/null
    				fi
    			fi
    			if [ $? -ne 0 ]; then
    				csfailed=1
    				echo "${cname} failed to unlock "
    			else
    				echo "${cname} unlocked "
    			fi
    		fi
    	}
    	while read line; do
    		eval do_crypt "$line" &
    	done </etc/crypttab
    				wait
    	if [ $csfailed -eq 0 ]; then
    		stat_done
    	else
    		stat_fail
    	fi
    	# Maybe someone has LVM on an encrypted block device
    	if [ "$USELVM" = "yes" -o "$USELVM" = "YES" ]; then
    		if [ -x /sbin/lvm -a -d /sys/block ]; then
    			/sbin/lvm vgscan --ignorelockingfailure --mknodes >/dev/null
    			/sbin/lvm vgchange --ignorelockingfailure -a y >/dev/null
    		fi
    	fi
    fi

TODO
====

-   make this work with ASK
-   add an explanation of how it works to the wiki page

See Also
========

-   System Encryption with LUKS for dm-crypt

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mount_encrypted_volumes_in_parallel&oldid=267964"

Category:

-   Boot process

-   This page was last modified on 25 July 2013, at 19:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
