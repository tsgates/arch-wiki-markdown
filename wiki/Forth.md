Forth
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The Forth computer language was invented by Charles Moore:
http://colorforth.com/

Forth is extensible, can be its own OS, and in general makes tiny
powerful programs.

Forth has been a recognized programming language since the 1970's.
ColorForth is a redesign of this classic language for the 21st century.
It also draws upon a 20-year evolution of minimal instruction-set
microprocessors. Now implemented on modern PCs, it runs stand-alone
without an operating system. Applications are recompiled from source
with a simple optimizing compiler.

gforth is a forth that runs on an OS, and is ANSI Forth.

Starting Forth is a good book to learn forth by Leo Brodie:
http://home.iae.nl/users/mhx/sf.html

  
 Syntax highlighting file for Nano:

     ## Here is an example for Forth.
     ##
     syntax "forth" "\.(fs|4th|4mu)$" 
     
     ## Preprocessor statements
     color brightred "\[.+\]"
     
     ## Numbers
     color magenta "-?[0-9]+"
     
     ## Floats
     color cyan "-?[0-9\.]+e[0-9]+"
     
     ## Other Words
     
     color green "\<(2constant|2drop|2dup|2literal|2nip|2over|2rdrop|2rot|2swap|2tuck|2variable|abort|abs|accept|again|ahead|alias|align|aligned|allocate|allot|also|and|arg|argc|argv|asptr|asptr|assembler|base|begin|bin|bind|bind|bl|blank|blk|block|bootmessage|bound|bounds|buffer|bye|case|catch|cell|cells|cfalign|cfaligned|char|chars|class|class|class|clearstack|clearstacks|cmove|code|compare|constant|construct|context|convert|count|cputime|cr|create|current|dabs|dbg|decimal|defer|defer|defers|defines|definitions|definitions|depth|dfalign|dfaligned|dfloats|discode|dispose|dmax|dmin|dnegate|do|done|dpl|drop|dump|dup|early|ekey|else|emit|endcase|endif|endof|endscope|endtry|endwith|erase|evaluate|exception|execute|exit|exitm|expect|fabs|facos|facosh|falign|faligned|falog|false|fasin|fasinh|fatan|fatan2|fatanh|fconstant|fcos|fcosh|fdepth|fdrop|fdup|fexp|fexpm1|field|fill|find|fliteral|fln|flnp1|float|floats|flog|floor|floored|flush|fmax|fmin|fnegate|fnip|for|form|forth|fover|fp0|fpath|fpick|free|frot|fround|fsin|fsincos|fsinh|fsqrt|fswap|ftan|ftanh|ftuck|fvariable|getenv|gforth|here|hex|hold|i|if|iferror|immediate|implementation|include|included|init|interface|invert|is|is|j|k|key|latest|latestxt|leave|link|list|literal|load|loop|lp0|lshift|marker|max|maxalign|maxaligned|method|method|method|methods|min|mod|move|ms|naligned|name|needs|negate|new|new|next|nextname|nip|noname|nothrow|object|object|of|off|on|only|or|order|over|overrides|pad|page|parse|perform|pi|pick|postpone|postpone|precision|previous|print|printdebugdata|protected|ptr|ptr|public|query|quit|rdrop|recurse|recursive|refill|repeat|represent|require|required|resize|restore|restrict|roll|root|rot|rp0|rshift|savesystem|scope|scr|seal|search|see|selector|self|sfalign|sfaligned|sfloats|sh|sign|sliteral|source|sourcefilename|sp0|space|spaces|span|static|stderr|stdin|stdout|struct|super|swap|system|table|then|this|throw|thru|tib|to|toupper|true|try|tuck|type|typewhite|unloop|unreachable|until|unused|update|use|user|utime|value|var|var|variable|vlist|vocabulary|vocs|while|with|within|word|wordlist|words|xemit|xkey|xor)\>"
     
     ## I can't get words with symbols in their names to work :/
     #color brightgreen "(\<!\|\#\|\#\!\|\#\>\|\#\>\>\|\#s\|\#tib\|\$\?\|%align\|\%alignment\|\%alloc\|\%allocate\|\%allot\|\%size\|\'\|\'\|\'cold\|\(\|\(local\)\|\)\|\*\|\*\/\|\*\/mod\|\+\|\+\!\|\+DO\|\+field\|\+load\|\+LOOP\|\+thru\|\+x\/string\|\,\|\-\|\-\-\>\|\-DO\|\-LOOP\|\-rot\|\-trailing\|\-trailing\-garbage\|\.\|\.\"\|\.\(\|\.\\\"\|\.debugline\|\.id\|\.name\|\.path\|\.r\|\.s\|\/\|\/does\-handler\|\/l\|\/mod\|\/string\|\/w\|0\<\|0\<\=\|0\<\>\|0\=\|0\>\|0\>\=\|1\+\|1\-\|1\/f\|2\!\|2\*\|2\,\|2\/\|2\>r\|2\@\|2field\:\|2r\>\|2r\@\|\:\|\:\|\:\:\|\:\:\|\:m\|\:noname\|\;\|\;code\|\;m\|\;s\|\<\|\<\#\|\<\<\#\|\<\=\|\<\>\|\<bind\>\|\<compilation\|\<interpretation\|\<to\-inst\>\|\=\|\>\|\>\=\|\>body\|\>code\-address\|\>definer\|\>does\-code\|\>float\|\>in\|\>l\|\>name\|\>number\|\>order\|\>r\|\?\|\?DO\|\?dup\|\?DUP\-0\=\-IF\|\?DUP\-IF\|\?LEAVE\|\@\|\@local\#\|\[\|\[\'\]\|\[\+LOOP\]\|\[\?DO\]\|\[\]\|\[AGAIN\]\|\[BEGIN\]\|\[bind\]\|\[Char\]\|\[COMP\'\]\|\[compile\]\|\[current\]\|\[DO\]\|\[ELSE\]\|\[ENDIF\]\|\[FOR\]\|\[IF\]\|\[IFDEF\]\|\[IFUNDEF\]\|\[LOOP\]\|\[NEXT\]\|\[parent\]\|\[REPEAT\]\|\[THEN\]\|\[to\-inst\]\|\[UNTIL\]\|\[WHILE\]\|\\\|\\c\|\\G\|\]\|\]L\|ABORT\"\|action\-of\|add\-lib\|ADDRESS\-UNIT\-BITS\|also\-path\|assert\(\|assert\-level\|assert0\(\|assert1\(\|assert2\(\|assert3\(\|ASSUME\-LIVE\|at\-xy\|base\-execute\|begin\-structure\|bind\'\|block\-included\|block\-offset\|block\-position\|break\"\|break\:\|broken\-pipe\-error\|c\!\|C\"\|c\,\|c\-function\|c\-library\|c\-library\-name\|c\@\|call\-c\|cell\%\|cell\+\|cfield\:\|char\%\|char\+\|class\-\>map\|class\-inst\-size\|class\-override\!\|class\-previous\|class\;\|class\>order\|class\?\|clear\-libs\|clear\-path\|close\-file\|close\-pipe\|cmove\>\|code\-address\!\|common\-list\|COMP\'\|compilation\>\|compile\,\|compile\-lp\+\!\|compile\-only\|const\-does\>\|create\-file\|create\-interpret\/compile\|CS\-PICK\|CS\-ROLL\|current\'\|current\-interface\|d\+\|d\-\|d\.\|d\.r\|d0\<\|d0\<\=\|d0\<\>\|d0\=\|d0\>\|d0\>\=\|d2\*\|d2\/\|d\<\|d\<\=\|d\<\>\|d\=\|d\>\|d\>\=\|d\>f\|d\>s\|dec\.\|defer\!\|defer\@\|definer\!\|delete\-file\|df\!\|df\@\|dffield\:\|dfloat\%\|dfloat\+\|dict\-new\|docol\:\|docon\:\|dodefer\:\|does\-code\!\|does\-handler\!\|DOES\>\|dofield\:\|double\%\|douser\:\|dovar\:\|du\<\|du\<\=\|du\>\|du\>\=\|edit\-line\|ekey\>char\|ekey\>fkey\|ekey\?\|emit\-file\|empty\-buffer\|empty\-buffers\|end\-c\-library\|end\-class\|end\-class\|end\-class\-noname\|end\-code\|end\-interface\|end\-interface\-noname\|end\-methods\|end\-struct\|end\-structure\|endtry\-iferror\|environment\-wordlist\|environment\?\|execute\-parsing\|execute\-parsing\-file\|f\!\|f\*\|f\*\*\|f\+\|f\,\|f\-\|f\.\|f\.rdp\|f\.s\|f\/\|f0\<\|f0\<\=\|f0\<\>\|f0\=\|f0\>\|f0\>\=\|f2\*\|f2\/\|f\<\|f\<\=\|f\<\>\|f\=\|f\>\|f\>\=\|f\>buf\-rdp\|f\>d\|f\>l\|f\>str\-rdp\|f\@\|f\@local\#\|fe\.\|ffield\:\|field\:\|file\-position\|file\-size\|file\-status\|find\-name\|float\%\|float\+\|floating\-stack\|flush\-file\|flush\-icache\|fm\/mod\|forth\-wordlist\|fp\!\|fp\@\|fs\.\|f\~\|f\~abs\|f\~rel\|get\-block\-fid\|get\-current\|get\-order\|heap\-new\|hex\.\|how\:\|id\.\|include\-file\|included\?\|infile\-execute\|init\-asm\|init\-object\|inst\-value\|inst\-var\|interpret\/compile\:\|interpretation\>\|k\-alt\-mask\|k\-ctrl\-mask\|k\-delete\|k\-down\|k\-end\|k\-f1\|k\-f10\|k\-f11\|k\-f12\|k\-f2\|k\-f3\|k\-f4\|k\-f5\|k\-f6\|k\-f7\|k\-f8\|k\-f9\|k\-home\|k\-insert\|k\-left\|k\-next\|k\-prior\|k\-right\|k\-shift\-mask\|k\-up\|key\-file\|key\?\|key\?\-file\|l\!\|laddr\#\|lib\-error\|lib\-sym\|list\-size\|lp\!\|lp\!\|lp\+\!\#\|lp\@\|m\*\|m\*\/\|m\+\|m\:\|maxdepth\-\.s\|name\>comp\|name\>int\|name\>string\|name\?int\|new\[\]\|next\-arg\|open\-blocks\|open\-file\|open\-lib\|open\-path\-file\|open\-pipe\|os\-class\|outfile\-execute\|parse\-name\|parse\-word\|path\+\|path\-allot\|path\=\|postpone\,\|r\/o\|r\/w\|r\>\|r\@\|read\-file\|read\-line\|rename\-file\|reposition\-file\|resize\-file\|restore\-input\|rp\!\|rp\@\|S\"\|s\>d\|s\>number\?\|s\>unumber\?\|s\\\"\|save\-buffer\|save\-buffers\|save\-input\|search\-wordlist\|see\-code\|see\-code\-range\|set\-current\|set\-order\|set\-precision\|sf\!\|sf\@\|sffield\:\|sfloat\%\|sfloat\+\|shift\-args\|simple\-see\|simple\-see\-range\|sl\@\|slurp\-fid\|slurp\-file\|sm\/rem\|source\-id\|sourceline\#\|sp\!\|sp\@\|str\<\|str\=\|string\-prefix\?\|sub\-list\?\|sw\@\|threading\-method\|time\&date\|to\-this\|U\+DO\|U\-DO\|u\.\|u\.r\|u\<\|u\<\=\|u\>\|u\>\=\|ud\.\|ud\.r\|ul\@\|um\*\|um\/mod\|under\+\|updated\?\|uw\@\|w\!\|w\/o\|write\-file\|write\-line\|x\-size\|x\-width\|x\\string\-\|xc\!\+\?\|xc\-size\|xc\@\+\|xchar\+\|xchar\-\|xchar\-encoding\|xt\-new\|xt\-see\|\~\~)\>"
     
     ## Comment highlighting
     color brightblue start="(^| )\( " end="\)"
     color brightblue "\\ .*$"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Forth&oldid=205935"

Category:

-   Programming language
