Kiloseconds
===========

The kiloseconds project is a very sophisticated and exquisite,
ego-boosting and mind-blowing (albeit perhaps a bit over-engineered)
project which aims to provide its audience with the time in kiloseconds,
since we cannot live without it.

Please help use out by adding programming languages to our github repo
[1]

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Awk                                                                |
| -   2 Bash                                                               |
|     -   2.1 Using seconds since 1970-01-01 00:00:00 UTC                  |
|     -   2.2 Fixed invalid date bug of above ;)                           |
|     -   2.3 Another one, using sed                                       |
|                                                                          |
| -   3 Befunge-93                                                         |
| -   4 Brainf***                                                          |
| -   5 C                                                                  |
| -   6 C++                                                                |
| -   7 C#                                                                 |
| -   8 Clojure                                                            |
| -   9 Delphi                                                             |
| -   10 Eiffel                                                            |
| -   11 Emacs Lisp                                                        |
| -   12 Erlang                                                            |
| -   13 Factor                                                            |
| -   14 Forth                                                             |
|     -   14.1 With floating point division                                |
|     -   14.2 With custom printing function                               |
|                                                                          |
| -   15 Fortran 90/95                                                     |
| -   16 Go                                                                |
| -   17 Haskell                                                           |
| -   18 IO                                                                |
| -   19 Java                                                              |
| -   20 Javascript                                                        |
| -   21 Lisp                                                              |
| -   22 LOLCODE (LOLPython)                                               |
| -   23 Lua                                                               |
|     -   23.1 Printing once                                               |
|     -   23.2 Continously looping                                         |
|                                                                          |
| -   24 Maple                                                             |
| -   25 Mathematica                                                       |
| -   26 MatLab                                                            |
|     -   26.1 Verbose code                                                |
|     -   26.2 Oneliner                                                    |
|                                                                          |
| -   27 Objective-C (Cocoa)                                               |
| -   28 OCaml                                                             |
| -   29 Openoffice.org's BASIC                                            |
| -   30 Perl                                                              |
| -   31 PHP                                                               |
| -   32 PLT Scheme                                                        |
| -   33 Powershell                                                        |
| -   34 Prolog (SWI-Prolog)                                               |
| -   35 Python                                                            |
|     -   35.1 Small example                                               |
|     -   35.2 Big example (with Ncurses)                                  |
|                                                                          |
| -   36 REBOL                                                             |
| -   37 Ruby                                                              |
| -   38 Scala                                                             |
| -   39 Sed                                                               |
|     -   39.1 Large                                                       |
|     -   39.2 Smaller                                                     |
|                                                                          |
| -   40 Smalltalk                                                         |
| -   41 Standard ML                                                       |
| -   42 Supybot                                                           |
| -   43 TCL                                                               |
| -   44 Weechat Plugin                                                    |
| -   45 IRSSI Plugin                                                      |
| -   46 Oracle SQL                                                        |
+--------------------------------------------------------------------------+

Awk
---

    #!/bin/awk -f
    BEGIN { printf("It is %s kiloseconds.\n",(strftime("%H")*3600+strftime("%M")*60+strftime("%S"))/1000); }

Bash
----

Using seconds since 1970-01-01 00:00:00 UTC

    echo "It's $((($(date +%s) - $(date +%s -d $(date +%x)))/1000)) kiloseconds."

Fixed invalid date bug of above ;)

    echo "It's $((($(date +%s) - $(date +%s -d $(LC_ALL="C" date +%x)))/1000)) kiloseconds."

Another one, using sed

    # date is only invoked once. This variant also outputs the fractional part.
    eval $(echo $(($(date +"%-H*3600+%-M*60+%-S")))|sed "s/.*/echo It is \$((&\/1000)).\$((&%1000)) kiloseconds./")

Befunge-93
----------

Befunge-93 has no way of getting the time by itself so it has to be
supplied on stdin, eg $date +"%H %M %S" | befungeinterpreter ks.bf

    0" si tI">:#,_$&"d$"**&"<"*+&+:"d"52**/.0" tniop">:#,_$"d"52**%v
    ks.bf  @$_ #!,#:<"kiloseconds."+550.<,"0"_v#`\+55:,"0"_v#`\"d":<
    Pipe date +"%H %M %S" to stdin.     ^     <            <  .:tlvb

Brainf***
---------

    [ Usage: date +"%H%M%S"|somebfinterpreter ks.bf ]

    ++++++++++>
    >>++++[<++++++++<++++++++>>-]
    ++[<+++++++>-]
    >+++++++++[<++++++++>-]<+
    >>>>>>>>>>>>++++++++++[<++++++++++>-]                
    <[<<<<<<<<<<+>+>+>+>+>+>+>+>+>+>-]
    <<<<<<<<<<->>+>+++++>+++++++>++++++++
    >>>>>+++++++++++++[<<<<+>+>+>+>-]<<<<--->-->++>+++
    >,>,>,>,>,>,>>++++++[<++++++++>-]<[<<<<<<->->->->->->-]
    <[>+<-]<[>+<-]<[>>++++++<<-]<[>>++++++<<-]
    <[>>+++>++++++<<<-]<[>>+++>++++++<<<-]
    >>>>>[>>+>+<<<-]>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<+>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<+>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<+>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<+>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<+>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<+>>>>
    ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    <[<<+>>-]
    <<<[>>>+>+<<<<-]>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<+>>>>>
    ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ]]]]]]]]]]
    <[<<<+>>>-]
    <<<<[>>>>+>+<<<<<-]>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<<+>>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<<+>>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<<+>>>>>>
    [-[-[-[-[-[-[-[-[-[-<----------<<<<<+>>>>>>
    ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    <[<<<<+>>>>-]
    >++++++[<++++++++>-]<[<<<<<+>+>+>+>+>-]
    <<<<<<<<<<<<<<<<<<.>>>>>>>>>>.<<<<<<<<<<<<.>>>>>>.>>>>>.<<<<<<<<<<<.
    >>>>>>>>>>>>>>>.>.<<<<<<<<<<<<<<< . >>>>>>>>>>>>>>>>.>.>.
    <<<<<<<<<<<<<<<<<<<.>>>>>>>.<.>>.>>.>.<<<<<<.>>>>>.<.<<<<<.>>>>>>>.
    <<<<<<<<<<<<.

C
-

    #include <stdio.h>
    #include <time.h>

    int main(void)
    {
         struct tm *t;
         time_t now;
         float ks;
         time(&now);
         t=localtime(&now);
         ks=(t->tm_hour*3600 + t->tm_min*60 + t->tm_sec);
         printf("it is %.2f kiloseconds\n",ks/1000);
         return 0;
    }

C++
---

    #include <iostream>
    #include <ctime>
    using namespace std;

    int main()
    {
        time_t now;
        time(&now);
        struct tm *t = localtime(&now);
        float ks = (t->tm_hour*3600 + t->tm_min*60 + t->tm_sec);
        cout << "it is " << ks/1000 << " kiloseconds" << endl;
    }

C#
--

    // mcs ks.cs && mono ks.exe
    using System;
    public class HelloWorld {
      static public void Main () {
        DateTime dt = DateTime.Now;
        Console.WriteLine ( Math.Round(
          (decimal)((dt.Hour * 3600 + dt.Minute * 60 + dt.Second)/1000.0),
          3).ToString());
      }
    }

Clojure
-------

    (import '(java.util Calendar))

    (defn kiloseconds
      "Current time in kiloseconds."
      []
      (let [calendar (Calendar/getInstance)
            hours (. calendar (get Calendar/HOUR_OF_DAY))
            minutes (. calendar (get Calendar/MINUTE))
            seconds (. calendar (get Calendar/SECOND))
            kiloseconds (/ (+ (* hours 3600) (* minutes 60) seconds) 1000)]
        (println (str "Kiloseconds: " (float kiloseconds)))))

    ;; call it                                                                      
    (kiloseconds)

Delphi
------

    program Kiloseconds;

    {$APPTYPE CONSOLE}

    uses
    SysUtils;

    var
    h,m,s,ms: word;
    begin
    DecodeTime(now, h, m, s, ms);
    Writeln('It is ' + FloatToStrF( (h*3600 + m*60 + s) / 1000, ffNumber, 7, 2) + ' kiloseconds.');
    end.

Eiffel
------

    class
    	APPLICATION

    inherit
    	ARGUMENTS

    create
    	make

    feature {NONE} -- Initialization

    	make
    			-- Run application.
    		local
    			time: TIME
    			kilo_seconds: INTEGER
    		do
    			create time.make_now
    			kilo_seconds := ((time.hour * 3600 + time.minute * 60 + time.second) / 1000).floor
    			io.put_integer (kilo_seconds)
    			io.new_line
    		end

    end

Emacs Lisp
----------

    (require 'cl)

    (defun ks-from-time (seconds minutes hours)
      (/ (+ seconds (* minutes 60) (* hours 3600))1000.0))

    (defun ks-time ()
      (interactive)
      (message "It's %.3f ks" (apply 'ks-from-time (subseq (decode-time) 0 3))))

    (defun erc-cmd-KS ()
      (erc-send-message
       (format "It's %.3f ks" (apply 'ks-from-time (subseq (decode-time) 0 3)))))

Erlang
------

    -module(kiloseconds).
    -export([kilotime/0]).
    kilotime() ->
    {Hour,Minutes,Seconds} = erlang:time(),
    io:format("It is ~w kiloseconds ~n", [(Hour * 3600 + Minutes * 60 + Seconds)/1000]).

Factor
------

    USING: accessors calendar kernel math prettyprint ;
    IN: kiloseconds

    : kiloseconds ( -- n )
        now [ hour>> 3600 * ] [ minute>> 60 * ]
        [ second>> ] tri + + 1000 /i ;

    : main ( -- )
        kiloseconds . ;

    MAIN: main

Forth
-----

With floating point division

Simple example using floating point to divide the total number of
seconds with 1000:

    \ This runs at least in gforth
    \ $ gforth ks.fs

    : kiloseconds ( -- r ) time&date 2drop drop 60 * + 60 * + s>f 1e+3 f/ ;
    : printkstime ( -- ) ." It is " kiloseconds f. ." kiloseconds." cr ;

    printkstime
    bye

With custom printing function

Using ANS Forths 'pictured numeric output':

    #! /usr/bin/gforth
    : shift   ( a b --  c   ) 60 * + ; 
    : seconds (     --  sec ) time&date 2drop drop shift shift ;
    : .ks     ( sec --      ) s>d <# # # # '. hold #s #> type ;
    ." it is " seconds .ks ."  kiloseconds" cr bye 

Fortran 90/95
-------------

To 17 decimal places:

    program kiloseconds
      real*8 ksec
      ksec = secnds(0.0) / 1000
      print 10, ksec
      10 format( 'It is ', F20.17, ' kiloseconds.' )
    end program

Go
--

    // 8g ks.go && 8l -o ks ks.8 && ./ks
    package main
    import fmt "fmt"
    import "time"
    func main(){
      d := time.LocalTime()
      d.Hour = 0; d.Minute = 0; d.Second = 0;
      fmt.Printf( "it is now %2.3f ks",
                  float(time.LocalTime().Seconds()-d.Seconds())/1000)
    }

Haskell
-------

    import Data.Time

    diffTimeToKiloSeconds diffTime = realToFrac diffTime / 1000
    secondsSinceMidnight = timeOfDayToTime . localTimeOfDay . zonedTimeToLocalTime
    kiloSecondsSinceMidnight = diffTimeToKiloSeconds . secondsSinceMidnight

    main = do localTime <- getZonedTime
              putStrLn $ "It's "
                         ++ show (kiloSecondsSinceMidnight localTime)
                         ++ " kiloseconds"

A version with fixed-width decimal output:

    import Data.Time
    import Numeric

    diffTimeToKiloSeconds diffTime = realToFrac diffTime / 1000
    secondsSinceMidnight = timeOfDayToTime . localTimeOfDay . zonedTimeToLocalTime
    kiloSecondsSinceMidnight = diffTimeToKiloSeconds . secondsSinceMidnight

    main = do localTime <- getZonedTime
              putStrLn $ "It's "
                         ++ showFFloat (Just 2) (kiloSecondsSinceMidnight localTime) ""
                         ++ " kiloseconds"

A version with fixed-width decimal output using printf:

    import Data.Time
    import Text.Printf

    secondsSinceMidnight :: ZonedTime -> Double
    secondsSinceMidnight = realToFrac . timeOfDayToTime . localTimeOfDay . zonedTimeToLocalTime

    main = do 
       time <- getZonedTime 
       printf "%.2f\n" (secondsSinceMidnight time / 1000)

IO
--

    Date midnight := method(self clone setHour(0) setMinute(0) setSecond(0))
    Date ks       := method((self secondsSince(self midnight) / 1000) asString exSlice(0,6))
    writeln("it is ", Date now ks, " kiloseconds")

Java
----

    import java.util.GregorianCalendar;

    public class Kiloseconds {

    	public static void main(String[] args) {
    		
    		GregorianCalendar calendar = new GregorianCalendar();
    		float hours, minutes, seconds, kiloseconds;
    		
    		hours = calendar.get(GregorianCalendar.HOUR_OF_DAY);
    		minutes = calendar.get(GregorianCalendar.MINUTE);
    		seconds = calendar.get(GregorianCalendar.SECOND);
    		kiloseconds = (hours*3600 + minutes*60 + seconds) / 1000;
    		System.out.println(kiloseconds + "\n");

    	}

    }

Javascript
----------

    ourDate = new Date();
    metricTime =  (ourDate.getHours() * 3600 + ourDate.getMinutes() * 60 + ourDate.getSeconds());
    document.write("It is: " + metricTime / 1000 + " kiloseconds.");

Lisp
----

    (multiple-value-bind (seconds minutes hours)
       (get-decoded-time)
     (print (/ (+ seconds
                  (* minutes 60)
                  (* hours 3600))
               1000.0)))

LOLCODE (LOLPython)
-------------------

LOLPython here

    IN MAI time GIMME localtime LIKE NOW
    TODAYS CAN HAZ NOW THING

    KILOSECONDS CAN HAZ EASTERBUNNY
    PILE CAN HAZ CHEEZBURGER

    KILOSECONDS GETZ ANOTHR 3600 OF THOSE TODAYS OWN tm_hour
    KILOSECONDS GETZ ANOTHR 60 OF THOSE TODAYS OWN tm_min
    KILOSECONDS GETZ ANOTHR PILE OF THOSE TODAYS OWN tm_sec

    VISIBLE "OMG IT'S" AND KILOSECONDS SMASHES INTO 1000.0 AND "KILOSECONDS"

Lua
---

Printing once

This version displays the time once

    print("It is ", (os.date("%H")*3600 + os.date("%M")*60 + os.date("%S"))/1000, " kiloseconds")

Continously looping

Time is updated once per second

    while true do
      io.write("\rIt is ", (os.date("%H")*3600 + os.date("%M")*60 + os.date("%S"))/1000, " kiloseconds")
      io.stdout:flush()
      os.execute("sleep 0.7")
    end

Maple
-----

    with(StringTools, FormatTime):
    t:= x->parse(FormatTime(x)): 
    printf("It is %2.2f kiloseconds\n", (t(%H)*3600 + t(%M)*60 + t(%S))/1000); 

Mathematica
-----------

    Drop[DateList[],3].{3600,60,1}/1000

MatLab
------

Verbose code

    function ks = kiloseconds();
    % make a clock
    c = clock;
    % get hour
    hour = c(4);
    % get minutes 
    min = c(5);
    % get seconds
    sec = c(6);
    ks = (hour*3600+min*60+sec)/1000;
    end

Oneliner

    function s=ks(); c=clock; s=sum(c(4:6).*[60^2 60 1])/1000; end

Objective-C (Cocoa)
-------------------

    NSDate *d = [NSDate date];
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:d];
    double ks = ([dc second] + [dc minute] * 60 + [dc hour] * 3600) / 1000.0;
    NSLog(@"%.3f", ks);

OCaml
-----

    #!/usr/bin/ocaml unix.cma
    open Unix;;
    let t = localtime (time ()) in 
    let ks = float_of_int (t.tm_sec + t.tm_min * 60 + t.tm_hour * 3600) /. 1000.0 in
    Printf.printf "%.3f" ks;;

Openoffice.org's BASIC
----------------------

    function Kiloseconds()
           Time = Now()
           Kiloseconds = CStr((Hour(time)*3600 + Minute(time)*60 + Second(time))/1000) + " kiloseconds"
    end function

Perl
----

    #!/usr/bin/perl
    ($s,$m,$h) = localtime();
    printf "Current time: %.3f kiloseconds.\n", ($h*3600+$m*60+$s)/1000;

PHP
---

    <?php
    list($sec, $min, $hour) = localtime(time(), false);
    echo "Time is ", ($hour * 3600 + $min * 60 + $sec) / 1000, " kiloseconds\n";

PLT Scheme
----------

    (let* ([date-struct (seconds->date (current-seconds))]
           [seconds (date-second date-struct)]
           [minutes (date-minute date-struct)]
           [hours (date-hour date-struct)])
     (display (/ (+ seconds
                    (* minutes 60)
                    (* hours 3600))
                 1000.0)))

Powershell
----------

    ((Date).get_Hour()*3600 + (Date).get_Minute()*60 + (Date).get_Second())/1000

Prolog (SWI-Prolog)
-------------------

    #!/usr/bin/env swipl -g kiloseconds -s
    kiloseconds :- 
        get_time(T), 
        stamp_date_time(T,date(_,_,_,H,M,S,_,_,_),'local'), 
        format('It is: ~f kiloseconds.~n',[(H*3600+M*60+S)/1000]).

Python
------

Small example

    import time
    tm = time.localtime()
    print (tm.tm_hour*3600+tm.tm_min*60+tm.tm_sec)/1000.0, "kiloseconds"

Big example (with Ncurses)

With fancy colours and everything ./curses_clock.py -h for usage You
have been warned

    #!/usr/bin/env python

    import curses
    import signal
    import traceback
    import time

    import getopt, sys

    DIGIT_WIDTH = 5
    DIGIT_HEIGHT = 5
    DIGIT_SPACING = 2

    '''
    _0_0_._0_0_0_
    '''

    width = 7*DIGIT_SPACING + 6*DIGIT_WIDTH 
    height = 2*DIGIT_SPACING + DIGIT_HEIGHT


    # numbers, list of coords in (y,x)

    digits = [
        [
            "#####",
            "#   #",
            "#   #",
            "#   #",
            "#####"
            ],
        [
            "  #  ",
            " ##  ",
            "  #  ",
            "  #  ",
            " ### ",
            ],
        [
            "#####",
            "    #",
            "#####",
            "#    ",
            "#####",
            ],
        [
            "#####",
            "    #",
            " ####",
            "    #",
            "#####",
            ],
        [
            "#   #",
            "#   #",
            "#####",
            "    #",
            "    #",
            ],
        [
            "#####",
            "#    ",
            "#####",
            "    #",
            "#####",
            ],
        [
            "#####",
            "#    ",
            "#####",
            "#   #",
            "#####",
            ],
        [
            "#####",
            "    #",
            "    #",
            "    #",
            "    #",
            ],
        [
            "#####",
            "#   #",
            "#####",
            "#   #",
            "#####",
            ],
        [
            "#####",
            "#   #",
            "#####",
            "    #",
            "    #",
            ],
        [
            "",
            "",
            "",
            "",
            "  # ",
            ],
    ]

    def draw_digit(win, digit, y, x):
        sections = digits[digit]
        position = 0
        for section in sections:
            xpos = x
            for char in section:
                if char == ' ':
                    win.addstr(position+y, xpos, ' ', curses.color_pair(0))
                else:
                    win.addstr(position+y, xpos, ' ', curses.color_pair(1))
                xpos += 1
            position += 1

    def draw_time(win, digits):
        h,w = win.getmaxyx()
        x_pos = (w - width) / 2
        y_pos = (h - height) / 2
        x_pos += DIGIT_SPACING
        y_pos += 1
        digits.insert(2, 10) #add in the point
        for d in digits:
            draw_digit(win, d, y_pos, x_pos)
            x_pos += (DIGIT_SPACING + DIGIT_WIDTH)

    def tick(win):
        tm = time.localtime()
        t = ks = tm.tm_hour*3600 + tm.tm_min*60 + tm.tm_sec
        a = ks/10000; ks -= a*10000
        b = ks/1000; ks -= b*1000
        c = ks/100; ks -= c*100
        d = ks/10; ks -= d*10
        e = ks
        draw_time(win, [a,b,c,d,e])
        return t
        
    def draw_dots(win):
        h,w = win.getmaxyx()
        x_pos = (w - width) / 2
        y_pos = (h - height) / 2
        win.hline(y_pos,x_pos,curses.ACS_BULLET, width, curses.color_pair(2))
        win.hline(y_pos+DIGIT_HEIGHT+1,x_pos,curses.ACS_BULLET, width, curses.color_pair(2))
        win.vline(y_pos+1,x_pos,curses.ACS_BULLET, DIGIT_HEIGHT, curses.color_pair(2))
        win.vline(y_pos+1,x_pos+width-1,curses.ACS_BULLET, DIGIT_HEIGHT, curses.color_pair(2))


    def init_screen():
        screen = curses.initscr()
        curses.noecho()
        curses.cbreak()
        screen.clear()
       
    def main(screen, fg, bg):
        curses.curs_set(0) #hide cursor
        screen.nodelay(1) # do not wait for input

        curses.use_default_colors()

        curses.init_pair(1, fg, fg)
        curses.init_pair(2, fg, bg)

        screen.bkgd(' ', curses.color_pair(2))

        def screen_resize(*args):
            while 1:
                try: curses.endwin(); break
                except: time.sleep(1)
            screen.erase()
            draw_dots(screen)
            screen.refresh()

        signal.signal(signal.SIGWINCH, screen_resize)

        draw_dots(screen)


        t = None
        while True:
            newtime = tick(screen)
            if t != newtime:
                screen.refresh()
            t = newtime

            c = screen.getch()
            if c == ord('q'):
                break
            
            time.sleep(0.5)


    def usage():
        print '''curses_clock.py [OPTION]

      -h, --help displays this help
      -f, --fg=COLORCODE sets the foreground color to COLORCODE
      -b, --bg=COLORCODE sets the background color to COLORCODE


    Color codes available:
      default term fg/bg -1
      black   0
      red     1
      green   2
      yellow  3
      blue    4
      magenta 5
      cyan    6
      white   7
    '''



    if __name__ == '__main__':
        bg = 0
        fg = 7

        def do_color(arg):
            try:
                color = int(arg)
            except:
                color = -1
            if not -1 <= color <= 7:
                print "Color code not in correct range"
                usage()
                sys.exit(2)
            else:
                return color
                

        try:
            opts, args = getopt.getopt(sys.argv[1:], "hf:b:", ["help", "fg=", "bg="])
        except getopt.GetoptError:
            usage()
            sys.exit(2)

        for opt, arg in opts:
            if opt in ("-h", "--help"):
                usage()
                sys.exit()
            elif opt in ("-f", "--fg"):
                fg = do_color(arg)
            elif opt in ("-b", "--bg"):
                bg = do_color(arg)


        curses.wrapper(main, fg, bg)

REBOL
-----

     REBOL [ Title: "kiloseconds" File: %ks.r ]
     f: to integer! now/time
     print f / 1000

Ruby
----

    puts((Time.now.sec + Time.now.min*60 + Time.now.hour*3600) / 1000.0)

Scala
-----

Could be done shorter, but this demonstrates some nice Scala features.

    import java.util.Calendar

    object Kilosecond {
        private implicit def enrichCalendar(c: Calendar) = new CalendarWrapper(c)

        def main(args: Array[String]) = {
            val c = Calendar.getInstance

            println("Kiloseconds: " + c.kiloseconds)
        }

        private class CalendarWrapper(c: Calendar) {
            def kiloseconds = {
                val hours = c.get(Calendar.HOUR_OF_DAY)
                val minutes = c.get(Calendar.MINUTE)
                val seconds = c.get(Calendar.SECOND)

                (hours * 3600 + minutes * 60 + seconds) / 1000.0
            }
        }
    }

Sed
---

> Large

run with sed -f ks.sed

    :ck;h
        s/^[0-2][0-9] [0-5][0-9] [0-5][0-9]$//;tok
        s/.*/Supply time on stdin in a format corresponding to what date "+%H %M %S" would output/
        b
    :ok;x
    :s; s/^\(.. ..\) \(..\)/\1 000\2/;tm
    :m; s/^.. .0/& 00000/;tm1
        s/^.. .1/& 00060/;tm1;  s/^.. .2/& 00120/;tm1;  s/^.. .3/& 00180/;tm1
        s/^.. .4/& 00240/;tm1;  s/^.. .5/& 00300/;tm1;  s/^.. .6/& 00360/;tm1
        s/^.. .7/& 00420/;tm1;  s/^.. .8/& 00480/;tm1;  s/^.. .9/& 00540/;tm1
    :m1;s/^.. 0./& 00000/;th0
        s/^.. 1./& 00600/;th0;  s/^.. 2./& 01200/;th0;  s/^.. 3./& 01800/;th0;
        s/^.. 4./& 02400/;th0;  s/^.. 5./& 03000/;th0
    :h0;s/^.0 ../& 00000/;th1
        s/^.1 ../& 03600/;th1;  s/^.2 ../& 07200/;th1;  s/^.3 ../& 10800/;th1
        s/^.4 ../& 14400/;th1;  s/^.5 ../& 18000/;th1;  s/^.6 ../& 21600/;th1
        s/^.7 ../& 25200/;th1;  s/^.8 ../& 28800/;th1;  s/^.9 ../& 32400/;th1
    :h1;s/^0. ../00000/;tsp
        s/^1. ../36000/;tsp
        s/^2. ../72000/;tsp
    :sp;s/$/|/
    :d4;s/\<\(.\)\(....\>.*|.*\)/\2\1/;td4; s/$/ /
    :d3;s/\<\(.\)\(...\>.*|.*\)/\2\1/;td3; s/$/ /
    :d2;s/\<\(.\)\(..\>.*|.*\)/\2\1/;td2; s/$/ /
    :d1;s/\<\(.\)\(.\>.*|.*\)/\2\1/;td1; s/$/ /
    :d0;s/\<\(.\)\(\>.*|.*\)/\2\1/;td0; s/$/ /
    :c0;s/.*|//
        s/0//g
        s/1/o/g
        s/2/oo/g
        s/3/ooo/g
        s/4/oooo/g
        s/5/ooooo/g
        s/6/oooooo/g
        s/7/ooooooo/g
        s/8/oooooooo/g
        s/9/ooooooooo/g
    :+; s/\(.*\) oooooooooo\(.*\)/\1o \2/;t+
    :c1;s/ooooooooo /9/g
        s/oooooooo /8/g
        s/ooooooo /7/g
        s/oooooo /6/g
        s/ooooo /5/g
        s/oooo /4/g
        s/ooo /3/g
        s/oo /2/g
        s/o /1/g
        s/ /0/g
    :c2;s/\(..\)\(...\)/It is \1.\2 kiloseconds./
    :zp;s/0\(.\)\./\1./

> Smaller

run with sed -f ks.sed

    :00;s/^[0-2][0-9] *[0-5][0-9] *[0-5][0-9]$/&/;t02
    :01;s/.*/Suggestion: date "+%H %M %S" | stdin./;q
    :02;s/ //g;x;s/^/5/;x;t03
    :03;s/^\(|*\)0/\1/;t08;s/^\(|*\)9/\1|||||||||/;t08;
    :04;s/^\(|*\)1/\1|/;t08;s/^\(|*\)8/\1||||||||/;t08;
    :05;s/^\(|*\)2/\1||/;t08;s/^\(|*\)7/\1|||||||/;t08;
    :06;s/^\(|*\)3/\1|||/;t08;s/^\(|*\)6/\1||||||/;t08;
    :07;s/^\(|*\)4/\1||||/;t08;s/^\(|*\)5/\1|||||/;t08;
    :08;x;s/0//;x;t0d;:tlvb
    :09;x;s/5/4/;s/3/2/;s/1/0/;x;t0b
    :0a;x;s/4/3/;s/2/1/;x;t0c
    :0b;s/|/||||||||||/g;t03;b03
    :0c;s/|/||||||/g;t03;b03
    :0d;s/|\{10\}/{/g;s/{$/{0/;
    :0e;s/{\{10\}/}/g;s/}\([|0]\)/}0\1/
    :0f;s/}\{10\}/(/g;s/(\([{0]\)/(0\1/
    :10;s/(\{10\}/)/g;s/)\([}0]\)/)0\1/
    :11;y/|{}()/{}()+/
    :12;s/+\{9\}/9/;s/+\{8\}/8/;s/+\{7\}/7/;s/+\{6\}/6/;
    :13;s/+\{5\}/5/;s/+\{4\}/4/;s/+\{3\}/3/;s/+\{2\}/2/;
    :14;s/+/1/;s/[|{}()]/&/;t11
    :15;s/^.\{0,3\}$/0&/;t15;
    :16;s/\(.*\)\(.\{3\}\)/It is \1.\2 kiloseconds./

Smalltalk
---------

    'It is ', (Time now asSeconds/1000.000) printString, ' kiloseconds'

Standard ML
-----------

    open Date;
    let
      val t = fromTimeLocal (Time.now ())
      val ks = real (second t + minute t * 60 + hour t * 3600) / 1000.0
    in
      print (Real.fmt (StringCvt.FIX (SOME 3)) ks)
    end;

Supybot
-------

    echo Today is [Math calc [echo ($YEAR * 365 + $MONTH * 12 + $DATE * 24) / 1000]] and the time is currently 
    [Math calc [echo ($HOUR * 3600 + $MINUTE * 60 + $SECOND)/1000]] $TZ.

TCL
---

    puts "It's [expr [clock format [clock seconds] -format {(%k*3600+%M.0*60+%S.0)/1000}]] kiloseconds"

Weechat Plugin
--------------

Requires weechat version 0.3.0+

    kiloseconds.py

IRSSI Plugin
------------

    #!/usr/bin/perl

    use vars qw($VERSION %IRSSI);
    use Irssi;
    use strict;
    $VERSION = '0.10';
    %IRSSI = (
       authors	=> 'Ben Duffield',
       contact	=> 'jebavarde AT gmail DOT com',
       name	=> 'kiloseconds',
       description	=> 'Reports the time in kiloseconds',
       license	=> 'GPL',
       url		=> 'https://wiki.archlinux.org/index.php/Kiloseconds',
       changed	=> 'no idea',
    ); 
     

    sub cmd_kiloseconds {
        my ($data, $server, $witem) = @_;
        my $output;
        my $ks;
        my $s;
        my $m; 
        my $h;

        ($s,$m,$h) = localtime();
        $ks = ($h*3600+$m*60+$s)/1000; 

        $output = sprintf("Current time: %.3f  kiloseconds", $ks);
     

        if ($output) {
    	if ($witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
    	    $witem->command("MSG ".$witem->{name}." $output");
    	}
    	else {
    	    Irssi::print("This is not a channel/query window :b");
    	}
        }
    }

    Irssi::command_bind('kiloseconds', 'cmd_kiloseconds');

Oracle SQL
----------

    select ((to_char(sysdate,'HH')*60*60)+(to_char(sysdate,'MM')*60)+(to_char(sysdate,'SS')))/1000 
    as "Kiloseconds" from dual

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kiloseconds&oldid=238850"

Category:

-   Development
