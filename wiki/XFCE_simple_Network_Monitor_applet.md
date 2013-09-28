XFCE simple Network Monitor applet
==================================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Prerequisites                                                      |
| -   3 Installation                                                       |
| -   4 Configuration                                                      |
+--------------------------------------------------------------------------+

Introduction
------------

This little "applet" will add a plain text network monitor for XFCE,
without requiring gnome applets support. Unlike the native Xfce netload
plugin, this one uses precise plain text figures instead of graphical
bars, and also (optionally) reports the CPU usage in percentaje (all
system cores). In addition, when placing the mouse over it, it displays
a tooltip with extended information. This picture shows how it looks
like. The speed units are automatically selected between kbps and Mbps,
formatted in a way that allows to ignore the unit type, difficult to
track when the speed changes too quickly (when changing from 999 kbps to
1 Mbps or vice-versa, one becomes immediately aware without needing to
look at the kbps/Mbps text).

Prerequisites
-------------

It runs within the [xfce4-genmon-plugin]. This implies that it is re-run
continuously (typically each second) but this does not causes a
performance penalty since it is not an script calling several programs,
but a single native C++ application, and the binary will be cached by
the system. Since it is executed periodically, it needs to save the
state information. By default does it in /dev/shm (shared memory) to
avoid continuous writes on disk. Make sure that your /etc/fstab file has
the following line:

    shm   /dev/shm   tmpfs   nodev,nosuid   0   0

Installation
------------

You need to compile the C++ application: save the following file and run
the command g++ -O3 -lrt netmon.cpp -o netmon to generate the netmon
binary, and place it in a location of your choice (for example,
/usr/local/bin).

    netmon.cpp

    /*
     * Copyright (C) 2010 Ciriaco Garcia de Celis
     *
     * This program is  free software:  you can redistribute it and/or
     * modify it under the terms of the  GNU General Public License as
     * published by the Free Software Foundation,  either version 3 of
     * the License, or (at your option) any later version.
     *
     * This program is distributed in the hope that it will be useful,
     * but WITHOUT ANY WARRANTY;  without even the implied warranty of
     * MERCHANTABILITY  or  FITNESS FOR A PARTICULAR PURPOSE.  See the
     * GNU General Public License (GPL) for more details.
     *
     * You should have received a copy of the GNU  GPL along with this
     * program. If not, see <http://www.gnu.org/licenses/>.
     */

    // compile with "g++ -O3 -lrt netmon.cpp -o netmon"

    #include <sys/stat.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <cstdio>
    #include <cstring>
    #include <cstdlib>
    #include <ctime>
    #include <climits>

    #define STATE_FILE_BASE "/dev/shm/netmon"

    int exitapp(int exitcode)
    {
        char errmsg[64];
        sprintf(errmsg, "ERROR code %d", exitcode);
        write(1, errmsg, strlen(errmsg));
        return exitcode;
    }

    int main(int argc, char** argv)
    {
        if (argc < 2)
        {
             printf("usage: %s <network_interface> [CPU]\n", argv[0]);
             return 1;
        }

        bool reportCPU = (argc > 2) && (strcmp(argv[2], "CPU") == 0);

        char buffer[4096], cad[256], *ni, *nf;
        
        // read network information
        int fd = open("/proc/net/dev", O_RDONLY);
        if (fd < 0) return exitapp(2);
        int bytes = read(fd, buffer, sizeof(buffer)-1);
        close(fd);
        if (bytes < 0) return exitapp(3);
        buffer[bytes] = 0;

        timespec tp;
        clock_gettime(CLOCK_MONOTONIC, &tp);
        long long nanoseconds = tp.tv_sec * 1000000000LL + tp.tv_nsec;

        long long recv_bytes=LLONG_MAX, sent_bytes=LLONG_MAX;
        bool networkAvailable = false;

        // search for the proper network interface
        strcpy(cad, argv[1]);
        strcat(cad, ":");
        char *pif = strstr(buffer, cad);
        if (pif != NULL)
        {
            networkAvailable = true;

            // jump to the received bytes field
            ni = pif + strlen(cad);
            while (*ni && ((*ni == ' ') || (*ni == '\t'))) ni++;
            for (nf = ni; *nf && (*nf != ' ') && (*nf != '\t'); nf++);
            *nf++ = 0;

            // get the received bytes
            recv_bytes = atoll(ni);

            // jump to the sent bytes field
            for (int skip = 0; skip < 8; skip++)
            {
                ni = nf;
                while (*ni && ((*ni == ' ') || (*ni == '\t'))) ni++;
                for (nf = ni; *nf && (*nf != ' ') && (*nf != '\t'); nf++);
                if (!*nf) break;
                *nf++ = 0;
            }

            // get the sent bytes
            sent_bytes = atoll(ni);
        }

        long long user_mode_time=0, user_mode_nice_time=0, system_mode_time=0, idle_time=0;

        if (reportCPU)
        {
            // read CPU information
            fd = open("/proc/stat", O_RDONLY);
            if (fd < 0) return exitapp(4);
            bytes = read(fd, buffer, sizeof(buffer)-1);
            close(fd);
            if (bytes < 0) return exitapp(5);
            buffer[bytes] = 0;

            pif = strstr(buffer, "cpu ");
            if (pif != NULL)
            {
                ni = pif + 3;
                while (*ni && ((*ni == ' ') || (*ni == '\t'))) ni++;
                for (nf = ni; *nf && (*nf != ' ') && (*nf != '\t'); nf++);
                *nf++ = 0;

                // get the user mode time
                user_mode_time = atoll(ni);

                ni = nf;
                while (*ni && ((*ni == ' ') || (*ni == '\t'))) ni++;
                for (nf = ni; *nf && (*nf != ' ') && (*nf != '\t'); nf++);
                *nf++ = 0;

                // get the user mode nice time
                user_mode_nice_time = atoll(ni);

                ni = nf;
                while (*ni && ((*ni == ' ') || (*ni == '\t'))) ni++;
                for (nf = ni; *nf && (*nf != ' ') && (*nf != '\t'); nf++);
                *nf++ = 0;

                // get the system mode time
                system_mode_time = atoll(ni);

                ni = nf;
                while (*ni && ((*ni == ' ') || (*ni == '\t'))) ni++;
                for (nf = ni; *nf && (*nf != ' ') && (*nf != '\t'); nf++);
                *nf++ = 0;

                // get the idle time
                idle_time = atoll(ni);
            }
        }

        // read the received/sent bytes, date and CPU usage stored by a previous execution
        sprintf(cad, "%s.%s.%d", STATE_FILE_BASE, argv[1], getuid());
        fd = open(cad, O_RDWR | O_CREAT, 0664);
        if (fd < 0) return exitapp(6);
        bytes = read(fd, buffer, sizeof(buffer)-1);
        if (bytes < 0)
        {
            close(fd);
            return exitapp(7);
        }
        long long prev_recv_bytes, prev_sent_bytes, prev_nanoseconds = -1;
        long long prev_user_mode_time, prev_user_mode_nice_time, prev_system_mode_time, prev_idle_time = -1;
        if (bytes > 0)
        {
            prev_recv_bytes = atoll(buffer);
            prev_sent_bytes = atoll(buffer+20);
            prev_nanoseconds = atoll(buffer+40);
            prev_user_mode_time = atoll(buffer+60);
            prev_user_mode_nice_time = atoll(buffer+80);
            prev_system_mode_time = atoll(buffer+100);
            prev_idle_time = atoll(buffer+120);
        }

        // store in the file the current values for later use
        sprintf(buffer, "%019lld\n%019lld\n%019lld\n%019lld\n%019lld\n%019lld\n%019lld\n", 
            recv_bytes, sent_bytes, nanoseconds,
            user_mode_time, user_mode_nice_time, system_mode_time, idle_time);
        lseek(fd, 0, SEEK_SET);
        write(fd, buffer, 140);
        close(fd);

        // generate the result

        strcpy(buffer, "<txt>");

        bool hasNet = networkAvailable && (prev_nanoseconds >= 0) && (recv_bytes >= prev_recv_bytes) && (sent_bytes >= prev_sent_bytes);

        if (!networkAvailable)
        {
            sprintf(cad, "  %s is down", argv[1]);
            strcat(buffer, cad);
        }
        else if (!hasNet)
        {
            strcat(buffer, "     ? kbps IN \n     ? kbps OUT");
        }
        else
        {
            long long elapsed = nanoseconds - prev_nanoseconds;
            if (elapsed < 1) elapsed = 1;
            double seconds = elapsed / 1000000000.0;
            long long sent = sent_bytes - prev_sent_bytes;
            long long received = recv_bytes - prev_recv_bytes;
            long inbps = (long) (8 * received / seconds + 999); // adding 999 ensures "1" for any rate above 0
            long outbps = (long) (8 * sent / seconds + 999);
            if (inbps < 1000000)
                sprintf(cad, "%6d kbps IN \n", inbps/1000);
            else
                sprintf(cad, "%6.3f Mbps IN \n", inbps/1000000.0);
            strcat(buffer, cad);

            if (outbps < 1000000)
                sprintf(cad, "%6d kbps OUT", outbps/1000);
            else
                sprintf(cad, "%6.3f Mbps OUT", outbps/1000000.0);
            strcat(buffer, cad);
            
        }

        long long cpu_used = user_mode_time + user_mode_nice_time + system_mode_time
                           - (prev_user_mode_time + prev_user_mode_nice_time + prev_system_mode_time);
        long long total_cpu = cpu_used + (idle_time - prev_idle_time);
        bool hasCPU = (prev_idle_time >= 0) && (total_cpu > 0);
        if (reportCPU)
        {
            if (!hasCPU)
            {
                strcat(buffer, "\n     ?  % CPU");
            }
            else
            {
                sprintf(cad, "\n   %5.1f%% CPU", cpu_used * 100.0 / total_cpu);
                strcat(buffer, cad);
            }
        }

        strcat(buffer, "</txt><tool>");

        if (networkAvailable && hasNet)
        {
            sprintf(cad, " %s:\n    %.2f MB received \n    %.2f MB sent ",
                        argv[1], recv_bytes/1000000.0, sent_bytes/1000000.0);
            strcat(buffer, cad);
        }

        if (reportCPU && hasCPU)
        {
            if (networkAvailable && hasNet) strcat(buffer, "\n");
            long long total_used_cpu = user_mode_time + user_mode_nice_time + system_mode_time;
            sprintf(cad, " CPU usage:\n    %5.1f%% since boot ",
                        total_used_cpu * 100.0 / (total_used_cpu + idle_time));
            strcat(buffer, cad);
        }

        strcat(buffer, "</tool>");

        write(1, buffer, strlen(buffer));

        return 0;
    }

Configuration
-------------

Insert in your panel a Generic Monitor applet. In the Command field
place a invocation of the tool, selecting the network interface (eth0,
ppp0, wlan0, ...) and optionally add the CPU parameter to select
reporting the CPU usage (the applet will print a third line). For
example:

    /usr/local/bin/netmon wlan0 CPU

In the Period(s) field select the refresh rate (1 second recommended).
Uncheck the Label field. An excellent text font is Terminus
([terminus-font] package required) but any monospace, fixed or courier
font will be ok.

This picture resumes the settings. In case of several network
interfaces, you can add as many instances as you want.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XFCE_simple_Network_Monitor_applet&oldid=239072"

Category:

-   Networking
