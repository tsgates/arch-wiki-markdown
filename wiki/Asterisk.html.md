Asterisk
========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Asterisk is a complete PBX (private branch exchange) in software. It
runs on Linux, BSD, Windows and OS X and provides all of the features
you would expect from a PBX and more. Asterisk does voice over IP in
four protocols, and can interoperate with almost all standards-based
telephony equipment using relatively inexpensive hardware.

Asterisk provides voice-mail services with directory, call conferencing,
interactive voice response and call queuing. It has support for
three-way calling, caller ID services, ADSI, IAX, SIP, H.323 (as both
client and gateway), MGCP (call manager only) and SCCP/Skinny.

This article will show you how to configure a simple in house network
enabling us to use a SIP soft-phone to talk to another SIP soft-phone on
your LAN.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 SIP
    -   2.2 Music On Hold
    -   2.3 Voicemail
    -   2.4 Connecting To The PSTN
        -   2.4.1 General Set-up
            -   2.4.1.1 sip.conf
            -   2.4.1.2 extensions.conf
            -   2.4.1.3 iax.conf
            -   2.4.1.4 extensions.conf
    -   2.5 MeetMe
-   3 Asterisk Console And Softphones
-   4 Troubleshooting

Installation
------------

Install asterisk from the AUR. Start the server with

    # rc.d start asterisk

.

You may also want to install asterisk-addons, asterisk-sounds and
zaptel. You will also need a SIP soft-phone and at least two machines.
Recommendations for SIP phones are kphone, in the AUR and x-lite, a
binary package.

To enable ilbc codec support add the following to the very beginning of
the build section of the PKGBUILD

      cd ${srcdir}/${pkgname}-${pkgver}/contrib/scripts
      echo | ./get_ilbc_source.sh

Configuration
-------------

> SIP

Assuming your asterisk server is up and running, we will only need to
edit two files: sip.conf and extensions.conf. Change to your asterisk
configuration directory (should be /etc/asterisk). Edit sip.conf and
place the following:

    [me1]
    type=friend
    username=me1
    secret=PASSWORD
    host=dynamic
    context=house

    [me2]
    type=friend
    username=me2
    secret=PASSWORD
    host=dynamic
    context=house

This creates our two SIP users me1 and me2 with a password of PASSWORD
in the house context.

We will be defining the context next -- edit extensions.conf with the
following:

    [house]
    exten => 100,1,Dial(SIP/me1)

    exten => 101,1,Dial(SIP/me2)

This creates the context house and assigns extension 100 to the SIP user
me1, and extension 101 to the SIP user me2. Now all thats left is to see
if it works.

> Music On Hold

Music on hold is a really sweet feature. And once again easy to install
and configure. Edit /etc/asterisk/musiconhold.conf and add, or make sure
it is uncommented:

    [default]
    mode=files
    directory=/var/lib/asterisk/mohmp3

Now go into your sip.conf

    musiconhold=default

And that is all there is to it. Just copy your favorite legally obtained
MP3 to /var/lib/asterisk/mohmp3.

> Voicemail

Voicemail is another feature of asterisk. There are many ways to
configure it, however this article only covers a simple approach.

Create/edit your voicemail.conf:

    [general]
    format=gsm|wav49|wav
    serveremail=asterisk
    attach=no
    mailcmd=/usr/sbin/sendmail -t
    maxmessage=180
    maxgreet=60

    [default]
    100 => 1234,Me,me@mydomain.com

What does this mean? Most of the [general] is pretty self-explanatory.
However, do note that if you have postfix set up right the PBX will send
an email notifying the user of a new voice-mail and if attach=yes is
defined it will attach the file.

Now for the actual mailbox. The format is:

    mailbox => password,user,email

In this case, we gave 'Me' (email me@mydomain.com) mailbox 100, with a
password of 1234.

Now we have to have a way to leave messages to this voice-mail, and a
way to access it. For this, we go back to the extensions.conf and modify
your existing entry as follows:

    exten => 100,1,Dial(SIP/me1,20)
    exten =>100,2,Voicemail(100@default)

The 20 on the end of the first 'exten' tells 'Dial()' to call for 20
seconds. If no one answers it heads to voice-mail box 100 in the default
context.

Next is actually accessing your voicemail. For this we add:

    exten => 600,1,VoiceMailMain,s100@default

So when we call 600, the application 'VoiceMailMain' goes to 100 in the
default context. The s allows for automatic login.

Note:The 'VoiceMail' applications have a significant amount of options,
so it is suggested reading over some additional documentation. This is
just for a basic, home use setup. Also note that it is generally a good
idea to use extensions higher then your users extensions for accessing
'VoiceMail'. This way someone dialing 208 does not hit someone's
voice-mail at 205.

> Connecting To The PSTN

Now that you have the previous setup, it is time to actually connect to
the outside world. To do this, you will need a provider such as Junction
Networks. Your provider should have instructions on connecting to
asterisk, so this section is very general.

General Set-up

sip.conf

    [general]
    register => username:password@sip.specific.com

    [whatever]                   
    fromdomain=specific.com     
    host=sip.specific.com
    insecure=very    ; check with provider
    username=usernameduh
    secret=passwordduh
    type=peer

extensions.conf

    [outboundwithCID]  ; this can be whatever
    exten => _1NXXNXXXXXX,1,SetCIDNum(15555551234)
    exten => _1NXXNXXXXXX,2,Dial(SIP/${EXTEN}@whatever)
    exten => _1NXXNXXXXXX,3,Congestion()
    exten => _1NXXNXXXXXX,103,Busy()


    [default]  ; This should be set in your sip.conf for incoming calls

    ;These should to be changed to your actual number
    ; ie     15555555555
    exten => 1NXXNXXXXXX,1,Answer()
    exten => 1NXXNXXXXXX,2,Playback(ttt-weasels)
    exten => 1NXXNXXXXXX,3,HangUp()

-   In the outbound context, any number dialed will be sent out to your
    service provider. The 'whatever' in the 2 priority should match what
    you have in your sip.conf.
-   Of course, the inbound dial-plan can be modified to do what you
    want. For instance, you can have Dial(SIP/me1) so when someone calls
    your number they are routed to your SIP phone on your computer. Then
    add in voice-mail and so on.

iax.conf

The first step is to log into FWD and enable their side of IAX. It is
under extra features, and keep in mind that the authors claim it takes a
little while to activate.

Now edit your iax.conf with the following in the 'general' section:

    register => FWDNUMBER:PASSWORD@iax2.fwdnet.net 
    disallow = all
    allow = ulaw

And at the bottom add:

    [iaxfwd]
    type=user
    context=fromiaxfwd
    auth=rsa
    inkeys=freeworlddialup

This allows calls from FWD.

extensions.conf

Place this at the top under '[globals]':

    FWDNUMBER=MYFWDNUMBER ; your calling number
    FWDCIDNAME="MyName"; your caller id
    FWDPASSWORD=MYFWDPASSWORD ; your password
    FWDRINGS=sip/office ; the phone to ring
    FWDVMBOX=1000 ; the VM box for this user

Next, add this to a context for outgoing:

    exten => _393.,1,SetCallerId,${FWDCIDNAME}
    exten => _393.,2,Dial(IAX2/${FWDNUMBER}:${FWDPASSWORD}@iax2.fwdnet.net/${EXTEN:3},60,r)
    exten => _393.,3,Congestion

You can change the '393' to whatever you want. This is what you will
dial before dialing a 'fwd' number. For instance, to dial '744561' you
would dial '393744561'.

And lastly, the incoming calls:

    [fromiaxfwd]
    exten => ${FWDNUMBER},1,Dial(${FWDRINGS},20,r)
    exten => ${FWDNUMBER},2,Voicemail,u${FWDVMBOX}
    exten => ${FWDNUMBER},102,Voicemail,b${FWDVMBOX}

Note:If you have problems try removing the variables from
extensions.conf. These instructions are from FWD's site and I have not
been tested by this article's author.

Extensions to try calling are 55555 (a volunteer maned test line) and
514 (conference).

> MeetMe

MeetMe is the application that allows you to do conference calling. Same
as everything, basic setup is easy.

Edit meetme.conf:

    conf => 1000

Next is extensions.conf

    exten => 999,1,MeetMe(1000|M)

Now dial 999 to get into conference 1000. The <codeM></code> enables
music on hold if no one is in there. It will automatically go away when
someone joins the conference.

Note:You must have the zaptel package in order for MeetMe to work.
Install it and run modprobe ztdummy before running asterisk. This
provides digium timing for us without cards so we can utilize TDM.

Asterisk Console And Softphones
-------------------------------

Now lets get Asterisk going:

    # asterisk -vvvvvvc

This will give us the Asterisk CLI with verbose output. If Asterisk is
already running you will need to use:

    # asterisk -r

Now fire up your SIP clients and set them up with the information in the
sip.conf. Switch back to your Asterisk CLI and you should see:

    Registered SIP 'me1' at 192.168.0.142 port 5061 expires 60

Now you should be able to dial 101 from me1 and talk to me2.

Troubleshooting
---------------

If you receive a 404 Not Found error check your extensions.conf and the
number you dialed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Asterisk&oldid=290384"

Category:

-   Telephony and Voice

-   This page was last modified on 26 December 2013, at 02:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
