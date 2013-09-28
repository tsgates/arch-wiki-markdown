PolicyKit
=========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Now we have      
                           systemd and javascript   
                           in rule config (Discuss) 
  ------------------------ ------------------------ ------------------------

From PolicyKit Library Reference Manual:

PolicyKit is an application-level toolkit for defining and handling the
policy that allows unprivileged processes to speak to privileged
processes: It is a framework for centralizing the decision making
process with respect to granting access to privileged operations for
unprivileged applications. PolicyKit is specifically targeting
applications in rich desktop environments on multi-user UNIX-like
operating systems. It does not imply or rely on any exotic kernel
features.

PolicyKit is used for controlling system-wide privileges. It provides an
organized way for non-privileged processes to communicate with
privileged ones. In contrast to systems such as sudo, it does not grant
root permission to an entire process, but rather allows a finer level of
control of centralized system policy.

PolicyKit works by delimiting distinct actions, e.g. running GParted,
and delimiting users by group or by name, e.g. members of the wheel
group. It then defines how -- if at all -- those users are allowed those
actions, e.g. by identifying as members of the group by typing in their
passwords.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 PolicyKit vs. polkit                                               |
| -   2 Structure                                                          |
|     -   2.1 Actions                                                      |
|     -   2.2 Authorities                                                  |
|     -   2.3 Admin identities                                             |
|                                                                          |
| -   3 Action groups                                                      |
| -   4 Limitations                                                        |
| -   5 Examples                                                           |
|     -   5.1 Suspend and hibernate                                        |
|     -   5.2 Mounting USB drives                                          |
|     -   5.3 Workaround to mount filesytems by user in group storage      |
|         without password                                                 |
|                                                                          |
| -   6 Documentation                                                      |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

PolicyKit vs. polkit
--------------------

In the development of PolicyKit, major changes were introduced around
version 0.92. In order to make the distinction clear between the way the
old and the new versions worked, the new ones are referred to as
'polkit' rather than PolicyKit. Searching for PolicyKit on the web will
mostly point to outdated documentation and lead to confusion and
frustration, e.g. [1]. The main distinction between PolicyKit and polkit
is the abandonment of single-file configuration in favour of
directory-based configuration, i.e. there is no PolicyKit.conf.

Structure
---------

PolicyKit definitions can be divided into three kinds:

-   Actions are defined in XML .policy files located in
    /usr/share/polkit-1/actions. Each action has a set of default
    permissions attached to it (e.g. you need to identify as an
    administrator to use the GParted action). The defaults can be
    overruled but editing the actions files is NOT the correct way (see
    askubuntu.com for a bad example)
-   Authorities are defined in INI-like .pkla files. They are found in
    two places: 3rd party packages can use /var/lib/polkit-1 (though few
    if any do) and /etc/polkit-1 is for local configuration. The .pkla
    files designate a subset of users, refer to one (or more) of the
    actions specified in the actions files and determine with what
    restrictions these actions can be taken by that/those user(s). As an
    example, an authority file could overrule the default requirement
    for all users to authenticate as an admin when using GParted,
    determining that some specific user doesn't need to. Or isn't
    allowed to use GParted at all.
-   Admin identities are set in /etc/polkit-1/localauthority.conf.d One
    of the basic points of using PolicyKit is determining whether or not
    a user needs to authenticate (possibly as an administrative user) or
    not in order to get permission to carry out the action. PolicyKit
    therefore has a specific configuration for deciding if the user
    trying to carry out an action is or is not an administrative user.
    Common definitions are 'only root user' or 'all members of wheel'
    (the Arch default).

> Actions

Each action is defined in an <action> tag in a .policy file. The
org.archlinux.pkexec.gparted.policy contains a single action and looks
like this:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE policyconfig PUBLIC
     "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
    <policyconfig>

      <action id="org.archlinux.pkexec.gparted">
        <message>Authentication is required to run the GParted Partition Editor</message>
        <icon_name>gparted</icon_name>
        <defaults>
          <allow_any>auth_admin</allow_any>
          <allow_inactive>auth_admin</allow_inactive>
          <allow_active>auth_admin</allow_active>
        </defaults>
        <annotate key="org.freedesktop.policykit.exec.path">/usr/sbin/gparted</annotate>
        <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
      </action>

    </policyconfig>

The attribute id is the actual command sent to dbus, the message tag is
the explanation to the user when authentification is required and the
icon_name is sort of obvious.

The default tag is where the permissions or lack thereof are located. It
contains three settings: allow_any, allow_inactive, and allow_active.
Inactive sessions are generally remote sessions (SSH, VNC, etc.) whereas
active sessions are logged directly into the machine on a TTY or an X
display. Allow_any is the setting encompassing both scenarios.

For each of these settings the following options are available:

-   no: The user is not authorized to carry out the action. There is
    therefore no need for authentification.
-   yes: The user is authorized to carry out the action without any
    authentification.
-   auth_self: Authentication is required but the user need not be an
    administrative user.
-   auth_admin: Authentication as an administrative user is require.
-   auth_self_keep: The same as auth_self but, like sudo, the
    authorization lasts a few minutes.
-   auth_admin_keep: The same as auth_admin but, like sudo, the
    authorization lasts a few minutes.

These are default setting and unless overruled in later configuration
will be valid for all users.

As can be seen from the GParted action, users are required to
authenticate as administrators in order to use GParted, regardless of
whether the session is active or inactive.

> Authorities

Authorizations that overrule the default settings are laid out in a set
of directories as described above. For all purposes relating to personal
configuration of a single system, only
/etc/polkit-1/localauthority/50-local.d should be used. The authority
files are read in alphabetical/numerical order, where later files take
precedence, so that one configuration file can be relied upon to
overrule another, e.g.

    10_allow_all_users_group_members_to_automount_without_authentification.pkla
    15_but_not_jack.pkla

The layout of the .pkla files is fairly self-explanatory:

    [Ban users jack and jill from using gparted]
    Identity=unix-user:jack;unix-user:jill
    Action=org.archlinux.pkexec.gparted
    ResultAny=no
    ResultInactive=no
    ResultActive=no

An authorization needs to be preceded by a heading enclosed in square
paratheses. The follows an identification with pairs of unix-user or
unix-group and the name. Use semicolons to separate the pairs to include
more than one user or group. The designating name of the action is the
one from the action's id attribute in /usr/share/polkit-1/actions. The
three Result-settings mirror those from the action definition. Here we
have overruled the default auth_admin setting and disallowed jack and
jill from running gparted.

> Admin identities

Like the authorities files, configuration works by letting the last read
file take precedence over earlier ones. The default configuration for
admin identities is contained in the file 50-localauthority.conf so any
changes to that configuration should be made by copying the file to,
say, 60-localauthority.conf and editing that file.

    /etc/polkit-1/localauthority.conf.d/50-localauthority.conf

    # Configuration file for the PolicyKit Local Authority.
    #
    # DO NOT EDIT THIS FILE, it will be overwritten on update.
    #
    # See the pklocalauthority(8) man page for more information
    # about configuring the Local Authority.
    #

    [Configuration]
    AdminIdentities=unix-group:wheel

The only part to edit (once copied) is the right part of the equation:
As whom should a user authenticate when asked to authenticate as an
administrative user? If she herself is a member of the group designated
as admins, she only need enter her own password. If some other user,
e.g. root, is the only admin identity, she would need to enter in root's
password. The format of the user identification is the same as the one
used in designating authorities. The Arch default is to make all members
of the group wheel administrators.

Action groups
-------------

The actions available to you via PolicyKit will depend on the packages
you have installed. Some are used in multiple desktop environments
(org.freedesktop.*), some are DE-specific (org.gnome.*) and some are
specific to a single program (org.archlinux.pkexec.gparted.policy). The
commandpkaction lists alle the actions defined in
/usr/share/polkit-1/actions for quick reference.

To get an idea of what PolicyKit can do, here are a few commonly used
groups of actions:

-   ConsoleKit (org.freedesktop.consolekit.policy) actions regulated by
    PolicyKit include shutting down and restarting, including when other
    users may still be logged in.
-   Upower (org.freedesktop.upower.policy) actions regulated by
    PolicyKit include suspending and hibernating.
-   Udisks2 (org.freedesktop.udisks2.policy) actions regulated by
    PolicyKit include mounting file systems and unclocking encrypted
    devices.
-   NetworkManager (org.freedesktop.NetworkManager.policy) actions
    regulated by PolicyKit include turning on and off the network, wifi,
    or mobile broadband.

Limitations
-----------

PolicyKit operates on top of the exisiting permissions systems in linux
-- group membership, administrator status -- it does not replace them.
The example above prohibited the user jack from using the GParted
action, but it does not preclude him running GParted by some means that
do not respect PolicyKit, e.g. the command line. Therefore it's probably
better to use PolicyKit to expand access to priviledged services for
unpriviledged users, rather than to try using it to curtail the rights
of (semi-)privileged users. For security purposes, the sudoers file is
still the way to go.

Examples
--------

> Suspend and hibernate

To give the users in the group power the permission to suspend or
hibernate using Upower, it is sufficient to create an authority file
/etc/polkit-1/localauthority/50-local.d/org.freedesktop.upower.pkla that
allows group members the use of the two actions:

    [Suspend/hibernate permissions]
    Identity=unix-group:power
    Action=org.freedesktop.upower.hibernate;org.freedesktop.upower.suspend
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

Since the action groups change occasionally, it might be useful to check
the documentation in
/usr/share/polkit-1/actions/org.freedesktop.upower.policy to make sure
that the actions are correct.

> Mounting USB drives

To grant users in the storage group the permission to
mount/unmount/eject disks via Udisks2, the following lines can be
written into a file
/etc/polkit-1/localauthority/50-local.d/org.freedesktop.udisks2.pkla:

    [Storage Permissions]
    Identity=unix-group:storage
    Action=org.freedesktop.udisks2.filesystem-mount;org.freedesktop.udisks2.modify-device
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

> Workaround to mount filesytems by user in group storage without password

the following lines can be written into a file
/etc/polkit-1/rules.d/10-udisks2.rules:

    // Allow udisks2 to mount devices without authentication
    // for users in the "storage" group.
    polkit.addRule(function(action, subject) {
     if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
          action.id == "org.freedesktop.udisks2.filesystem-mount") &&
    subject.isInGroup("storage")) {
           return polkit.Result.YES;
       }
    });
    polkit.addRule(function(action, subject) {
       if ((action.id == "org.freedesktop.udisks.filesystem-mount-system-internal") &&
    subject.isInGroup("storage")) {
           return polkit.Result.YES;
        }
    });

Documentation
-------------

For a more thorough introduction and more advanced features, including
globbing, see the man pages of polkit and pklocalauthority:

    man polkit

    man pklocalauthority

See also
--------

-   ConsoleKit

Retrieved from
"https://wiki.archlinux.org/index.php?title=PolicyKit&oldid=244253"

Category:

-   Security
