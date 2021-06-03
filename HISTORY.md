## HISTORY - A FLASHBACK YOU CAN SKIP IF YOU WANT

   When early computing platforms emerged every vendor had 
   different operating systems and platform-specific programming
   languages. It was hard to even share simple text files, as what bit
   pattern represents a particular character is rather arbitrary.

   But a few standards started emerging, several based on how to represent
   the basic American-ized Roman alphabet. This allowed some basic devices
   such as simple printers to support multiple platforms. Customers
   often had computers from multiple vendors and did not want to
   have separate printers, COM machines (microfiche -- look it up),
   data archives, and (later) terminals for each computer type they
   used. So this standardization was largely driven to allow customers to
   exchange data between their systems and get shared use of peripheral
   devices. A lot of the vendors that already had a large market share
   did not really want to standardize as it allowed newcomers into their
   markets; but standards did emerge. And the computer vendors for the
   most part were ooncentrating on their computers -- not printers and
   terminals (That was lucky for the likes of Xerox and HP who made a
   lot of money from printing, and Lear Zeigler and Tektronix who did
   pretty well with terminals and graphics displays).

   As new-fangled interactive computing evolved from using line printers
   to monochrome terminals the terminals at first very much emulated
   line printers and just serially printed a single fixed-space font
   (yes, printers were once a principal input as well as an output
   device. You typed in your input much as if using a typewriter (if
   you know what that was) and the computer typed back a response --
   hard to even image today).

   So one device that could take advantage of the newly standardized
   characters and one of the few early devices that could often be used
   cross-platform to some extent became the video terminal (briefly,
   at least).

   But terminals quickly evolved to allow very un-teletype-like behavior
   such as clearing screen regions, cursor positioning, and supporting
   various font sizes and display sizes (some could even beep!).
   These new features continued to be accessible from almost any
   language because they were typically accessed by sending in-band
   signaling. That is, they used the bit patterns that did not represent
   printable characters to access these new features (The new features
   were triggered by sending signals in the same way characters were
   sent to the terminals, so it was just special "character patterns"
   that triggered the new features). Initially, graphics was done this
   way as well. The beauty of that was that almost any language could be
   used to generate text and graphics, as essentially all general-purpose
   languages can write an output stream.

   But these new devices all used different sequences to trigger the new
   features. This drove developers to create an abstraction layer than
   could be given the same command by the users. The interface would
   translate the generic request to the specific sequence a particular
   device required. This meant you talked through these "translators"
   to most devices for anything but basic text printing. For Unix,
   this meant that you wrote a program to control a terminal by using
   "terminfo" and "termlib" interfaces, and libraries like "curses" and
   "ncurses", which hid the hardware differences from your programs
   and even allowed for some object-oriented behavior like creating
   (text-only) windows on your screen - those are still used to this day.

   So by now the printable character set had pretty much settled down to
   the current "ASCII" character set and EBCDIC (mostly on IBM platforms).
   A few other ANSI ASCII character sets lingered on for a while but
   were on the way out (there were several ANSI standards -- Display
   Code which only supported uppercase, ASCII 6/12 which required two
   "characters" to represent a lowercase letter, ...). This was long
   before UNICODE, so there were not many character glyphs, but this
   character set was pretty much now ubiquitious.

   Well, keyboards were not even standardized early-on, so you might
   not have a tilde or pound key to hit though!

   But what about those display control sequences? 

   So next there was an effort (really, a battle but that is a story
   all unto itself) to standardize the control sequences themselves and
   eliminate some of this complexity.

   The ANSI control sequence standard emerged and was becoming relatively
   common at least as a submode on most non-IBM terminals just when
   graphics displays and windowing systems emerged. Simple terminals
   began to vanish just as some sense was being made of it all.

   But that is where the "ANSI color sequences" came from. And the good
   news is once terminals were almost all just terminal emulators almost
   every remaining command-line interface accepted these hard-fought
   standardized control sequences. Microsoft Console windows were the
   basic holdout along with IBM TN3220 terminals -- but there were
   options even for those. Microsoft Windows 10 consoles now have a
   relatively easy to activate ANSI compatibility mode! They were trying
   to get people to quit using terminals, so I suppose there was not
   much motivation to make a good terminal emulator.

   Highly-extended Fortran owned most graphics and utilities still
   unsurpassed let you easily format screens from Fortran (most
   machines did not even have a C compiler, "everyone" had extended
   Fortran). Utilities like the CDC NOS TDU interface and a variety of
   packages on Digital VMS let you build multi-window terminal interfaces
   in a few minutes from Fortran.

   And now we are back to how to simply color your terminal output from
   Fortran. How that happened is an even longer story.

   The result of this chain of events is that there are special
   character sequences you can write to stdout that let you color your
   terminal output on just about any CLI interface you are likely
   to encounter.

   The drawback is if you are not writing to a screen you will have
   funny non-printable characters in your file, but we will handle that.

   And we will be able to do this without knowing what TDU (Terminal
   Definition Utility), tic(1), terminfo(5), termlib(5), tput(1), and
   ncurses(3c) even are. It comes down now to just printing a few 
   constant strings and a few bells and whistles around doing that.

   Did you learn some new words? Teletype, Display Code, microfiche and
   line-printer do not come up a lot anymore.
