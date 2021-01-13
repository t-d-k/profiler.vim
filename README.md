# Vim script - keyboard profiling
## Introduction
Keyboard profiling means capturing statistics about the timing of keypresses while someone is typing. It can be used to improve a users touch-typing technique, among other benefits.   
This post covers using a vim script that can record keyboard profiling data while you use vim normally.  
It may be more convenient to use Apus; the Apus application works in the background no matter what application you are typing in but is for Windows only, the vim script only works in vim.  
To use Apus instead, [see here](https://t-d-k.ixese.com/keyboard-profiling-apus)  
Later posts will cover how to analyse the results and other implications.  
## Vim Script
This vim script performs keyboard profiling, that is it measures the average timings between typing pairs of keys.  
For example the output will tell you the average time it takes you to type 'h' after 't' in milliseconds.  
This can be used to diagnose issues with touch-typing, as well as for other uses. See <https://t-d-k.ixese.com/keyboard-profiling-typing> for details of analysing the results.  
There is little point in using it unless you can touch type or are learning to.   
The script logs the frequency and timings of key pairs you type in insert mode, for best results leave it running while you type at least 10,000 characters (approx 2,000 words) of prose (not code).  
The output is written each time you save a buffer and is appended to the .csv files so you can accumulate statistics over multiple vim sessions.  
## Output
The output is written to ~/.vim/keycount.csv, ~/.vim/keycount.csv, ~/.vim/beforecount.csv and ~/.vim/beforetimes.csv 
*	keytimes.csv and keycount.csv store the raw data per key pair
*	beforecount.csv and beforetimes.csv store the data for the delay before each key is pressed
##	Analysing
To calculate your profile then takes some post processing of the data as below. 
The most useful files for troubleshooting are the before\*.csv ones as these show the delay before typing each key
For each file:
*	Open in a spreadsheet 
*	Sum the columns to get the totals over all sessions
*	Use a formula to divide the total times by the total frequencies to get the average time per keypair or key  
The spreadsheet profiling.ods (in the zip file) contains the formulae so you can simply copy your data in. 
##	Installing
To use, copy the file profile.vim to the end of your .vimrc  
After use, don't forget to delete it as the script slows down saving of files
##	More information
To interpret the profiling data to troubleshoot your touch typing, see <https://t-d-k.ixese.com/keyboard-profiling-typing>   
Keyboard profiling is also available on Microsoft Windows in all applications using the [typing utility Apus](https://apus.tdksoft.co.uk). This also performs the calculations above and analysis.
## Downloads
[vim-profiler.zip](https://github.com/t-d-k/profiler.vim/files/5809728/vim-profiler.zip) containing profile.vim, README.md and profiling.ods

©2020 by tdk. GPL License applies.   

__NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK__
