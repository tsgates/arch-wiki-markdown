Small Business Server (Italiano)/Mail Server
============================================

Ad un SBS che si rispetti non può certo mancare un servizio di posta
elettronica, anche considerando il fatto che ancor oggi è il servizio
internet più usato. E noi da bravi andiamo a configurarne uno semplice
ma abbastanza completo. Questa parte è abbastanza articolata, facciamo
una piccola premessa ed installiamo il software necessario.

Contents
--------

-   1 Premessa
    -   1.1 Un lavoro di squadra
-   2 Installazione
    -   2.1 Postfix
    -   2.2 Postgrey
    -   2.3 Clamav
    -   2.4 Spamassassin
    -   2.5 Amavis-new
    -   2.6 Dovecot
-   3 Il giochino delle parti
-   4 Configurazione base
    -   4.1 Postfix
        -   4.1.1 Parametri di configurazione
            -   4.1.1.1 myhostname e mydomain
            -   4.1.1.2 myorigin
            -   4.1.1.3 mydestination
            -   4.1.1.4 mynetworks
            -   4.1.1.5 masquerade_domains
            -   4.1.1.6 alias_maps e alias_database
            -   4.1.1.7 mailbox_size_limit
            -   4.1.1.8 home_mailbox
        -   4.1.2 Testare Postfix
        -   4.1.3 Aliases
        -   4.1.4 Avvio del servizio
    -   4.2 Dovecot
        -   4.2.1 Configurazione
        -   4.2.2 Autenticazione
        -   4.2.3 Avvio del servizio
    -   4.3 Shorewall
        -   4.3.1 Configurazione
        -   4.3.2 La regola più importante
    -   4.4 Tutto qua ?
-   5 Filtraggio della posta
    -   5.1 Postfix
        -   5.1.1 Restrizioni nei comandi HELO o EHLO
        -   5.1.2 Restrizioni a cui sono soggetti i server remoti per i
            comandi inviati
        -   5.1.3 Restrizioni sui mittenti delle mail che il server
            riceve
        -   5.1.4 Restrizioni nei destinatari finali delle mail che il
            nostro server riceve
        -   5.1.5 Test delle restrizioni
            -   5.1.5.1 soft_bounce
            -   5.1.5.2 warn_if_reject
    -   5.2 Postgrey
        -   5.2.1 Configurazione
        -   5.2.2 Il giochino di Postgrey
        -   5.2.3 Controindicazioni ?
    -   5.3 Amavis-new
        -   5.3.1 Content Filter con Amavis-new
        -   5.3.2 Un caporale con due soldati
        -   5.3.3 Postfix
        -   5.3.4 Amavis
        -   5.3.5 Clamav
        -   5.3.6 Avvio dei servizi
-   6 Conclusioni

Premessa
========

Il mail server che andremo ad implementare è un mail server ufficiale.
Questo significa che :

1.  Il nostro ipotetico dominio mede.it deve essere pubblicamente
    registrato
2.  L'interfaccia eth0 che si collega al mondo esterno deve avere un
    indirizzo ip fisso
3.  Il maintainer del nostro dominio, se gestisce anche il DNS
    "pubblico" di mede.t, deve avere un record MX che punta al nostro
    server per informare il mondo che il server di posta "ufficiale" di
    mede.it siamo noi.

Se non disponiamo di un indirizzo ip fisso esiste anche una seconda
possibilità. Possiamo configurare il server in modalità relay. Senza
perderci in troppe ciance diciamo che in questa modalità il nostro
server non contatta direttamente i server SMTP destinatari, ma "passa"
la posta al nostro server "ufficiale" (che presumibilmente stà dal
nostro provider) che si occuperà del resto. I messaggi di posta interna
all'azienda (ad esempio antonio@mede.it che scrive a lucia@mede.it) non
usciranno all'esterno ma verranno trattati completamente dal nostro
server. Il problema qui è che poi dobbiamo andarci a prendere la posta
in arrivo dal server del provider se vogliamo distribuirla ai nostri
utenti. Magari faremo un articoletto anche su questo.

Un lavoro di squadra
--------------------

La complessità di questa parte non è tanto il server SMTP/POP3 in sè da
implementare (cosa relativamente banale) ma il ping pong dei diversi
servizi coinvolti in un moderno Mail Server. Purtroppo dobbiamo cercare
di difenderci da virus e spam se vogliamo dare un servizio decente e far
sopravvivere il nostro server per più di qualche giorno prima di venire
bannati dagli altri. Il nostro MTA non fà tutto da solo, bisogna mettere
in scena un coretto a 6 voci, dove 5 si passano la patata bollente l'un
l'altro per convalidare una mail in arrivo. La 6° (dovecot) recapita la
mail all'utente finale quando ne fà richiesta. Vediamo quali sono i
nostri interpreti:

1.  Postfix : Il nostro MTA che implementa il server SMTP della nostra
    azienda
2.  Postgrey : Servizio che implementa il greylisting
3.  Clamav : L'antivirus usato da amavis-new per scanarizzare le mail
4.  Spamassassin : Usato da amavis-new per individuare lo spam
5.  Amavis-new : Il content filter che analizza le mail con Clamav e
    SpamAssassin
6.  Dovecot : IMAP e POP3 server per permettere ai nostri utenti di
    scaricare le mail dal server

Un bel coretto non c'è che dire ...

Installazione
=============

Iniziamo con l'installazione dei servizi, poi andremo a configurarli uno
ad uno.

Postfix
-------

    sudo pacman -S postfix

controlliamo ora che il file /etc/passwd contenga :

    postfix:x:73:73::/var/spool/postfix:/bin/false

e che /etc/group contenga :

    postdrop:x:75:
    postfix:x:73:

Postgrey
--------

Postgrey non è presente nei repo standard, lo dobbiamo prelevare da AUR.
Prima installamo i moduli perl necessari :

    sudo pacman -S perl-net-server perl-berkeleydb perl-io-multiplex 

e ora il pacchetto da AUR

    yaourt -S postgrey

N.B. La prima volta che l'ho installato ho dovuto modificare il PKGBUILD
perchè puntasse ai sorgente esatti. Ora sembra ok, ma comunque occhio
all'output di yaourt.

Clamav
------

    sudo pacman -S clamav

Spamassassin
------------

    sudo pacman -S spamassassin

Amavis-new
----------

Nemmeno Amavis è nei repo. Per fortuna, ancora una volta, ci aiuta AUR.
Assicuriamoci di avere i pacchetti "make" e "patch" installati :

    # pacman -S make patch

E procediamo con Amavis, operazione lunga perchè richiede numerose
librerie perl da installare.

    # yaourt -S amavisd-new

Alla fine rientra in gioco il mio repository radioattivo.

    # pacman -S --force stenoweb/perl-file-temp

Amavis vuole "espressamente" la versione 0.19 di perl-file-temp. Noi
siamo gentili e gliela forniamo.

Dovecot
-------

    sudo pacman -S dovecot

Il giochino delle parti
=======================

Bene, ora il software necessario è installato. Come funzionarà il
tutto ? E' un bel balletto, vediamolo a grandi linee. Quando un
messaggio arriva al nostro MTA succederà questo:

1.  Postfix controlla che mittente e destinatario soddisfino le sue
    impostazioni di sicurezza. Se non le soddisfano Postfix respinge la
    mail, se le soddisfano passa la palla a Postgrey
2.  Postgrey analizza il mittente e risponde a Postfix con un esito
    positivo o negativo
3.  Se la risposta di Postgrey è negativa Postfix respinge la mail, se è
    positiva passa la palla ad Amavis
4.  Amavis chiama Clamav per il controllo antivirus. Se Clamav trova un
    virus Amavis dà esito negativo a Postfix che respinge la mail,
    altrimenti, sempre Amavis, chiama Spamassassin per il controllo
    antispam.
5.  Se Spamassassin giudica la mail come Spam, Amavis risponde con esito
    negativo a Postfix che respinge la mail.
6.  Se Amavis dopo il controlli antivirus e antispam dà esito positivo,
    Postfix recapita la mail sulla mailbox dell'utente destinatario.

Uff, un bel giro in giostra fà la nostra mail ! Tutto questo ha un costo
in performance, ma per evitare il più possibile spazzatura o infezioni
ne vale la pena... IL termina "respinge" che ho usato è generico, in
realtà la mail può venire anche archiviata e segnalata, oppure
recapitata lo stesso all'utente finale con una avviso. Stà a noi
decidere il comportamento che più ci soddisfa.

Configurazione base
===================

Postfix
-------

Iniziamo la configurazione del nostro Mail Server. Il primo tassello è
senza dubbio Postfix il nostro (mio?) MTA preferito. Forse il fatto che
ci sia IBM all'origine ha per me il suo peso ? Bando alle ciance e via
con i lavori ...

Postfix è un popolare, scalabile e sicuro MTA scritto da Witse Venema
mentre lavorava in IBM. Postfix era originariamente noto come VMailer ed
è stato anche commercializzato da IBM come Secure Mailer. Nel 1999, il
suo nome è diventato Postfix, e il resto è storia. In questa guida l'ho
scelto perchè è affidabile, veloce e (relativamente) facile da gestire.
Il suo file di configurazione è facile da leggere e modificare, anche se
ovviamente è utile conoscere le diverse opzioni che è possibile
impostare e tutti i loro valori possibili (o almeno i principali vista
la mole degli stessi...). Sono stati scritti libri interi su Postfix,
quindi inutile sottolineare che questo è solo un buon punto di partenza.

> Parametri di configurazione

Abbiamo già installato Postfix, ora procediamo con la configurazione
base che si ottiene modificando il file /etc/postfix/main.cf, iniziamo
da qui :

    sudo nano /etc/postfix/main.cf

con questi parametri :

    queue_directory = /var/spool/postfix
    command_directory = /usr/sbin
    daemon_directory = /usr/lib/postfix
    mail_owner = postfix

myhostname e mydomain

Definiamo il nome host internet del nostro server, di default il primo è
il valore ritornato da gethostbyname(), il secondo il nome del dominio :

    myhostname = archi.mede.it
    mydomain = mede.it

myorigin

Questo identifica i nomi di dominio da cui si assume che le mail locali
arrivino e sono inviate. E' più difficile da spiegare che da
scrivere :). Dal momento che noi non abbiamo bisogno di domini multipli,
impostiamo questo parametro uguale a mydomain.

    myorigin = $mydomain

mydestination

La lista dei domini verso i quali le mail sono inviate localmente.
Insomma, per queste destinazioni le mail vengono considerate locali e
trasferite alle caselle di posta locali.

    mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

mynetworks

Questo identifica le reti (o gli specifici host), che invieranno posta
da questo server. Di default Postfix riceve le mail da tutte le
interfacce di rete installate, ma permette di inviare solo dalla
interfaccia di loopback (127.0.0.1) che, nel nostro caso, non và
ovviamente bene. Il valore del parametro mynetworks può essere un
singolo host, un indirizzo IP e la maschera di rete per indicare un
range di host o di una sottorete, o qualsiasi numero di host separati da
virgola o indirizzo IP e associati netmasks. Questo parametro è molto
importante, deve essere presente e deve contenere SOLO la rete o gli
host autorizzati, altrimenti il vostro server si trasforma in un open
relay, ovvero un server attraverso cui chiunque può inviare mail. Gli
open relay sono il bersaglio preferito dagli spammers, e sono, per
fortuna, una razza quasi estinta (gli OpenRelay, non gli Spammers ...).
Nel nostro caso il mail server permetterà alla rete interna 192.168.20.*
di inviare mail attraverso di esso:

    mynetworks = 127.0.0.0/8, 192.168.20.0/24

masquerade_domains

Ora i nostri utenti di rete invieranno mail ma molti client di posta
inviano la mail usando il fully qualified domain name dell'host da cui
inviano la mail. Per capirci meglio: se il mio host si chiama mybox e il
mio utente steno chi riceve le mail che spedisco vede il mittente nella
forma steno@mybox.mede.it che non è esattamente quello che voglio.
Probabilmente non ho nemmeno un utente in quell'host e non riusciranno a
rispondere alle mie mail. Risolviamo questo problema con il parametro
masquerade_domains. Postfix sostitusce la parte domain con quanto
specificato qui.

    masquerade_domains = mede.it

Ora tutti gli host della mia rete possono inviare mail attraverso Posfix
senza che venga identificato il nome dello specifico host che ha
originato la mail. Le mail inviate dal mio host di esempio avranno come
mittente steno@mede.it.

alias_maps e alias_database

Generalmente coincidono e indicano l'organizzazione e il nome del file
contenenti gli alias locali: un elenco di equivalenze che permettono di
attribuire più indirizzi a un unico utente

    alias_maps = hash:/etc/postfix/aliases
    alias_database = $alias_maps

mailbox_size_limit

Massima dimensione delle mailbox. In questo caso 0 (zero) specifica
nessun limite.

    mailbox_size_limit = 0

home_mailbox

Specifica dove verrà salvata la posta dell'utente relativamente alla
propria home. Se non specifico nulla viene usato il formato mbox e
salvato un file con il nome utente in /var/spool/mail. Io preferisco il
formato Maildir, e specificando il seguente parametro ogni mail ricevuta
crea un file in /home/nomeutente/Maildir

    home_mailbox = Maildir/

Maggiori informazioni le trovate sul sito di postfix.

> Testare Postfix

Avviamo postfix per fare un test se tutto funziona regolarmente :

    sudo /etc/rc.d/postfix start

Installiamo telnet e colleghiamoci con sulla porta 25

    sudo pacman -S netkit-telnet
    telnet localhost 25

Dovrei ottenere la risposta:

    Trying 127.0.0.1...
    Connected to archi.
    Escape character is '^]'.
    220 archi.mede.it ESMTP Postfix

Ora iniziamo il colloquio :

    helo 192.168.20.10

Postfix risponde:

    250 archi.mede.it

Continuiamo a scrivere (dopo ogni riga premete invio) :

    mail from:test@gmail.com
    rcpt to: admin@mede.it
    data
    subject: Mail di prova
    Salve, ti mando una mail di prova
    .

Dopo il "." Postfix dovrebbe rispondermi con qualcosa di simile:

    250 2.0.0 Ok: queued as 13BF410D898D

Il numerone 13BF410D898D è un numero random che cambia ogni volta. Ora
digitando:

    quit

Si esce. Se non avete ricevuto errori siete a posto. Magari guardiamo se
admin ha ricevuto la mail, per ora ci accontentiamo di guardare il file
con il nostro editor. Andiamo in /home/admin/Maildir/new e dovrei vedere
un file di testo che posso editare e/o visualizzare. Ad esempio :

    sudo nano /home/admin/Maildir/new/1198938050.V803I22110bM48209.archi

E' la mail che avete appena inviato ? :)

> Aliases

Abbiamo configurato postfix perchè usi il file /etc/postfix/aliases per
gli alias, facciamo una piccola modifica al file perchè mandi le mail di
sistema al nostro utente admin anzichè al predefinito (che abbiamo
disabilitato) root.

    sudo nano /etc/postfix/aliases

All'inizio del file dovrei vedere una cosa del genere (se non c'e' basta
aggiungerla) :

    #Person who should get root's mail. Don't receive mail as root!
    #root:          you

Togliamo il commento dalla seconda riga a mettiamo admin:

    root:          admin

Usciamo dall'editor e digitiamo:

    newaliases

Ora le mail dirette a root verranno girate al nostro utente admin.

> Avvio del servizio

Come al solito includiamo postfix dell'array DAEMONS in /etc/rc.conf :

    DAEMONS=(... ... ... ... ... postfix ... ... ...)

Dovecot
-------

Dovecot è un Mail Delivery Agent progettato per garantire la sicurezza.
Supporta la maggior parte dei formati di caselle di posta: a noi
interessa particolarmente il formato Maildir dal momento che lo abbiamo
adottato. Questa sezione espone come configurarlo come server imap e
pop3.

> Configurazione

Cominciamo con il copiarci il file di esempio di Dovecot che rappresenta
un ottimo punto di partenza e apriamolo con il nostro editor:

    sudo cp /etc/dovecot/dovecot-example.conf /etc/dovecot/dovecot.conf
    sudo nano /etc/dovecot/dovecot.conf

Possiamo notare che il file è bello corposo o_O, noi impostamo solo
quello che ci interessa lasciando il resto invariato. Cominciamo con
l'abilitare i protocolli pop3 e imap

    protocols = imap pop3

e proseguiamo con il disabilitare l'autenticazione ssl e abilitare le
passwords in chiaro. Ok, non è il massimo della vita, ma la messa in
sicurezza del server ve lo lascio come compito a casa:

    ssl_disable = yes
    disable_plaintext_auth = no

conludiamo con il formato UIDL (Unique Mail Identifier) da usare.
Impostiamo il predefinito consigliato che sembra non dare fastidio
nemmeno a Outlook 2003 ;)

    pop3_uidl_format = %08Xu%08Xv

> Autenticazione

Al fine di ottenere il nostro agognato Single Signon vogliamo far sì che
Dovecot autentichi gli utenti utilizzando la stessa coppia
utente/password utilizzata da Samba. I nostri utenti utilizzeranno
sempre lo stesso account sia per il File Server che per la posta. Questo
si può fare in modi diversi, qui utilizzeremo PAM che di "riflesso"
utilizzerà LDAP per l'autenticazione. Apriamo (se lo abbiamo chiuso) il
file di configurazione /etc/dovecot/dovecot.conf e aggiungiamo (o
cerchiamo e modifichiamo, meglio) il seguente parametro :

    passdb pam {
     args = blocking=yes dovecot
    }

In questo modo abbiamo detto a Dovecot di utilizzare PAM con le "regole"
impostate nel file /etc/pam.d/dovecot che andiamo immediatamente a
creare:

    sudo nano /etc/pam.d/dovecot

così:

    #%PAM-1.0
    auth            sufficient      pam_ldap.so
    auth            required        pam_unix.so nullok
    account         sufficient      pam_ldap.so
    account         required        pam_unix.so

Ora Dovecot per autenticare un utente utilizzerà PAM il quale prima
chiederà a LDAP e poi utilizzerà l'utente locale unix.

> Avvio del servizio

Non ci resta che avviare il servizio:

    sudo /etc/rc.d/dovecot start

e metterlo nel nostro array DAEMONS in /etc/rc.conf per un avvio
automatico:

    DAEMONS=(... ... ... ... ... dovecot ... ... ...)

Shorewall
---------

Mai dimenticarsi del Firewall ! Dobbiamo permettere il traffico sulle
porte utilizzate da Dovecot e anche costringere gli utenti della nostra
rete ad utilizzare il nostro server per spedire, altrimenti ...

> Configurazione

Editiamo il file :

    sudo nano /etc/shorewall/rules

e aggiungiamo le nuove regole:

    POP3/ACCEPT      loc             $FW
    IMAP/ACCEPT      loc             $FW

se vogliamo scaricare la posta anche quando siamo fuori dall'azienda
dobbiamo anche abilitare l'accesso dall'esterno:

    POP3/ACCEPT      net             $FW
    IMAP/ACCEPT      net             $FW

> La regola più importante

Stiamo filtrando tutta la posta per proteggere i nostri utenti da SPAM e
Virus, ma anche per evitare di essere bannati dagli altri server di
posta perchè non "virtuosi", nel senso che ok, respingiamo le mail che
arrivano, ma dobbiamo anche evitare di spedirla la spazzatura. Se gli
utenti della nostra rete utilizzano il nostro server per spedire siamo a
posto, Amavis (come vedremo dopo) farà già il suo lavoro, ma se un
nostro utente buontempone (o un utente "esterno" nostro ospite) ha il
suo bel account su GMail o su Yahoo o qualunque altro, e usa l'SMTP di
questo Provider per spedire la posta ? Magari aggiungiamo che si è
beccato un virus con il Notebook mentre navigava da casa che lo ha
trasformato in un zombie alla mercè degli Spammers e abbiamo fatto la
frittata: appena accende il computer collegato alla nostra rete
aziendale, ZAC! inizia a spedire tonnellate di SPAM attraverso il suo
provider il quale cosa vedrà come mittente della montagna di spazzatura
che stà arrivando ? MA NATURALMENTE IL NOSTRO INCOLPEVOLE SERVER che stà
"nattando" la rete con un unico indirizzo IP. Risultato ? 10 minuti e
siamo bannati. Garantito.

Come evitare questo disastro ? Con questa regola da applicare sempre su
/etc/shorewall/rules :

    REDIRECT        loc             smtp            tcp     smtp    - !85.85.85.85,192.168.20.1

Dove "85.85.85.85" è l'indirizzo IP inventato (voi mettete quello vero!)
pubblico del nostro server. In questo modo chiunque cerchi di "passare"
attraverso il nostro server (ad eccezione di chi ci punta correttamente)
utilizzando il protocollo SMTP della posta viene "girato" localmente sul
server. Il nostro server filtra così il messaggio e, se passa i nostri
canonici controlli, viene spedito da lui stesso. Non facciamoci
scavalcare ! :D

Bene. Ora non ci resta che riavviare il firewall:

    sudo shorewall restart

Tutto qua ?
-----------

Ora il nostro server può inviare mail dalla nostra rete. Tutto qua ? Eh
eh, magari. Diciamo che già funziona, e in un mondo perfetto di sole
persone oneste potremmo fermarci qua. Peccato non sia così e che
dobbiamo difenderci dai rompic... che popolano la rete e che vogliono
magari venderci pillole blu anche a Natale...

Meglio rimboccarci le maniche e vedere come possiamo almeno rendere loro
la vita un po' più difficile.

Filtraggio della posta
======================

Siamo felici perchè abbiamo un mail server funzionante e stiamo
ricevendo mail dal mondo. Putroppo in breve tempo una quantità
incredibile della posta che riceviamo sarà inevitabilmente spazzatura
non richiesta: Spam. Qualche mail conterrà pure virus e malware, e
magari come mittente c'e' pure un vostro ignaro amico. Lo Spam e la
posta infetta da virus sono una autentica epidemia. Un server di posta
non protetto ha breve vita, presto saremo bannati come “cattivi” dalle
liste pubbliche e non riusciremo più nemmeno ad inviare posta perchè
respinti dagli altri server. Insomma, un disastro. Avendo un server
personale per la posta è nostro compito, dunque, proteggerlo e vedremo
qui come farlo.

Fortunatamente gli strumenti per combattere e limitare (non sconfiggere,
badate bene) questo problema non mancano, come già detto prima
configureremo Postfix per un primo livello di controllo della posta,
installeremo Postgrey che implementa il graylisting, Amavis-new che
esplora le vostre mail e invoca altri pacchetti quali Spamassassin per
proteggere il vostro server dallo spam e ClamAV per la scansione
antivirus. Abbiamo visto come addirittura il nostro Shorewall ci dà una
mano con una importante regola. Quello che dobbiamo fare è integrarli
insieme.

Piccola nota: forse qualcuno si domanderà perché mai debba proteggere
Linux dai virus. Il motivo è semplice: nella nostra rete interna la
maggior parte dei computer avrà sicuramente una qualche versione di
Windows a bordo che è il bersaglio preferito dei virus e malware. Quindi
meglio prevenire che curare cercando di far arrivare meno spazzatura
possibile a questi umili e indifesi client :).

Iniziamo con Postfix.

Postfix
-------

Il nostro MTA già di suo ci permette di limitare lo spam e di proteggere
il nostro server. Editiamo il nostro file di configurazione:

    sudo nano /etc/postfix/main.cf

Postfix generalmente scrive nel log il motivo di rifiuto di una mail, e
settando smtpd_delay_reject = yes, mostra il mittente e la stringa HELO
che ha causato il rifiuto. Andiamo in fondo al file e aggiungiamo :

    smtpd_delay_reject = yes

Rifiutamo anche tutte le mail dai server che non identificano
correttamente se stessi usando il comando HELO (o EHLO) come richiesto
dallo standard SMTP RFC. Aggiungiamo :

    smtpd_helo_required = yes

Ora impostiamo una serie di restrizioni da applicare. A chi non supera
queste... "bye bye" prima ancora di entrare.

> Restrizioni nei comandi HELO o EHLO

Sono usati dal mail server remoto per identificare se stesso. Le
restrizioni sono analizzate in cascata una alla volta.

-   permit_mynetworks: accetta le connessioni da qualsiasi mail server
    listato nel parametro mynetworks di main.cf
-   reject_invalid_hostname: rifiuta connessioni da tutti i server che
    non identificano se stessi usando un nome host corretto (fully
    qualified hostname)
-   permit: alla fine accetta le connessioni dai server che hanno
    passato i controlli precedenti.

    smtpd_helo_restrictions =
            permit_mynetworks,
            reject_invalid_hostname,
            reject_non_fqdn_hostname,
            permit

> Restrizioni a cui sono soggetti i server remoti per i comandi inviati

-   reject_unauth_pipelining : impone al nostro server di rifiutare le
    connessioni dai server che inviano troppo velocemente i comandi.
    Molti spammers fanno questo per tentare di velocizzare la fase di
    invio mail spazzatura.
-   permit : come sopra, accetta le connessioni se le precedenti
    restrizioni sono ok.

    smtpd_data_restrictions =
            reject_unauth_pipelining,
            permit

> Restrizioni sui mittenti delle mail che il server riceve

Viene usato il comando SMTP MAIL FROM per identificarli :

-   permit_mynetworks : vedi sopra
-   reject_non_fqdn_sender : rifiuta le mail da tutti i mittenti il cui
    nome non è specificato in modo esteso (sempre secondo quanto
    stabilisce il famoso "fully qualified host name"). Nota che gli host
    della nostra rete avranno probabilmente un nome host corto ma in
    questo caso sono già garantiti dalla regola precedente.
-   reject_unknown_sender_domain : rifiuta le mail che provengono da
    domini sconosciuti
-   permit : vedi sopra

    smtpd_sender_restrictions =
            permit_mynetworks,
            reject_non_fqdn_sender,
            reject_unknown_sender_domain,
            permit

> Restrizioni nei destinatari finali delle mail che il nostro server riceve

Sono identificati usando il comando SMTP RCPT TO :

-   reject_unverified_recipient : rifiuta a priori una mail verso un
    utente sconosciuto. Tuttavia ho notato che se il server destinatario
    implementa Postgrey questo parametro, di fatto, ci impedisce di
    mandargli mail a causa del rifiuto di validare l'utente imposto dal
    funzionamento stesso di Postgrey. Occhio ai log, ed eventualmente
    disabilitare la restrizione.
-   permit_mynetworks : vedi sopra
-   reject_unknown_recipient_domain : rifiuta le mail quando il nostro
    mail server non è la destinazione finale e la destinazione non è un
    dominio valido
-   reject_unauth_destination : rifiuta le mail quando il dominio
    destinazione non è fra quelli serviti dal nostro server (definiti
    dal parametro mynetworks) oppure non è fra i domini definiti in
    relayhost. Questo impedisce che il nostro server venga utilizzato
    come open relay.
-   check_policy_service : fa in modo che postfix usi un servizio
    esterno per controlli aggiuntivi. Nel nostro caso
    inet:127.0.0.1:10030 passa la palla a Postgrey per implementare le
    gray list. Lo vedremo più avanti.
-   permit : vedi sopra.

    smtpd_recipient_restrictions =
            reject_unverified_recipient,
            permit_mynetworks,
            reject_unknown_recipient_domain,
            reject_unauth_destination,
            check_policy_service inet:127.0.0.1:10030
            permit

Bene, a questo punto il nostro server Postfix già respingerà
autonomamente una parte delle mail non desiderate. Un'altra cosa che si
potrebbe implementare è un check se il mittente è presente nelle liste
pubbliche di spammer riconosciuti. Tuttavia secondo me gli svantaggi
sono maggiori dei vantaggi: rallenta troppo il sistema e, peggio ancora,
spesso le liste non sono precise. Con Postgrey nel fodero io preferisco
non implementarlo.

> Test delle restrizioni

Postfix fornisce vagonate di parametri, a volte è utile testare una
restrizione prima di buttare alle ortiche delle mail. Vi segnalo un paio
di parametri utili allo scopo.

soft_bounce

Aggiungiamolo con il comando postconf (ma naturalmente potremmo anche
editare il file /etc/postfix/main.cf, è lo stesso) e riavviamo postfix:

    sudo postconf -e "soft_bounce = yes"
    sudo /etc/rc.d/postfix restart

N.B.: In alternativa al "restart" del servizio posso usare il comando
postfix per rileggere la configurazione senza killare il processo, basta
digitare : sudo postfix reload e le nuove impostazioni saranno
operative.

Quando impostato a yes, le hard reject responses (5xx) sono convertite
in soft reject responses (4xx). In questo modo il server mittente, dopo
un intervallo di tempo, opera un nuovo tentativo. Impostare questo
parametro significa, in pratica, poter controllare il file di log e
vedere cosa il vostro server rifiuta dandovi il tempo, se necessario, di
aggiustare la configurazione in attesa del nuovo tentativo. Una volta
trovata la configurazione ottimale disabilitare soft_bounce e ricaricare
postfix.

warn_if_reject

Facendo precedere questo parametro alle altre direttive si fà in modo
che postfix anzichè rifiutare la mail segnali un warning nel log. Se non
si è sicuri di quali effetti possa avere una nuova restrizione, questo
parametro, dunque, permette di controllare prima e poi eventualmente
impostare la restrizione come effettiva.

Ad esempio :

    smtpd_recipient_restrictions =
            reject_unverified_recipient,
            permit_mynetworks,
            warn_if_reject reject_invalid_hostname,
            reject_unknown_recipient_domain,
            reject_unauth_destination,
            check_policy_service inet:127.0.0.1:10030
            permit

Notate il warn_if_reject che precede la mia regola
reject_invalid_hostname: se un client, dunque, usa un nome host HELO
invalido quando ci invia un messaggio, rientra nella mia restrizione, ma
con questo parametro impostato Postfix scrive nel log un warning e
accetta la mail lo stesso.

Riavviamo Postfix e controlliamo non ci siano errori:

    sudo /etc/rc.d/postfix restart

Ottimo! Il primo passo è stato compiuto, solo server apparentemente
ufficiali ci possono inviare mail.

Postgrey
--------

Precedentemente in Postfix abbiamo impostato la direttiva
check_policy_service per utilizzare un anche un servizio esterno per le
restrizioni. In questo caso vogliamo usare Postgrey che implementa il
graylisting. Cos'e' il graylisting ? Molti avranno sicuramente sentito
parlare di whitelist (la lista dei buoni) e blacklist (la lista dei
cattivi). Con Postgrey si implementa un livello intermedio tra i due,
detto appunto greylist (che fantasia :)).

Questo sistema sfrutta un concetto molto semplice: visto l'elevato
numero di mail che gli spammers inviano, raramente tentano più di una
volta l'invio della posta ad un destinatario. Con Postgrey il vostro
server sfrutta questo fatto respingendo temporaneamente tutte le email
provenienti da mittenti sconosciuti segnalando loro che la casella di
posta del destinatario non è momentaneamente disponibile e mettendosi in
ascolto per il secondo tentativo che un server "ufficiale" fà sempre.

Semplice, efficace ed ingegnoso, non servono filtri bayesiani o altre
diavolerie e, ve lo garantisco, per il momento questo sistema spazza via
da solo oltre il 95% dello spam !.

Più sotto vedremo in dettaglio il funzionamento.

> Configurazione

La configurazione base di Postgrey è molto semplice. Anzi, praticamente
nulla. Nelle smtpd_recipient_restrictions di Postfix abbiamo già
impostato:

    check_policy_service inet:127.0.0.1:10030

E siamo già a posto, possiamo avviare il servizio per metterlo in
funzione

    sudo /etc/rc.d/postgrey start

e inserirlo nell'array di avvio in /etc/rc.conf prima (anche se forse
non è importante l'ordine) di postfix :

    DAEMONS=(... ... ... ... ... postgrey postfix ... ... ...)

Ulteriori configurazioni per Postgrey possono essere fatte editando il
file dei default del servizio postgrey

    sudo nano /etc/conf.d/postgrey

di particolare interesse possono essere i due parametri :

-   --delay : definisce per quanti secondi in messaggio viene messo in
    graylist. Di default 300 secondi.
-   --max-age : definisce per quanti giorni un mittente che ha già in
    passato superato la verifica rimane nella whitelist generata da
    postgrey. Finchè sono qui verranno in futuro accettati senza
    verifica. Di default 30 giorni.

Per variare questi parametri bisogna metterli nella variabile
POSTGREY_OPTS, e riavviare il servizio. Ad esempio, per portare il delay
a 180 secondi e il max age a 60 giorni :

    POSTGREY_OPTS="--delay=180 --max-age=60"

Postgrey memorizza i suoi dati in formato Berkley DB nella cartella :

    /var/spool/postfix/postgrey

Putroppo pare non ci siano comandi per gestire il database o per
visualizzare la greylist. Se qualcuno vuole smentirmi è bene accetto.

Possiamo personalizzare le whilelist editando il file dove vengono
identificati i domini da non filtrare con greylist :

    sudo nano /etc/postfix/postgrey_whitelist_clients

Oppure i destinatari da non filtrare :

    /etc/postfix/postgrey_whitelist_recipients

> Il giochino di Postgrey

Con la configurazione di default vediamo a grandi linee cosa succede
quando a Postgrey viene chiesta la verifica di una mail da un utente
fino ad ora sconosciuto :

1.  Postgrey rifiuta la mail e Postfix comunica che la mailbox
    dell'utente non è al momento disponibile
2.  Postgrey memorizza la terna indirizzo IP dell'host sorgente, email
    del mittente, email del destinatario nella greylist
3.  Al successivo tentativo del server mittente se non è trascorso il
    tempo di delay (300 secondi), postgrey continua a rifiutare la mail.
    Questo per evitare i rinvii troppo veloci operati dagli spammers.
4.  Se al successivo reinvio il tempo di delay è trascorso postgrey
    accetta la mail e memorizza la terna indirizzo IP dell'host
    sorgente, email del mittente, email del destinatario nella sua
    whitelist per max age tempo (30 giorni)

Come vediamo la "terna" rimane nella white list di default per 30
giorni, in questo modo chi ci invia regolarmente email non viene più "
ritardato" da postgrey ma accettato subito.

> Controindicazioni ?

Bhe, a parte un ritardo di 5 minuti la prima volta che qualcuno ci
scrive sinceramente non ne vedo. Ok, il sistema si appesantisce perchè
ogni nuovo messaggio deve essere inviato due volte, ma credetemi che i
benefici sono enormi. Ho un semplice caso in cui con Postgrey i messaggi
di spam sono passati da circa 8.000 al giorno a qualche decina.

Godiamoci il greylisting finchè funziona, temo che se verrà implementato
su larga scala (credo che i grossi provider con alto volume di traffico
difficilmente lo faranno) gli spammers cominceranno ad uscire con delle
contromisure...

Una guerra infinita.

Amavis-new
----------

Abbiamo finito con le protezioni ? Neanche per sogno! Dobbiamo ancora
gestire/segare il 5% dello spam che sfugge a PostFix+Postgrey, ma
sopratutto dobbiamo aiutare i nostri poveri client windows nella loro
titanica lotta a spyware e virus... Configuriamo il sistema per
utilizzare amavis-new, occhio al file di configurazione dello stesso: UN
VERO INCUBO, quindi non addormentatevi sulla tastiera e magari salvate
l'originale che se sbagliate qualche virgoletta o altro non funziona più
un tubo ... O_o. Iniziermo con la parte Postfix e con qualla
Spamassassin, per conludere, poi, con quella relativa a Clamav

> Content Filter con Amavis-new

Per questa configurazione sono state scelte delle applicazioni note per
il buon livello di sicurezza che offrono e per la facilità con la quale
possono essere modificati i propri file di configurazione. Come oramai
abbiamo capito, per impostazione predefinita Postfix si mette in ascolto
sulla porta 25 per la posta in ingresso. Quando arriva un nuovo
messaggio di posta, dopo i suoi canonici controlli restrittivi (compreso
Postgrey) il server lo inoltra' ad amavisd-new sulla porta 10024.
Amavisd-new, successivamente, controlla il messaggio attraverso vari
filtri e lo restituisce a Postfix sulla porta 10025; infine, il
messaggio viene inviato alla mailbox del destinatario. Complicato vero ?
Più da scrivere che da fare :)

> Un caporale con due soldati

Cos'e' Amavis-new ? Amavisd-new è un framework per il filtraggio di
contenuti che utilizza applicazioni di supporto per il riconoscimento di
virus e spam. Il nostro caporale filtratore utilizzerà due soldati per
la sua campagna d'armi: ClamAV per il filtraggio dei virus e
Spamassassin per quello dello spam. Spamassassin, a sua volta, può
poggiarsi su applicazioni di livello inferiore, come ad esempio Vipul's
Razor e DCC (non trattati in questa guida). Rispetto ad altre tecnologie
di controllo dello spam (come gli RBL, dall'inglese Real-time Blackhole
List, termine con il quale si indicano impropriamente le tecnologie
DNSBL, o di DNS blacklist, che consistono nella pubblicazione, da parte
di un sito Internet, di una lista di indirizzi IP che, per varie
ragioni, ma principalmente spam, dovrebbero essere bloccati),
Spamassassin non valida un dato messaggio email in base ad un singolo
test. Questo programma, invece, esegue una lista di controlli, sia
interni, sia usando delle applicazioni esterne, per calcolare un
punteggio da assegnare ad ogni messaggio di posta. Questo punteggio è
determinato in base a:

-   Filtro Bayesiano
-   Regole statiche basate su espressioni regolari
-   Reti distribuite e collaborative (RBL, Razor, Pyzor, DCC)

In base al punteggio (configurabile) raggiunto, la mail sarà rifiutata o
accettata.

Quando al caporal Amavisd viene segnalato che la mail contiene virus o
spam può fare le seguenti cose:

-   'PASS' : Il destinatario riceve la mail
-   'DISCARD': Il destinatario non riceve la mail. Il mittente non
    riceve alcuna notifica del fallimento della spedizione, il messaggio
    viene posto in quarantena se abbiamo deciso di abilitare questa
    funzionalità:
-   'BOUNCE': Il destinatario non riceve la mail. Il mittente riceve una
    notifica che la spedizione è fallita. Nessuna notifica, però, viene
    inviata se la mail contiene un virus e il mittente viene
    identificato come "fake", falso.
-   'REJECT': Il destinatario non riceve la mail. Il mittente dovrebbe
    ricevere una notifica che la spedizione è fallita dal nostro MTA
    (Postfix).

La differenza sostanziale tra BOUNCE e REJECT è su chi prepara questa
DSN (Delivery Status Notification). con REJECT è il nostro MTA (Postfix)
che la prepara e la spedisce, con BOUNCE è Amavis che lo fà
(generalmente questa contiene maggiori informazioni). Tuttavia Postfix
non supporta la funzionalità REJECT, quindi per noi i parametri validi
sono PASS, DISCARD e BOUNCE.

In Amavis, queste opzioni di chiamano D_PASS, D_DISCARD e D_BOUNCE e
sono configurate con i parametri nel file /etc/amavisd/amavisd.conf :

-   $final_spam_destiny
-   $final_virus_destiny
-   $final_banned_destiny
-   $final_bad_header_destiny

Nella nostra configurazione imposteremo amavis in modo che spam e virus
siano cestinati (D_DISCARD), e siccome non disabiliteremo la quarantena,
le mail spazzatura finiranno lì. Se volessimo disabilitare la quarantena
le mail sarebbero buttate e perse.

Ancora qualche appunto sulla quarantena. Amavis può porre le mail in
quarantena quando trova spam/virus in una specifica directory oppure può
inviarla ad un altro inidirizzo email perchè venga "spulciata" da un
operatore umano che deciderà il destino della "presunta" spazzatura.
Quindi, in pratica, potremmo ad esempio indirizzare tutta lo spam a
spam@mede.it e i virus a virus@mede.it, oppure in alternativa salvarla
il una directory del nostro server. Amavis permette di specificare la
directory per la quarantena con il parametro $QUARANTINEDIR. Tuttavia è
possibile scegliere cartelle diverse per lo spam e per i virus.

> Postfix

Sì, cavolo, ancora Postfix. Dobbiamo modificare il file dove vengono
definiti i suoi servizi aggiungendone uno per amavis e configurarlo
affinché ne faccia uso. Modifichiamo il file master.cf (occhio, non
main.cf), dove, appunto, sono specificate le impostazioni dei servizi di
postfix:

    sudo nano /etc/postfix/master.cf

e aggiungiamo in fondo :

    ## AMAVIS
    ##
    amavis    unix    -    -    -    -    2    smtp
         -o smtp_data_done_timeout=1200
         -o smtp_send_xforward_command=yes
         -o disable_dns_lookups=yes 
    127.0.0.1:10025    inet    n    -    -    -    -    smtpd
         -o content_filter=
         -o smtpd_restriction_classes=
         -o smtpd_delay_reject=no
         -o smtpd_client_restrictions=permit_mynetworks,reject
         -o smtpd_helo_restrictions=
         -o smtpd_sender_restrictions=
         -o smtpd_recipient_restrictions=permit_mynetworks,reject
         -o smtpd_data_restrictions=reject_unauth_pipelining
         -o smtpd_end_of_data_restrictions=
         -o mynetworks=127.0.0.0/8
         -o smtpd_error_sleep_time=0
         -o smtpd_soft_error_limit=1001
         -o smtpd_hard_error_limit=1000
         -o smtpd_client_connection_count_limit=0
         -o smtpd_client_connection_rate_limit=0
         -o smtpd_milters=
         -o local_header_rewrite_clients=
         -o local_recipient_maps=
         -o relay_recipient_maps=
         -o receive_override_options=no_header_body_checks,no_unknown_recipient_checks

I parametri sono una marea prendeteli per buoni, oppure (meglio)
googolate alla ricerca di una spiegazione. Due cose però le scrivo. Cosa
diavolo abbiamo fatto ? Semplice (si fà per dire) abbiamo definito due
"servizi": amavis per il delivery via smtp della posta al content
filter, e la porta di reiniezione (reinjection sulla 10025) dove ci
aspettiamo la risposta. Facile no ? :D Lo sò, lo sò vi viene voglia di
installare Exchange ...

Non abbiamo finito, ricercate la riga più sù dove stà scritto "pickup" e
fatela diventare così:

    pickup    fifo  n       -       n       60      1       pickup
      -o content_filter=
      -o receive_override_options=no_header_body_checks

Questo fà si che i messaggi locali (ad esempio quelli generati dal
server stesso con crond per postmaster o root o chicchessia) non vengano
filtrati.

Bene ora un ultimo tocco a main.cf :

    sudo nano /etc/postfix/main.cf

in cui, ovviamente (almeno per chi non si è ancora perso), dobbiamo dire
a postfix di usare il content filter alltraverso il servizio che abbiamo
definito. Aggiungiamo quindi in fondo :

    content_filter = amavis:[127.0.0.1]:10024

Ok ? Utilizziamo il servizio amavis che stà sulla interfaccia di
loopback (127.0.0.1) sulla porta 10024. Questo vi dovrebbe far intuire
che potremmo usare anche un altro server per il content filter, ma non
perdiamoci, nella nostra Small Buisiness abbiamo un unico server ;)

> Amavis

Bene, andiamo finalmente ad editare il nostro file-incubo che serve a
configurare amavis. Perchè incubo ? Appena lo aprirete sull'editor
capirete, diciamo che è un po' delicatino ...

    sudo nano /etc/amavisd/amavisd.conf

Assicuriamoci che l'utente e il gruppo amavis siano impostati:

    $daemon_user = 'amavis';
    $daemon_group = 'amavis';  

Troviamo e impostiamo la variabile $mydomain con il dominio:

    $mydomain = 'mede.it';  

e cambiamo il nome del nostro host (deve esistere!) con la variabile
$myhostname

    $myhostname = 'archi.mede.it'; 

troviamo la riga seguente e aggiungiamo il nostro dominio :

    @local_domains_maps = ( [".$mydomain", ".mede.it"] );

Ora dobbiamo configurare la parte spamassassin di amavis-new. Questo
primo fà si che tutte le mail indirizzate ai domini in @local_domains
avranno specificato il punteggio spam nella header della mail, che siano
spam oppure no.

    $sa_tag_level_deflt  = undef;

Questo è il punteggio "spartiacque" delle mail. In ogni mail con
punteggio superiore a $sa_tag2_level_deflt sarà considerata spam, verrà
aggiunto un prefisso "[SPAM] " all'oggetto e sarà inviata al
destinatario.

    $sa_tag2_level_deflt = 5.0; 

Questo valore definisce il punteggio sopra cui la mail deve essere nessa
in quarantena da Amavis. Definisce anche il livello sopra il quale il
mittente viene avvisato (Delivery Status Notification, DSN) che il
messaggio non è stato recapitato. Nessun DSN viene inviato, tuttavia, se
il parametro $sa_dsn_cutoff_level è impostato ad un valore inferiore al
punteggio spam (vedi dopo). Siccome noi non vogliamo per niente al mondo
avvisare gli spammers che gli abbiamo "sgamato" la mail impostiamo il
parametro al valore assurdo di 10000.

    $sa_kill_level_deflt = 10000;

Fino a questo momento tutto lo spam è inviato ai nostri utenti, con il
solo oggetto modificato. Tuttavia, quando definiremo la variabile
$spam_quarantine_to più sotto, in effetti ognuna di queste mail sarà
considerata "bisognosa di quarantena" e inviata a chi definito dal
parametro con oggetto e header modificato. Questo parametro definisce il
punteggio oltre al quale non siamo interessati ad inviare la notifica
(DSN) al mittente. Possiamo lasciare questo valore dal momento che non
siamo interessati ad inviare alcuna notifica (cambiaremo D_BOUNCE in
D_DISCARD più sotto).

    $sa_dsn_cutoff_level = 9;

Oltre questo livello la mail non viene nemmeno posta in quarantena

    $sa_quarantine_cutoff_level = 20; 

Come preannunciato, non inviamo MAI alcuna notifica ai mittenti. Tutte
le mail finiscono in quarantena. Il preferisco inviare le mail ad un
responsabile perchè controlli i messaggi incriminati anzichè in una
directory di quarantena, i filtri non sono perfetti e si potrebbero
verificare dei falsi positivi. Per fare questo definiamo i destinatari,
e la directory di quarantena verrà disabilitata automaticamente:

    $final_virus_destiny      = D_DISCARD;
    $final_spam_destiny       = D_DISCARD;
    $final_banned_destiny     = D_DISCARD;

Gli indirizzi seguenti diventeranno, dunque, virus@mede.it e
spam@mede.it e naturalmente devo ricordare di aggiungere questi
destinatari sul mio server, o di "girarli" tramite alias a qualche
indirizzo esistente.

    $virus_quarantine_to = "virus\@mydomain";
    $banned_quarantine_to = "spam\@$mydomain";
    $bad_header_quarantine_to = "spam\@$mydomain";
    $spam_quarantine_to = "spam\@$mydomain";

Ora definiamo gli indirizzi di notifica. Questi destinatari riceveranno
le notifiche sui virus trovati, per disabilitare la notifica basta
commentare la riga.

    $virus_admin               = "postmaster\@$mydomain";
    $banned_admin              = "postmaster\@$mydomain";

Non sarete mica già stufi ! Ora definiamo chi debba essere il mittente
delle notifiche :

    $mailfrom_notify_admin     = "postmaster\@$mydomain";
    $mailfrom_notify_recip     = "postmaster\@$mydomain";
    $mailfrom_notify_spamadmin = "postmaster\@$mydomain";
    $hdrfrom_notify_sender     = "amavisd-new <postmaster\@$mydomain>";

e per ultima la stringa che deve essere anteposta all' oggetto della
mail che consideriamo SPAM :

    $sa_spam_subject_tag = '[SPAM]  ';

Ora le mail arriveranno, se SPAM, con l'oggetto modificato che include
questa stringa.

Noiosa questa parte vero ? Almeno per me lo è stata, forse sono
particolarmente allergico a questo file di configurazione che sembra (e
probabilmente lo è) un sorgente scritto in perl. Veramente difficoltoso
districarsi tra il marasma di opzioni, forse si potrebbe far meglio, ma
l'importante è che faccia il suo dovere, e su questo non ci sono dubbi.

> Clamav

Amavis può utilizzare un ampio ventaglio di antivirus che comprende
tutti i big commerciali del settore, noi abbiamo deciso per clamav dal
momento che è open. Lo abbiamo già installato, ora configuriamo,
avviamolo e impostiamo amavis-new affinché lo utilizzi.

Clamav ha due demoni, uno per la scansione (clamd) e uno per
l'aggiornamento del database dei virus conosciuti (freshclam), facciamo
in modo che entrambi siano attivi :

    sudo nano /etc/conf.d/clamav

e impostiamo i valori così:

    START_FRESHCLAM="yes"
    START_CLAMD="yes"

Ora modifichiamo i file di configurazione prima di clamav :

    sudo nano /etc/clamav/clamd.conf

rimuoviamo (o commentiamo) la riga che inizia con "Example" e impostamo
il parametro AllowSupplementaryGroups che abilita clamd ad accedere ai
file usando qualsiasi privilegio di gruppo abbia. Senza questo clamd non
accede ai file usando i permessi di gruppo, limitando la scansione ai
soli file leggibili da tutti.

    AllowSupplementaryGroups yes

Ora dedichiamoci a freshclam :

    sudo nano /etc/clamav/freshclam.conf

e rimuoviamo, come per clamd, la riga che inizia con "Example". Ora
proviamo ad avviare il servizio:

    sudo /etc/rc.d/clamav start

in questo modo dovrebbero partire sia ClamD che FreshClam. Se questo è
successo siete in gamba e avete dimostrato si saper usare bene il
copia/incolla :D Proviamo ad aggiornare le definizioni dei virus :

    sudo freshclam

Dovrei ottenere qualcosa del genere:

    ClamAV update process started at Fri Jan 25 16:14:49 2008
    main.cvd is up to date (version: 45, sigs: 169676, f-level: 21, builder: sven)
    daily.cvd is up to date (version: 5550, sigs: 25581, f-level: 21, builder: ccordes)

Ok ? Ora non preoccupatevi, ogni 12 ore Freshclam si avvierà da solo.

L'ultimo tassello di questa interminabile fase è la configurazione di
amavis perché usi clamav. Per far questo ritorniamo al nostro incubo :

    sudo nano /etc/amavisd/amavisd.conf

andiamo a decommentare la parte relativa a clamav (occhio al percorso
del file clamd.sock):

    ['ClamAV-clamd',
      \&ask_daemon, ["CONTSCAN {}\n", "/var/lib/clamav/clamd.sock"],
      qr/\bOK$/, qr/\bFOUND$/,
      qr/^.*?: (?!Infected Archive)(.*) FOUND$/ ],

e aggiungiamo l'utente clamav al gruppo amavis:

    sudo gpasswd -a clamav amavis

> Avvio dei servizi

Ufff, questa parte è stata lunghina e noiosa lo ammetto, ma che ci posso
fare ? Ricordiamoci di modificare l'array DAEMONS in /etc/rc.conf :

    DAEMONS=(... postfix postgrey spamd clamav amavisd ...)

che contenga i nostri "impavidi" e proviamo con un virus di test che
possiamo trovare qui:

    wget http://www.eicar.org/download/eicar.com

e inviamo una mail di prova :

    sendmail -f test@gmail.com admin@mede.it < eicar.com

L'utente admin@mede.it (ricordiamo che virus@mede.it è un alias)
dovrebbe ricevere una mail con la segnalazione del virus. Per il momento
ci accontentiamo di controllare visualizzando il file contenuto
/home/admin/MailDir/cur corrispondente alla mail.

Conclusioni
===========

Abbiamo (anzi, ho) penato un po' per questa parte Mail Server, ma alla
fine il risultato è ottimo. Certo, sarebbe auspicabile semplificare un
pochino magari accorpando qualche funzionalità (specie il content
filter) direttamente su Postfix dal momento che oramai praticamente
tutti i server di posta fitrano i messaggi. Chissà magari un giorno
qualcuno ci pensa, nel frattempo sorbiamoci stò mattone.

Per la verità qualcosa esiste, e sono sicuramente il futuro in questo
campo. Mi riferisco alle soluzioni di groupware che sempre più spesso
vengono richieste, le quali permettono una reale collaborazione tra
persone magari condividendo le cose più semplici come PIM e posta
elettronica.

Magari daremo un occhio a Zimbra, ma questa è un altra storia ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server_(Italiano)/Mail_Server&oldid=235414"

Category:

-   Small Business Server (Italiano)

-   This page was last modified on 14 November 2012, at 17:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
