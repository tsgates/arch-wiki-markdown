Arch is the best
================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Purpose                                                            |
| -   2 History                                                            |
| -   3 Install                                                            |
| -   4 The Code                                                           |
| -   5 Translations                                                       |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Purpose
-------

The Arch is the best project is a very sophisticated and exquisite,
ego-boosting and mind-blowing (albeit perhaps a bit over-engineered)
project which aims to prove Arch's superiority.

History
-------

The project was initiated in April 2008 by long time Arch community
member lucke as a simple shell script which provided irrefutable proof
that "Arch is the best". Over the following weeks, this project gathered
momentum and was ported to multiple different languages, both
programming and verbal.

Install
-------

A sample PKGBUILD has been uploaded to AUR called archbest-mod1.

The Code
--------

The "Arch is the best" project is ported to many programming languages.

  
 Ada - A systems critical programming language.

    with Ada.Text_IO;
    use Ada.Text_IO;
    procedure ArchIsTheBest is
    begin
       Put_Line("Arch is the best!");
    end HelloWorld;

ATS - A functional programming language that uses dependent types to
improve programs' reliability.

    implement main () = println! "Arch is the best!"

Awk - A data-driven programming language designed for processing
text-based data.

    BEGIN {
       print "Arch is the best!"
    }

  
 Befunge - Believed to be the first two-dimensional, ASCII-based,
general-purpose (in the sense of "you could plausibly write Hunt the
Wumpus in it") programming language.

    <v"Arch is the best!"0
     <,_@#:

  
 Bourne shell - The original program, should be compatible with any
shell.

    #!/bin/sh
    echo "Arch is the best!"

  
 Bourne shell (Alternate) - Handy for piping the output to your
favourite IRC/email/IM client. Should work with any shell.

    #!/bin/sh
    yes Arch is the best!

  
 Bourne shell (Dynamically updated)

     #!/bin/bash
     wget http://wiki.archlinux.org/index.php/Arch_is_the_best -qO-| sed -n ':b;n;s/id="Translations"//;Tb;:d;n;s/id="See_also"//;t;p;bd'|sed '/<i>.*<\/i>/d;s/<[^>]*>//g'|sed 'N;s/\n/: /;N;N;s/\n//g'

  
 brainfuck - Doesn't the language name explain it?

    ++>++++++>+++++<+[>[->+<]<->++++++++++<]>>.<[-]>[-<++>]
    <----------------.---------------.+++++.<+++[-<++++++++++>]<.
    >>+.++++++++++.<<.>>+.------------.---.<<.>>---.
    +++.++++++++++++++.+.<<+.[-]++++++++++.

  
 C - Note the three space indenting used in this project, much like that
used by other superior beings.

    #include <stdio.h>
    #include <stdlib.h>
    int main(void) 
    {
       puts("Arch is the best!");
       return EXIT_SUCCESS;
    }

  
 C# - Intended to be a simple, modern, general-purpose, object-oriented
programming language.

    using System;
    public class ArchIsTheBest
    {
       static public void Main ()
       {
          Console.WriteLine ("Arch is the best!");
       }
    }

  
 C++ - Arch == Linux++

    #include <iostream>
    #include <cstdlib>
    int main ()
    {
       std::cout << "Arch is the best!" << std::endl;
       return EXIT_SUCCESS;
    }

  
 CoffeeScript - A programming language that transcompiles to JavaScript.

    alert 'Arch is the best!'

  
 Clojure - A Lisp dialect that runs on the JVM.

    (def translations {"english" "Arch is the best!",
                       "german" "Arch ist das Beste!",
                       "australian" "Arch is fair dinkum, mate!",
                       "h4x0r" "arhc 51 7he be57!",
                       "spanish" "¡Arch es el mejor!"})
     
    (defn read-choice []
      (println "\nAvailable languages: ")
      (doall (map #(println (key %)) translations))
      (print "Enter language or Ctrl-c: ") (flush)
      (translations (read-line) :badinput))
     
    (defn arch-is-the-best []
      (loop [choice (read-choice)]
        (case choice
          :badinput (do (print "\nBad input!\n")
                        (recur (read-choice)))
          (do (print "\n" choice "\n")
              (recur (read-choice))))))

or

    (def translations {"english" "Arch is the best!",
                       "german" "Arch ist das Beste!",
                       "australian" "Arch is fair dinkum, mate!",
                       "h4x0r" "arhc 51 7he be57!",
                       "spanish" "¡Arch es el mejor!"
                       "street" "Arch iz da shizzle ma nizzle"})
    (while 1
      (println "\nPick a language:\n" (map #(key %) translations) "\n language: ")
      (println (translations (read-line) "Not a valid language")))

  
 or

    (prn "Arch is the best!")

Common Lisp - Tested on SBCL, feel free to add more of the translations.

    #!/usr/bin/sbcl --script
    (defparameter *best-list* '((English "Arch is the best!")
     			     (Chinese "Arch, 她出类拔萃!")
    			     (German "Arch ist das Beste!")
    			     (Greek "Το Arch είναι το καλύτερο!")))
    (defun aitb ()
      (format t "Available languages: ~{~{~@(~a~)~*~}~^, ~}.~%" *best-list*)
      (loop for input = (progn (format t "~&Input the desired language, (or 'quit'): ~%")
                               (force-output)
                               (read-line))
         if (string-equal input "quit")
         do (loop-finish)
         else
         do (let ((language-def
                   (assoc input *best-list*
                          :key (lambda (lang) (symbol-name lang))
                          :test #'string-equal)))
              (if language-def
                  (format t "~&~A~%" (second language-def))
                  (format t "~&Invalid language.~%"))))
      (format t "~&May the Arch be with you!~%"))
    (aitb)

  
 Common Lisp (Alternate) - Should run on any implementation (Clisp,
Allegro, SBCL...)

    (princ "Arch is the best!")

  
 Dart - Google's javascript killer

     main(){
       print('Arch is the best');
     }

  
 Erlang - A concurrent, garbage-collected programming language and
runtime system.

    -module(arch).
    -export([is_the_best/0]).
       is_the_best() -> io:fwrite("Arch is the best!\n").

Or using message passing between processes

     -module(arch).
     -export([ultimate_question/0,the_answer/0]).
     the_answer() ->
         receive
             {Client,who_is_the_best} ->
                 Client ! {self(),"Arch is the best!"};
             {Client,_} ->
                 Client ! {self(),"Taco Taco Taco!"}
         end,
         the_answer().
     ultimate_question() ->
         Pid = spawn(arch,the_answer,[]),
         Pid ! {self(),who_is_the_best},
         receive
             {Pid,Response} -> io:format("~s~n",[Response])
         end.

  

  
 Forth - Stack-based language.

    ." Arch is the best" cr -- kiss way

> Fortran95

    program arch
       print *,"Arch is the best!"
    end program arch

Genie - A new programming language, that allows for a more modern
programming style while being able to effortlessly create and use
GObjects natively.

    init
    	print "Arch is the best"

  
 Gjs - A Javascript binding for GNOME. It's mainly based on Spidermonkey
javascript engine and the GObject introspection framework.

    #!/usr/bin/env gjs
    print ('Arch is the best');

  
 Go - A language created by Google that's a love child between C, C++
and Python.

    package main

    import "fmt"

    func main() {
    	fmt.Println("Arch is the best!")
    }

  
 Haskell - The language where IO is easy and unproblematic.

    main = putStrLn "Arch is the best!"

  
 HTML - A markup language used to create and define web pages and their
content.

    <!DOCTYPE html>
    <html lang='en'>
       <head>
          <title>Arch is the best!</title>
       </head>
       <body>
           <p>Arch is the best!</p>
       </body>
    </html>

> Io

    "Arch is the best!" println

  
 Java - An extremely portable language, this will run on pretty much
anything, it might even run on your toaster!

    public class ArchIsTheBest {
       public static void main(String[] args) {
           System.out.println("Arch is the best!");
       }
    }

  
 JavaScript - Also known as ECMAScript, a prototype-based
object-oriented scripting language.

    console.log('Arch is the best!');

  
 JavaScript (in a web browser)

    alert('Arch is the best!');

  
 LilyPond - A powerful music engraving program with an intuitive
LaTeX-like input language.

    \version "2.12.3"
    \include "english.ly"
    \header { title = "Arch is the best!" }
    \score
    {
       <<
          \relative c' { c4 e g c \bar "||" }
          \addlyrics   { Arch is the best! }
       >>
    }

  
 LOLCODE - Why not?

    HAI
    CAN HAS STDIO?
    VISIBLE "ARCH IS TEH PWNZ LOL!"
    KTHXBYE

  
 Lua - A lightweight, extensible programming language.

    print "Arch is the best!"

  
 Nasm(x86_64) (or yasm) - The Netwide Assembler

    ;nasm -f elf64 arch.asm
    ;ld -o arch arch.o
    ;./arch

    section .text
    global _start
    _start:
    mov edx,len
    mov ecx,msg
    mov ebx,1
    mov eax,4
    int 0x80
    xor ebx,ebx
    mov eax,1
    int 0x80
    msg: db "Arch is the best!",10
    len equ $-msg

  
 Nimrod - Portable lightweight programming language.

    echo "Arch is the best!"

  
 Objective-C - A reflective, object-oriented programming language that
adds Smalltalk-style messaging to the C programming language.

    NSLog(@"Arch is the best!");

  
 OCaml - The main implementation of the Caml programming language.

    print_endline "Arch is the best!"

Octave - High-level interpreted language, primarily intended for
numerical computations.

    printf("Arch is the best!\n")

Perl - A high-level, general-purpose, interpreted, dynamic programming
language.

    #!/usr/bin/perl
    print "Arch is the best!\n";

  
 PHP - A general-purpose scripting language.

    <?php
       echo "Arch is the best!\n";
    ?> 

  
 Pixilang - Make me pixels.

    print("Arch is the best!",0,0,#1897D1)
    frame

  
 Portable GNU assembler - as -o arch.o arch.s && ld -o arch -O0 arch.o

       .section .data
    archIsBest:	
       .ascii 	"Arch is the best!\n"
    archIsBest_len:
       .long 	. - archIsBest
       .section .text
       .globl _start
    _start:
       xorl %ebx, %ebx
       movl $4, %eax	
       xorl %ebx, %ebx
       incl %ebx	
       leal archIsBest, %ecx
       movl archIsBest_len, %edx	
       int $0x80	
       xorl %eax, %eax
       incl %eax
       xorl %ebx, %ebx	
       int $0x80

  
 Processing - An open source programming language and IDE built for the
electronic arts and visual design.

    println("Arch is the best!");

  
 Prolog - A general purpose logic programming language associated with
artificial intelligence and computational linguistics.

    format('Arch is the best~n',[]).

  
 Python - A general-purpose high-level programming language.

    #!/usr/bin/env python3
    print('Arch is the best!')

  
 QBASIC - An interpreter for a variant of the BASIC programming language
which is based on QuickBASIC.

    PRINT "Arch is the best!"

  
 R - A language for statistical computing (and much more!).

    archIsBest <- function() { cat("Arch is the best!\n") }
    archIsBest()

  
 Ruby - A dynamic, reflective, general purpose object-oriented
programming language.

    #!/usr/bin/ruby -w
    puts 'Arch is the best!'

  
 Scala - A multi paradigm language that runs on the JVM

     object ArchIsBest extends App {
         println("Arch is the best!")
     } 

  

Scheme - A dialect of Lisp.

    (display "Arch is the best!\n")

or in Casper-Ti-Vector style

    #!/usr/bin/guile -s
    !#
    (define 节 or)
    (define 哀 #t)
    (define (xi) (display "Arch is the best!\n"))
    (节 (xi) 哀 (wen) 顺 (le) 变 (jian) )

  
 Seed - A library and interpreter, dynamically bridging the WebKit
JavaScriptCore engine, with the GNOME platform.

    #!/usr/bin/env seed
    print ('Arch is the best');

  
 Shoes - A Ruby version using Shoes for a GUI

    Shoes.app :width => 135, :height => 30 do 
        para "Arch is the Best!"
    end

  
 SQL - Structured Query Language, the query language for relational
databases

    SELECT 'Arch is the best!';
    SELECT 'Arch is the best!' from dual; -- for Oracle DB

  
 Standard ML - A general-purpose, modular, functional programming
language with compile-time type checking and type inference.

    print "Arch is the best!\n"

  
 Tcl/Tk - A scripting language that is commonly used for rapid
prototyping, scripted applications, GUIs and testing.

    #!/usr/bin/env tclsh
    puts "Arch is the best!"

  
 Vala - "Vala is a new programming language that aims to bring modern
programming language features to GNOME developers without imposing any
additional runtime requirements and without using a different ABI
compared to applications and libraries written in C"

    void main(string[] args) {
    stdout.printf("\nArch is the best!\n\n");
    }

  
 Wiring (Arduino) - Built on Processing, the open source programming
language developed at the Massachusetts Institute of Technology.

    void setup() 
    {
       Serial.begin(9600);    
    }
    void loop() 
    { 
       Serial.print("Arch is the best!");
    }

  
 X11 - X11 is an architecture independent system for display of
graphical user interfaces.

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #include <X11/Xlib.h>

    int main()
    {
           Display *d;
           Window w;
           XEvent e;
           int s;

           if (!(d = XOpenDisplay(NULL))) {
                   fprintf(stderr, "Couldn't open display, but Arch is the best!\n");
                   exit(1);
           }

           s = DefaultScreen(d);
           w = XCreateSimpleWindow(d, RootWindow(d,s), 0, 0, 110, 20, 0, 
                                   0, WhitePixel(d,s));
           XSelectInput(d, w, ExposureMask | KeyPressMask);
           XMapWindow(d,w);

           while (1) {
                   XNextEvent(d, &e);
                   if (e.type == Expose) {
                           XDrawString(d, w, DefaultGC(d, s), 5, 15, "Arch is the best!", 17);
                   }
           }

           XCloseDisplay(d);
           return 0;
    }

Translations
------------

> Arabic

    ارتش هو الأفضل

> Australian

    Arch is fair dinkum, mate!

Bahasa Indonesia

    Arch terbaik!

> Basque

    Arch onena da!

> Belarusian

    Арч - самы лепшы!

> Bengali

    আর্চ সবচেয়ে ভালো!

Binary ASCII

    0100000101110010011000110110100000100000011010010111001100100000011101000110100001100101001000000110001001100101011100110111010000100001

> British

    Arch is simply spiffing.

> Bulgarian

    Арч е най-добрият!

> Catalan

    Arch és el millor!

Chinese (Simplified)

    Arch 最棒了！

Ancient Chinese

    阿祺，盡善矣。

Chinese (Taobao Style - 淘宝体)

    Arch，好评哦，亲！

> Czech

    Arch je nejlepší!

> Danish

    Arch er bedst!

Desrever (Reversed)

    !tseb eht si hcrA

> Dutch

    Arch is de beste!

Old English

    Arch biþ betst!

> Esperanto

    Arch plejbonas!

> Estonian

    Arch on parim!

> Finnish

    Arch on paras!

> Filipino

    Mabuhay ang Arch!

> French

    Arch est le meilleur!

> Galician

    Arch é o mellor!

> German

    Arch ist das Beste!

Ancient Greek

    Ἆρχ ἄριστον!

> Greek

    Το Arch είναι το καλύτερο!

> h4x0r

    Arch 15 7h3 b357!

> Hantec

    Arch je nejbetélnější!

> Hebrew

    ארצ' זה הכי אחי!

Hexadecimal ASCII

    4172636820697320746865206265737421

> Hindi

    आर्ख सब से अच्छा है ।

> Hungarian

    Az Arch a legjobb!

> Irish

    Arch é is fearr!

> Italian

    Arch è il migliore!

> Japanese

    Archが一番ですよ！

> Kazakh

    Арч - ең жақсы!

> Latin

    Arch optimus est!

> Latvian

    Arch ir labākais!

> Lithuanian

    Arch yra geriausias!

> Marathi

    आर्च सगळ्यात भारी आहे!

> Norwegian

    Arch er best!

> Persian

    طاق بزرگ است

Pig Latin

    Archway isway ethay estbay!

> Polish

    Arch jest najlepszy!

> Portuguese

    Arch é o melhor!

> Québécois

    Arch est le plus meilleure du monde!

> Romanian

    Аrch e cel mai bun!

> Russian

    Арч - лучший!

> Serbian

    Arch je najbolji!

> Singaporean

    Arch the best lah!

> Slovenian

    Arch je najboljši!

> Spanish

    ¡Arch es el mejor!

Spanish (Argentina) - AKA "Casteshano"

    Arch es una mazza!!

> Swedish

    Arch är bäst!

> Fikonspråket

    Firch Arkon fir äkon fist bäkon

> Turkish

    Arch en iyisidir!

> Tamil

    ஆர்ச்சே சிறந்தது!

> Telugu

    ఆర్చ్ ఉత్తమమైనది!

> Ukrainian

    Arch є найкращий!

> Vietnamese

    Arch là tốt nhất!

Morse Code

    ..- -... ..- -. - ..-   .. ...   - .... .   -... . ... -

> Braille

    ⠁⠗⠉⠓⠀⠊⠎⠀⠮⠀⠃⠑⠎⠞⠲

> Base64

    QXJjaCBpcyB0aGUgYmVzdCEK

URL Encoded

    Arch%20is%20the%20best!

> ROT13

    Nepu vf gur orfg!

Upside Down

    ¡ʇsǝq ǝɥʇ s! ɥɔɹ∀

Welsh (Cymraeg)

Emphasis on being the best (one):

    Yr orau un yw Arch!
    Y gorau un yw Arch!

Emphasis on Arch:

    Arch sydd yr orau un!
    Arch sydd y gorau un!

See also
--------

-   forum Thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_is_the_best&oldid=253540"

Category:

-   About Arch
