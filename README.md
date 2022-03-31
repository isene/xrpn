# XRPN

## Introduction

XRPN is a stack-based programming language, similar to [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)), but simpler in nature.

XRPN is on-the-fly extensible. Language functions can be upgraded or implemented while programs are running.

It runs programs in text files or manually in debug mode (if no text file is supplied or when a program stops).

The language is a superset of [FOCAL](https://www.hpmuseum.org/prog/hp41prog.htm), implementing the full set of [HP-41CX calculator](https://www.hpmuseum.org/hp41.htm) commands. It uses Reverse Polish Notation for calculations.

XRPN implements indirect adressing, self-modification and features well beyond the FOCAL language.

## Install

To install XRPN, simply clone this repository and run the script `INSTALL.sh`. It is only tested on Linux but should work well on Mac OS and BSD systems. If you are on Windows, please tell me if it works in that environment. The install script will put create a symbolic link in your home directory - named ".xrpn" to make it a hidden directory - pointing to the cloned repo. It will also attempt to add a symlink to "~/bin" to make it easy to run XRPN.

A Gemfile will be created soon that will make all this a lot easier.

## Run

To run XRPN, make sure the brogram file ("bin/xrpn") is copied or linked to a directory in your path. If you have "~/bin" in your path, the install scrip has already taken care of this. Simply run the environment via `xrpn` in a terminal to enter the "debug mode" and manually issue commands or do calculations. To run a program, save it in a textfile (like "myprogram.txt") and run `xrpn -f myprogram.txt` to let xrpn execute it. 

## FOCAL and the HP-41 system

Since XRPN covers the function set of the HP-41CX calculator, you now have an environment where thousands of HP-41 calculator programs can run. You have at your fingertips programs covering engineering, finance, chemistry and physics to navigation, astronomy, forecasting, statistics and most areas of science and mathematics. With the enhanced features, you can make self-modifying programs, capture web pages, get full regexp capabilities, manipulate files and plenty more.

With more than 250 built-in functions, I have some documenting ahead of me. Documentation will be added to the wiki in this repo. For now, you can get the [full documentation for the HP-41CX here (vol 1)](extra/HP-41CX_OwnersManualVol1.pdf) and [here (vol 2)](extra/HP-41CX_OwnersManualVol1.pdf). Note that I have not yet implemented the clock, the alarm and stopwatch functionality of the HP-41CX as I can't yet see much benefit to that. The functions TIME, DATE, DATE+, DDAYS, DOW, HR, HMS, HMS+, HMS- are implemented.

Any and all feedback is welcome. Send me an e-mail at `g@isene.com`.

More to come :-)

