Netcf
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary

A guide to installing and understanding netcf abstraction

Related

Network

Resources

netcf repository

From the netcf project site:

netcf is

-   a library for configuring network interfaces
-   a command line tool (ncftool) to do the same from the command line
-   distribution-agnostic and supports multiple distributions and
    operating systems (well, soon, anyway)
-   sets up Ethernet interfaces, bridges, and bonds

Both libvirt and NetworkManager need this functionality - netcf
implements what is common to both of them.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparation                                                        |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Usage                                                              |
| -   5 Developement                                                       |
|     -   5.1 Ethernet interface                                           |
|                                                                          |
| -   6 Tips and tricks                                                    |
| -   7 FAQ                                                                |
|     -   7.1 Q: Why doesn't netcfg do (some feature)?                     |
|     -   7.2 Q: Why doesn't netcfg behave in this way?                    |
|     -   7.3 Q: Do I still need (some thing) if I'm using netcfg?         |
+--------------------------------------------------------------------------+

Preparation
-----------

Installation
------------

Configuration
-------------

Usage
-----

Developement
------------

The question of a potential backend for Archlinux has been answered in
David Lutterkort mail, but nothing poped out. David Lutterkort suggered
using Augeas because that simplified the code for the Fedora/RHEL
backend significantly. So first though is to use netcfg tool from
archlinux, staying close to redhat way of network managing (via
/etc/network.d instead of /etc/sysconfig/network-scripts).

The wrapper will have to find the traduction of each netcf terms to
netcfg one :

  Netcf                  Netcfg
  ---------------------- -------------------
  DEVICE                 INTERFACE
  IPADDR                 ADDR
  ONBOOT                 Y
  BOOTPROTO              IP
  NETMASK                Y
  GATEWAY                GATEWAY
  X                      BRIDGE_INTERFACES
  X                      CONFIGSECTION
  TYPE                   CONNECTION
  X                      DESCRIPTION
  X                      ESSID
  X                      IP
  X                      IPCFG
  X                      KEY
  X                      PEER
  X                      PPP_TIMEOUT
  X                      SECURITY
  X                      WPA_CONF
  BONDING_OPTS           Y
  BRIDGE                 Y
  DELAY                  Y
  DHCPV6                 Y
  HWADDR                 Y
  IPADDR                 Y
  IPV6ADDR               Y
  IPV6ADDR_SECONDARIES   Y
  IPV6_AUTOCONF          Y
  IPV6_DEFAULTGW         Y
  IPV6INIT               Y
  MASTER                 Y
  MTU                    Y
  NETMASK                Y
  PEERDNS                Y
  SLAVE                  Y
  STP                    Y
  VLAN                   Y

These terms are parsed according to data/xml/initscript-put.xsl and
data/xml/initscript-get.xsl. First one convert Augeas XML to a specific
XML file, and the other does the reverse transform.

> Ethernet interface

initscript-put.xsl

initscript-get.xsl

      <!--
          Ethernet (physical interface)
      -->
      <xsl:template match="/interface[@type = 'ethernet']">
        <tree>
          <xsl:call-template name="bare-ethernet-interface"/>
          <xsl:call-template name="interface-addressing"/>
        </tree>
      </xsl:template>

bare-ethernet-interface

      <xsl:template name="bare-ethernet-interface">
        <xsl:call-template name="name-attr"/>
        <xsl:if test="mac">
          <node label="HWADDR" value="{mac/@address}"/>
        </xsl:if>
        <xsl:call-template name="startmode"/>
        <xsl:call-template name="mtu"/>
      </xsl:template>

interface-addressing

      <xsl:template name="interface-addressing">
        <xsl:for-each select="protocol[@family='ipv4']">
          <xsl:call-template name="protocol-ipv4"/>
        </xsl:for-each>
        <xsl:for-each select="protocol[@family='ipv6']">
          <xsl:call-template name="protocol-ipv6"/>
        </xsl:for-each>
      </xsl:template>

name-attr

      <xsl:template name="name-attr">
        <xsl:attribute name="path">/files/etc/network.d/interfaces/ifcfg-<xsl:value-of select="@name"/></xsl:attribute>
        <node label="INTERFACE" value="{@name}"/>
      </xsl:template>

start-mode

      <xsl:template name="startmode">
        <xsl:choose>
          <xsl:when test="$g_startmode = 'onboot'">
            <node label="ONBOOT" value="yes"/>
          </xsl:when>
          <xsl:when test="$g_startmode = 'none'">
            <node label="ONBOOT" value="no"/>
          </xsl:when>
          <xsl:when test="$g_startmode = 'hotplug'">
            <node label="ONBOOT" value="no"/>
            <node label="HOTPLUG" value="yes"/>
          </xsl:when>
        </xsl:choose>
      </xsl:template>

mtu

      <xsl:template name="mtu">
        <xsl:if test="$g_mtu != ''">
          <node label="MTU" value="{$g_mtu}"/>
        </xsl:if>
      </xsl:template>

protocol-ipv4

      <xsl:template name="protocol-ipv4">
        <xsl:choose>
          <xsl:when test="dhcp">
            <node label="BOOTPROTO" value="dhcp"/>
            <xsl:if test="dhcp/@peerdns">
              <node label="PEERDNS" value="{dhcp/@peerdns}"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="ip">
            <node label="BOOTPROTO" value="none"/>
            <node label="ADDR" value="{ip/@address}"/>
            <xsl:if test="ip/@prefix">
              <node label="NETMASK" value="{ipcalc:netmask(ip/@prefix)}"/>
            </xsl:if>
            <xsl:if test="route">
              <node label="GATEWAY" value="{route/@gateway}"/>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:template>

protocol-ipv6

      <xsl:template name="protocol-ipv6">
        <node label="IPV6INIT" value="yes"/>
        <xsl:if test="count(autoconf) > 0">
          <node label="IPV6_AUTOCONF" value="yes"/>
        </xsl:if>
        <xsl:if test="count(autoconf) = 0">
          <node label="IPV6_AUTOCONF" value="no"/>
        </xsl:if>
        <xsl:if test="count(dhcp) > 0">
          <node label="DHCPV6" value="yes"/>
        </xsl:if>
        <xsl:if test="count(dhcp) = 0">
          <node label="DHCPV6" value="no"/>
        </xsl:if>
        <xsl:if test="count(ip) > 0">
          <node label="IPV6ADDR">
            <xsl:attribute name="value">
              <xsl:value-of select="ip[1]/@address"/><xsl:if test="ip[1]/@prefix">/<xsl:value-of select="ip[1]/@prefix"/></xsl:if>
            </xsl:attribute>
          </node>
        </xsl:if>
        <xsl:if test="count(ip) > 1">
          <node label="IPV6ADDR_SECONDARIES">
            <xsl:attribute name="value">
              <xsl:text>'</xsl:text>
              <xsl:for-each select="ip[1]/following-sibling::ip[following-sibling::ip]">
                <xsl:value-of select="@address"/><xsl:if test="@prefix">/<xsl:value-of select="@prefix"/></xsl:if><xsl:value-of select="string(' ')"/>
              </xsl:for-each>
              <xsl:for-each select="ip[last()]">
                <xsl:value-of select="@address"/><xsl:if test="@prefix">/<xsl:value-of select="@prefix"/></xsl:if>
              </xsl:for-each>
              <xsl:text>'</xsl:text>
            </xsl:attribute>
          </node>
        </xsl:if>
        <xsl:if test="route">
          <node label="IPV6_DEFAULTGW" value="{route/@gateway}"/>
        </xsl:if>
      </xsl:template>

Tips and tricks
---------------

FAQ
---

Q: Why doesn't netcfg do (some feature)?

A: netcfg doesn't need to; it connects to networks. netcfg is modular
and re-usable; see /usr/lib/networks for reusable functions for custom
scripts.

Q: Why doesn't netcfg behave in this way?

A: netcfg doesn't enforce any rules; it connects to networks. It doesn't
impose any heuristics, like "disconnect from wireless if ethernet is
connected". If you want behaviour like that, it should be simple to
write a separate tool over netcfg. See the question above.

Q: Do I still need (some thing) if I'm using netcfg?

A: This question usually references /etc/hosts and the HOSTNAME variable
in /etc/rc.conf, which are both still required. You may remove network
from the DAEMONS array if you've configured all your networks with
netcfg, though.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netcf&oldid=206915"

Category:

-   Networking
