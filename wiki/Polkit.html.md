Polkit
======

Related articles

-   Sudo
-   Users and groups

From polkit homepage:

polkit is an application-level toolkit for defining and handling the
policy that allows unprivileged processes to speak to privileged
processes: It is a framework for centralizing the decision making
process with respect to granting access to privileged operations for
unprivileged applications.

Polkit is used for controlling system-wide privileges. It provides an
organized way for non-privileged processes to communicate with
privileged ones. In contrast to systems such as sudo, it does not grant
root permission to an entire process, but rather allows a finer level of
control of centralized system policy.

Polkit works by delimiting distinct actions, e.g. running GParted, and
delimiting users by group or by name, e.g. members of the wheel group.
It then defines how – if at all – those users are allowed those actions,
e.g. by identifying as members of the group by typing in their
passwords.

Contents
--------

-   1 Installation
    -   1.1 Authentication agents
-   2 Structure
    -   2.1 Actions
    -   2.2 Authorization rules
        -   2.2.1 Administrator identities
-   3 Limitations
-   4 Examples
    -   4.1 Disable suspend and hibernate
    -   4.2 Allow mounting a filesystem on a system device for a group
    -   4.3 Allow mounting a filesystem on a system device for any user
    -   4.4 Allow unlocking an encrypted filesystem on a system device
-   5 See also

Installation
------------

Polkit can be installed with the package polkit, available in the
official repositories.

> Authentication agents

An authentication agent is used to make the user of a session prove that
the user of the session really is the user (by authenticating as the
user) or an administrative user (by authenticating as an administrator).
The polkit package contains a textual authentication agent called
'pkttyagent', which is used as a general fallback.

If you are using a graphical environment, make sure that a graphical
authentication agent installed and autostarted. Cinnamon, GNOME, MATE,
KDE and LXDE have an authentication agent already.

In other desktop environments, you have to choose one of the following
implementations:

-   lxpolkit, which provides /usr/lib/lxpolkit/lxpolkit
-   mate-polkit, which provides
    /usr/lib/polkit-mate/polkit-mate-authentication-agent-1
-   polkit-gnome, which provides
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
-   polkit-kde, which provides
    /usr/lib/kde4/libexec/polkit-kde-authentication-agent-1

Make sure that its executable is autostarted on login.

Structure
---------

Polkit definitions can be divided into two kinds:

-   Actions are defined in XML .policy files located in
    /usr/share/polkit-1/actions. Each action has a set of default
    permissions attached to it (e.g. you need to identify as an
    administrator to use the GParted action). The defaults can be
    overruled but editing the actions files is NOT the correct way.
-   Authorization rules are defined in JavaScript .rules files. They are
    found in two places: 3rd party packages can use
    /usr/share/polkit-1/rules.d (though few if any do) and
    /etc/polkit-1/rules.d is for local configuration. The .rules files
    designate a subset of users, refer to one (or more) of the actions
    specified in the actions files and determine with what restrictions
    these actions can be taken by that/those user(s). As an example, a
    rules file could overrule the default requirement for all users to
    authenticate as an admin when using GParted, determining that some
    specific user doesn't need to. Or isn't allowed to use GParted at
    all.

> Actions

The actions available to you via polkit will depend on the packages you
have installed. Some are used in multiple desktop environments
(org.freedesktop.*), some are DE-specific (org.gnome.*) and some are
specific to a single program (org.archlinux.pkexec.gparted.policy). The
command pkaction lists all the actions defined in
/usr/share/polkit-1/actions for quick reference.

To get an idea of what polkit can do, here are a few commonly used
groups of actions:

-   systemd-logind (org.freedesktop.login1.policy) actions regulated by
    polkit include powering off, rebooting, suspending and hibernating
    the system, including when other users may still be logged in.
-   udisks (org.freedesktop.udisks2.policy) actions regulated by polkit
    include mounting file systems and unlocking encrypted devices.
-   NetworkManager (org.freedesktop.NetworkManager.policy) actions
    regulated by polkit include turning on and off the network, wifi or
    mobile broadband.

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
        <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/gparted</annotate>
        <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
      </action>

    </policyconfig>

The attribute id is the actual command sent to D-Bus, the message tag is
the explanation to the user when authentication is required and the
icon_name is sort of obvious.

The default tag is where the permissions or lack thereof are located. It
contains three settings: allow_any, allow_inactive, and allow_active.
Inactive sessions are generally remote sessions (SSH, VNC, etc.) whereas
active sessions are logged directly into the machine on a TTY or an X
display. allow_any is the setting encompassing both scenarios.

For each of these settings the following options are available:

-   no: The user is not authorized to carry out the action. There is
    therefore no need for authentication.
-   yes: The user is authorized to carry out the action without any
    authentication.
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

> Authorization rules

Authorization rules that overrule the default settings are laid out in a
set of directories as described above. For all purposes relating to
personal configuration of a single system, only /etc/polkit-1/rules.d
should be used.

The addRule() method is used for adding a function that may be called
whenever an authorization check for action and subject is performed.
Functions are called in the order they have been added until one of the
functions returns a value. Hence, to add an authorization rule that is
processed before other rules, put it in a file in /etc/polkit-1/rules.d
with a name that sorts before other rules files, for example
00-early-checks.rules.

The layout of the .rules files is fairly self-explanatory:

    /* Allow users in admin group to run GParted without authentication */
    polkit.addRule(function(action, subject) {
        if (action.id == "org.archlinux.pkexec.gparted" &&
            subject.isInGroup("admin")) {
            return polkit.Result.YES;
        }
    });

Inside the function, we check for the specified action ID
(org.archlinux.pkexec.gparted) and for the user's group (admin), then
return a value "yes".

Administrator identities

The addAdminRule() method is used for adding a function may be called
whenever administrator authentication is required. The function is used
to specify what identities may be used for administrator authentication
for the authorization check identified by action and subject. Functions
added are called in the order they have been added until one of the
functions returns a value.

The default configuration for administrator identities is contained in
the file 50-default.rules so any changes to that configuration should be
made by copying the file to, say, 40-default.rules and editing that
file.

    /etc/polkit-1/rules.d/50-default.rules

    polkit.addAdminRule(function(action, subject) {
        return ["unix-group:wheel"];
    });

The only part to edit (once copied) is the return array of the function:
as whom should a user authenticate when asked to authenticate as an
administrative user? If she herself is a member of the group designated
as admins, she only need enter her own password. If some other user,
e.g. root, is the only admin identity, she would need to enter in root's
password. The format of the user identification is the same as the one
used in designating authorities. The Arch default is to make all members
of the group wheel administrators.

Limitations
-----------

Polkit operates on top of the existing permissions systems in Linux –
group membership, administrator status – it does not replace them. The
example above prohibited the user jack from using the GParted action,
but it does not preclude him running GParted by some means that do not
respect polkit, e.g. the command line. Therefore it's probably better to
use polkit to expand access to privileged services for unprivileged
users, rather than to try using it to curtail the rights of
(semi-)privileged users. For security purposes, the sudoers file is
still the way to go.

Examples
--------

> Disable suspend and hibernate

The following rule disables suspend and hibernate for all users.

    /etc/polkit-1/rules.d/10-disable-suspend.rules

    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions") {
            return polkit.Result.NO;
        }
    });

> Allow mounting a filesystem on a system device for a group

The following rule enables mounting a filesystem on a system device for
the storage group.

    /etc/polkit-1/rules.d/10-enable-mount.rules

    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" && subject.isInGroup("storage")) {
            return polkit.Result.YES;
        }
    });

> Allow mounting a filesystem on a system device for any user

The following rule enables mounting a filesystem on a system device for
any user.

    /etc/polkit-1/rules.d/10-enable-mount.rules

    polkit.addRule(function(action) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system") {
            return polkit.Result.YES;
        }
    });

> Allow unlocking an encrypted filesystem on a system device

The following rule enables unlocking an encrypted filesystem on a system
device for the storage group.

    /etc/polkit-1/rules.d/20-enable-unlocking-encrypted.rules

    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.encrypted-unlock-system" && subject.isInGroup("storage")) {
            return polkit.Result.YES;
        }
    });

See also
--------

-   Polkit manual page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Polkit&oldid=301838"

Category:

-   Security

-   This page was last modified on 24 February 2014, at 16:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
