SSH Keys
========

SSH keys serve as a means of identifying yourself to an SSH server using
public-key cryptography and challenge-response authentication. One
immediate advantage this method has over traditional password
authentication is that you can be authenticated by the server without
ever having to send your password over the network. Anyone eavesdropping
on your connection will not be able to intercept and crack your password
because it is never actually transmitted. Additionally, using SSH keys
for authentication virtually eliminates the risk posed by brute-force
password attacks by drastically reducing the chances of the attacker
correctly guessing the proper credentials.

As well as offering additional security, SSH key authentication can be
more convenient than the more traditional password authentication. When
used with a program known as an SSH agent, SSH keys can allow you to
connect to a server, or multiple servers, without having to remember or
enter your password for each system.

SSH keys are not without their drawbacks and may not be appropriate for
all environments, but in many circumstances they can offer some strong
advantages. A general understanding of how SSH keys work will help you
decide how and when to use them to meet your needs. This article assumes
you already have a basic understanding of the Secure Shell protocol and
have installed the openssh package, available in the Official
Repositories.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Background                                                         |
| -   2 Generating an SSH key pair                                         |
|     -   2.1 Choosing the type of encryption                              |
|     -   2.2 Choosing the key location and passphrase                     |
|         -   2.2.1 Changing the private key's passphrase without changing |
|             the key                                                      |
|                                                                          |
| -   3 Copying the public key to the remote server                        |
|     -   3.1 Simple method                                                |
|     -   3.2 Traditional method                                           |
|                                                                          |
| -   4 Security                                                           |
|     -   4.1 Securing the authorized_keys file                            |
|     -   4.2 Disabling password logins                                    |
|                                                                          |
| -   5 SSH agents                                                         |
|     -   5.1 ssh-agent                                                    |
|     -   5.2 GnuPG Agent                                                  |
|     -   5.3 Keychain                                                     |
|         -   5.3.1 Alternate startup methods                              |
|                                                                          |
|     -   5.4 x11-ssh-askpass                                              |
|         -   5.4.1 Theming                                                |
|         -   5.4.2 Alternative passphrase dialogs                         |
|                                                                          |
|     -   5.5 pam_ssh                                                      |
|         -   5.5.1 Known issues with pam_ssh                              |
|                                                                          |
|     -   5.6 GNOME Keyring                                                |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 Using kdm                                                    |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Background
----------

SSH keys always come in pairs, one private and the other public. The
private key is known only to you and it should be safely guarded. By
contrast, the public key can be shared freely with any SSH server to
which you would like to connect.

When an SSH server has your public key on file and sees you requesting a
connection, it uses your public key to construct and send you a
challenge. This challenge is like a coded message and it must be met
with the appropriate response before the server will grant you access.
What makes this coded message particularly secure is that it can only be
understood by someone with the private key. While the public key can be
used to encrypt the message, it cannot be used to decrypt that very same
message. Only you, the holder of the private key, will be able to
correctly understand the challenge and produce the correct response.

This challenge-response phase happens behind the scenes and is invisible
to the user. As long as you hold the private key, which is typically
stored in the ~/.ssh/ directory, your SSH client should be able to reply
with the appropriate response to the server.

Because private keys are considered sensitive information, they are
often stored on disk in an encrypted form. In this case, when the
private key is required, a passphrase must first be entered in order to
decrypt it. While this might superficially appear the same as entering a
login password on the SSH server, it is only used to decrypt the private
key on the local system. This passphrase is not, and should not, be
transmitted over the network.

Generating an SSH key pair
--------------------------

An SSH key pair can be generated by running the ssh-keygen command:

    $ ssh-keygen -t ecdsa -b 521 -C "$(whoami)@$(hostname)-$(date -I)"

    Generating public/private ecdsa key pair.
    Enter file in which to save the key (/home/username/.ssh/id_ecdsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /home/username/.ssh/id_ecdsa.
    Your public key has been saved in /home/username/.ssh/id_ecdsa.pub.
    The key fingerprint is:
    dd:15:ee:24:20:14:11:01:b8:72:a2:0f:99:4c:79:7f username@localhost-2011-12-22
    The key's randomart image is:
    +--[ECDSA  521]---+
    |     ..oB=.   .  |
    |    .    . . . . |
    |  .  .      . +  |
    | oo.o    . . =   |
    |o+.+.   S . . .  |
    |=.   . E         |
    | o    .          |
    |  .              |
    |                 |
    +-----------------+

In the above example, ssh-keygen generates a 521 bit long (-b 521)
public/private ECDSA (-t ecdsa) key pair with an extended comment
including the data (-C "$(whoami)@$(hostname)-$(date -I)"). The
randomart image was introduced in OpenSSH 5.1 as an easier means of
visually identifying the key fingerprint.

> Choosing the type of encryption

The Elliptic Curve Digital Signature Algorithm (ECDSA) provides smaller
key sizes and faster operations for equivalent estimated security to the
previous methods. It was introduced as the preferred algorithm for
authentication in OpenSSH 5.7, see OpenSSH 5.7 Release Notes. ECDSA keys
might not be compatible with systems that ship old versions of OpenSSH.
Some vendors also disable the required implementations due to potential
patent issues.

Note:As of April 2013, the Windows SSH client PuTTY does not support
ECDSA and cannot connect to a server that uses ECDSA keys.

If you choose to create an RSA (768-16384 bit) or DSA (1024 bit) key
pair instead of ECDSA, use the -t rsa or -t dsa switches in your
ssh-keygen command and do not forget to increase the key size. Running
ssh-keygen without the -b switch should provide reasonable defaults.

Note:These keys are used only to authenticate you; choosing stronger
keys will not increase CPU load when transferring data over SSH.

> Choosing the key location and passphrase

Upon issuing the ssh-keygen command, you will be prompted for the
desired name and location of your private key. By default, keys are
stored in the ~/.ssh/ directory and named according the type of
encryption used. You are advised to accept the default name and location
in order for later code examples in this article to work properly.

When prompted for a passphrase, choose something that will be hard to
guess if you have the security of your private key in mind. A longer,
more random password will generally be stronger and harder to crack
should it fall into the wrong hands.

It is also possible to create your private key without a passphrase.
While this can be convenient, you need to be aware of the associated
risks. Without a passphrase, your private key will be stored on disk in
an unencrypted form. Anyone who gains access to your private key file
will then be able to assume your identity on any SSH server to which you
connect using key-based authentication. Furthermore, without a
passphrase, you must also trust the root user, as he can bypass file
permissions and will be able to access your unencrypted private key file
at any time.

Changing the private key's passphrase without changing the key

If the originally chosen SSH key passphrase is undesirable or must be
changed, one can use the ssh-keygen command to change the passphrase
without changing the actual key.

To change the passphrase for the private RSA key, run the following
command:

    $ ssh-keygen -f ~/.ssh/id_rsa -p

Copying the public key to the remote server
-------------------------------------------

Once you have generated a key pair, you will need to copy the public key
to the remote server so that it will use SSH key authentication. The
public key file shares the same name as the private key except that it
is appended with a .pub extension. Note that the private key is not
shared and remains on the local machine.

> Simple method

If your key file is ~/.ssh/id_rsa.pub you can simply enter the following
command.

    $ ssh-copy-id remote-server.org

If your username differs on remote machine, be sure to prepend the
username followed by @ to the server name.

    $ ssh-copy-id username@remote-server.org

If your public key filename is anything other than the default of
~/.ssh/id_rsa.pub you will get an error stating
/usr/bin/ssh-copy-id: ERROR: No identities found. In this case, you must
explicitly provide the location of the public key.

    $ ssh-copy-id -i ~/.ssh/id_ecdsa.pub username@remote-server.org

If the ssh server is listening on a port other than default of 22, be
sure to include it within the host argument.

    $ ssh-copy-id -i ~/.ssh/id_ecdsa.pub '-p 221 username@remote-server.org'

> Traditional method

By default, for OpenSSH, the public key needs to be concatenated with
~/.ssh/authorized_keys. Begin by copying the public key to the remote
server.

    $ scp ~/.ssh/id_ecdsa.pub username@remote-server.org:

The above example copies the public key (id_ecdsa.pub) to your home
directory on the remote server via scp. Do not forget to include the :
at the end of the server address. Also note that the name of your public
key may differ from the example given.

On the remote server, you will need to create the ~/.ssh directory if it
does not yet exist and append your public key to the authorized_keys
file.

    $ ssh username@remote-server.org
    username@remote-server.org's password:
    $ mkdir ~/.ssh
    $ cat ~/id_ecdsa.pub >> ~/.ssh/authorized_keys
    $ rm ~/id_ecdsa.pub
    $ chmod 600 ~/.ssh/authorized_keys

The last two commands remove the public key file from the server and set
the permissions on the authorized_keys file such that it is only
readable and writable by you, the owner.

Security
--------

> Securing the authorized_keys file

For additional protection, you can prevent users from adding new public
keys and connecting from them.

Make the authorized_keys file read-only for the user and deny all other
permissions:

    # chmod 400 ~/.ssh/authorized_keys

To keep the user from simply changing the permissions back, set the
immutable bit on the authorized_keys file:

    # sudo chattr +i ~/.ssh/authorized_keys

Now, the user could rename the ~/.ssh directory to something else and
create a new ~/.ssh directory and authorized_keys file. To prevent this,
set the immutable bit on the ~/.ssh directory

    # sudo chattr +i ~/.ssh

Note:If you find yourself needing to add a new key, you will first have
to remove the immutable bit from authorized_keys and make it writable.
Follow the steps above to secure it again.

> Disabling password logins

While copying your public key to the remote SSH server eliminates the
need to transmit your password over the network, it does not give any
added protection against a brute-force password attack. In the absence
of a private key, the SSH server will fall back to password
authentication by default, thus allowing a malicious user to attempt to
gain access by guessing your password. To disable this behavior, edit
the following lines in the /etc/ssh/sshd_config file on the remote
server.

    /etc/ssh/sshd_config

    PasswordAuthentication no
    ChallengeResponseAuthentication no

SSH agents
----------

If your private key is encrypted with a passphrase, this passphrase must
be entered every time you attempt to connect to an SSH server using
public-key authentication. Each individual invocation of ssh or scp will
need the passphrase in order to decrypt your private key before
authentication can proceed.

An SSH agent is a program which caches your decrypted private keys and
provides them to SSH client programs on your behalf. In this
arrangement, you must only provide your passphrase once, when adding
your private key to the agent's cache. This facility can be of great
convenience when making frequent SSH connections.

An agent is typically configured to run automatically upon login and
persist for the duration of your login session. A variety of agents,
front-ends, and configurations exist to achieve this effect. This
section provides an overview of a number of different solutions which
can be adapted to meet your specific needs.

> ssh-agent

ssh-agent is the default agent included with OpenSSH. It can be used
directly or serve as the back-end to a few of the front-end solutions
mentioned later in this section. When ssh-agent is run, it will fork
itself to the background and print out the environment variables it
would use.

    $ ssh-agent
    SSH_AUTH_SOCK=/tmp/ssh-vEGjCM2147/agent.2147; export SSH_AUTH_SOCK;
    SSH_AGENT_PID=2148; export SSH_AGENT_PID;
    echo Agent pid 2148;

To make use of these variables, run the command through the eval
command.

    $ eval $(ssh-agent)
    Agent pid 2157

You can append the above command to your ~/.bash_profile script so that
it will run automatically when starting a login shell.

    $ echo 'eval $(ssh-agent)' >> ~/.bash_profile

If you would rather have ssh-agent run automatically for all users
append the command to /etc/profile instead.

    # echo 'eval $(ssh-agent)' >> /etc/profile

Once ssh-agent is running, you will need to add your private key to its
cache.

    $ ssh-add ~/.ssh/id_ecdsa
    Enter passphrase for /home/user/.ssh/id_ecdsa:
    Identity added: /home/user/.ssh/id_ecdsa (/home/user/.ssh/id_ecdsa)

If you would like your private keys to be added automatically on login.
Append the following command to your ~/.bash_profile as well.

    $ echo 'ssh-add' >> ~/.bash_profile

If your private key is encrypted ssh-add will prompt you to enter your
passphrase. Once your private key has been successfully added to the
agent you will be able to make SSH connections without having to enter a
passphrase.

One downside to this approach is that a new instance of ssh-agent is
created for every login shell and each instance will persist between
login sessions. Over time you can wind up with dozens of needless
ssh-agent processes running. There exist a number of front-ends to
ssh-agent and alternative agents described later in this section which
avoid this problem.

> GnuPG Agent

Note:The stock gnupg Arch Linux package does not support ECC encryption
and signing. Hence you cannot use the GnuPG agent to manage ECDSA keys.

The GnuPG agent, distributed with the gnupg package, available in the
official repositories, has OpenSSH agent emulation. If you use GPG you
might consider using its agent to take care of all of your keys.
Otherwise you might like the PIN entry dialog it provides and its
passphrase management, which is different from Keychain.

To start using GPG agent for your SSH keys you should first start the
gpg-agent with the --enable-ssh-support option. Example (do not forget
to make the file executable):

    /etc/profile.d/gpg-agent.sh

    #!/bin/sh

    # Start the GnuPG agent and enable OpenSSH agent emulation
    gnupginf="${HOME}/.gpg-agent-info"

    if pgrep -u "${USER}" gpg-agent >/dev/null 2>&1; then
        eval `cat $gnupginf`
        eval `cut -d= -f1 $gnupginf | xargs echo export`
    else
        eval `gpg-agent -s --enable-ssh-support --daemon`
    fi

Once gpg-agent is running you can use ssh-add to approve keys, just like
you did with plain ssh-agent. The list of approved keys is stored in the
~/.gnupg/sshcontrol file. Once your key is approved you will get a PIN
entry dialog every time your passphrase is needed. You can control
passphrase caching in the ~/.gnupg/gpg-agent.conf file. The following
example would have gpg-agent cache your keys for 3 hours:

    ~/.gnupg/gpg-agent.conf

      # Cache settings
      default-cache-ttl 10800
      default-cache-ttl-ssh 10800

Other useful settings for this file include the PIN entry program (GTK,
QT or ncurses version), keyboard grabbing and so on...:

Note:gpg-agent.conf must be created and the variable 'write-env-file'
must be set in order to allow gpg-agent keys to be injected to SSH
across logins. (Unless you restart the gpg-agent, and therefore export
its settings, with every login.)

    ~/.gnupg/gpg-agent.conf

      # Environment file
      write-env-file /home/username/.gpg-agent-info
      
      # Keyboard control
      #no-grab
        
      # PIN entry program
      #pinentry-program /usr/bin/pinentry-curses
      #pinentry-program /usr/bin/pinentry-qt4
      #pinentry-program /usr/bin/pinentry-kwallet
      pinentry-program /usr/bin/pinentry-gtk-2

> Keychain

Keychain is a program designed to help you easily manage your SSH keys
with minimal user interaction. It is implemented as a shell script which
drives both ssh-agent and ssh-add. A notable feature of Keychain is that
it can maintain a single ssh-agent process across multiple login
sessions. This means that you only need to enter your passphrase once
each time your local machine is booted.

Install the keychain package, available from the Official Repositories.

Append the following line to ~/.bash_profile, or create
/etc/profile.d/keychain.sh as root and make it executable (e.g.
chmod 755 keychain.sh):

    ~/.bash_profile

    eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)

In the above example, the --eval switch outputs lines to be evaluated by
the opening eval command. This sets the necessary environments variables
for SSH client to be able to find your agent. The --agents switch is not
strictly necessary, because Keychain will build the list automatically
based on the existence of ssh-agent or gpg-agent on the system. Adding
the --quiet switch will limit output to warnings, errors, and user
prompts. If you want greater security replace -Q with --clear but will
be less convenient.

If necessary, replace ~/.ssh/id_ecdsa with the path to your private key.
For those using a non-Bash compatible shell, see keychain --help or
man keychain for details on other shells.

To test Keychain, log out from your session and log back in. If this is
your first time running Keychain, it will prompt you for the passphrase
of the specified private key. Because Keychain reuses the same ssh-agent
process on successive logins, you shouldn't have to enter your
passphrase the next time you log in. You will only ever be prompted for
your passphrase once each time the machine is rebooted.

Alternate startup methods

There are numerous ways in which Keychain can be invoked and you are
encouraged to experiment to find a method that works for you. The
keychain command itself comes with dozens of command-line options which
are described in the Keychain man page.

One alternative implementation of a Keychain startup script could be to
create the file /etc/profile.d/keychain.sh as the root user and add the
following lines.

    /etc/profile.d/keychain.sh

    /usr/bin/keychain -Q -q --nogui ~/.ssh/id_ecdsa
    [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && source $HOME/.keychain/$HOSTNAME-sh

Be sure to also make /etc/profile.d/keychain.sh executable by changing
its file permissions.

    # chmod 755 /etc/profile.d/keychain.sh

If you do not want to get asked for your passphrase every time you login
but rather the first time you actually attempt to connect, you may add
the following to your .bashrc:

    alias ssh='eval $(/usr/bin/keychain --eval --agents ssh -Q --quiet ~/.ssh/id_ecdsa) && ssh'

This will ask you if you try to use ssh for the first time. Remember
however that this will ONLY ask you if .bashrc is applicable. So you
would always have your first ssh-command to be executed in a terminal.

> x11-ssh-askpass

The x11-ssh-askpass package provides a graphical dialog for entering
your passhrase when running an X session. x11-ssh-askpass depends only
the libx11 and libxt libraries, and the appearance of x11-ssh-askpass is
customizable. While it can be invoked by the ssh-add program which will
then load your decrypted keys into ssh-agent, the following instructions
will instead configure x11-ssh-askpass to be invoked by the
aforementioned Keychain script.

Install keychain and x11-ssh-askpass, both available in the Official
Repositories.

Edit your ~/.xinitrc file to include the lines highlighted in bold,
replacing the name and location of your private if necessary. Be sure to
place these commands before the line which invokes your window mananger.

    ~/.xinitrc

    keychain ~/.ssh/id_ecdsa
    [ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
    [ -f ~/.keychain/$HOSTNAME-sh-gpg ] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
    ...
    exec openbox-session

In the above example, the first line invokes keychain and passes the
name and location of your private key. If this is not the first time
keychain was invoked, the following two lines load the contents of
$HOSTNAME-sh and $HOSTNAME-sh-gpg if they exist. These files store the
environment variables of the previous instance of keychain.

Theming

The appearance of the x11-ssh-askpass dialog can be customized by
setting its associated X resources. The x11-ssh-askpass homepage
presents some example example themes. See the x11-ssh-askpass man page
for full details.

Alternative passphrase dialogs

There are other passphrase dialog programs which can be used instead of
x11-ssh-askpass. The following list provides some alternative solutions.

-   ksshaskpass is available in the Official Repositories. It is
    dependent on kdelibs and is suitable for the KDE Desktop
    Environment.

-   openssh-askpass depends on the qt4 libraries, and is available from
    the Official Repositories.

> pam_ssh

The pam_ssh project exists to provide a Pluggable Authentication Module
(PAM) for SSH private keys. This module can provide single sign-on
behavior for your SSH connections. On login, your SSH private key
passphrase can be entered in place of, or in addition to, your
traditional system password. Once you have been authenticated, the
pam_ssh module spawns ssh-agent to store your decrypted private key for
the duration of the session.

To enable single sign-on behavior at the tty login prompt, install the
unofficial pam_ssh package, available in the Arch User Repository.

Edit the /etc/pam.d/login configuration file to include the text
highlighted in bold in the example below. The order in which these lines
appear is significiant and can affect login behavior.

Warning:Misconfiguring PAM can leave the system in a state where all
users become locked out. Before making any changes, you should have an
understanding of how PAM configuration works as well as a backup means
of accessing the PAM configuration files, such as an Arch Live CD, in
case you become locked out and need to revert any changes. An IBM
developerWorks article is available which explains PAM configuration in
further detail.

    /etc/pam.d/login

    #%PAM-1.0

    auth       required     pam_securetty.so
    auth       requisite    pam_nologin.so
    auth       sufficient   pam_ssh.so
    auth       include      system-local-login
    account    include      system-local-login
    session    include      system-local-login
    session    optional     pam_ssh.so

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: The below        
                           paragraph has not been   
                           properly updated for     
                           pambase=20120701-1.      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

In the above example, login uses the pam_ssh module to check the entered
password against the user's SSH private key passphrase. If the password
matches, the user is immediately authenticated and granted access to the
system. If the password does not match, control falls to the pam_unix
module included via the /etc/pam.d/system-local-login file. The pam_unix
module provides traditional system password authentication. Note,
however, that the line which actually calls the pam_unix module resides
in /etc/pam.d/system-auth and this file is referenced in
/etc/pam.d/login through a series of "include" control flags. Because
the pam_unix module is passed the try_first_pass option, it first checks
the previously entered password against the /etc/passwd file instead of
prompting for a password again if the pam_ssh authentication failed. In
this way, the use of pam_ssh will be transparent to users without an SSH
private key.

If you use another means of logging in, such as an X11 display manager
like SLiM or XDM and you would like it to provide similar functionality,
you must edit its associated PAM configuration file in a similar
fashion. Packages providing support for PAM typically place a default
configuration file in the /etc/pam.d/ directory.

Further details on how to use pam_ssh and a list of its options can be
found in the pam_ssh man page.

Known issues with pam_ssh

Work on the pam_ssh project is infrequent and the documentation provided
is sparse. You should be aware of some of its limitations which are not
mentioned in the package itself.

-   SSH keys employing the newer option of ECDSA (elliptic curve)
    cryptography do not appear to be supported by pam_ssh. You must use
    either RSA or DSA keys.

-   The ssh-agent process spawned by pam_ssh does not persist between
    user logins. If you like to keep a GNU Screen session active between
    logins you may notice when reattaching to your screen session that
    it can no longer communicate with ssh-agent. This is because the GNU
    Screen environment and those of its children will still reference
    the instance of ssh-agent which existed when GNU Screen was invoked
    but was subsequently killed in a previous logout. The Keychain
    front-end avoids this problem by keeping the ssh-agent process alive
    between logins.

> GNOME Keyring

If you use the GNOME desktop, the GNOME Keyring tool can be used as an
SSH agent. Visit the GNOME Keyring article.

Troubleshooting
---------------

If it appears that the SSH server is ignoring your keys, ensure that you
have the proper permissions set on all relevant files.  
 For the local machine:

    $ chmod 700 ~/
    $ chmod 700 ~/.ssh
    $ chmod 600 ~/.ssh/id_ecdsa

For the remote machine:

    $ chmod 700 ~/
    $ chmod 700 ~/.ssh
    $ chmod 600 ~/.ssh/authorized_keys

If that does not solve the problem you may try temporarily setting
StrictModes to no in sshd_config. If authentication with StrictModes off
is successful, it is likely an issue with file permissions persists.

Tip:Do not forget to set StrictModes to yes for added security.

Make sure the remote machine supports the type of keys you are using.
Try using RSA or DSA keys instead #Generating an SSH key pair

    Some servers do not support ECDSA keys. 

Failing this, run the sshd in debug mode and monitor the output while
connecting:

    # /usr/sbin/sshd -d

> Using kdm

It appears that kdm doesn't launch the ssh-agent process directly. You
need to install the kde-agent.

See also
--------

-   OpenSSH key management, Part 1
-   OpenSSH key management, Part 2
-   OpenSSH key management, Part 3
-   Getting started with SSH
-   OpenSSH 5.7 Release Notes

Retrieved from
"https://wiki.archlinux.org/index.php?title=SSH_Keys&oldid=253314"

Category:

-   Secure Shell
