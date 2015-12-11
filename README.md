###  quick home automation
###### for the little things in everyday life

Typically there are a lot of things that are needed to be done but I just done have the time to do it.  Backups, conversion, archive ...etc.  Sure it can be done with a cron job, but then with a few modification - these scritps can be ported.  Mostly written in Ruby :)

1. #### [convert.rb](./01convert.rb)
For those who use old iPhones, off-contract - its sometimes hard to watch movies on it.  So if you have a digital copy of a movie or a show, feel free to convert it using [handbrke](https://handbrake.fr/downloads.php).  This will convert all .AVI, .MOV, .MP4, .MKV videos and burn in all subtitles.  Also make nice directories.  Will also flip all your videos - so if you exported sometime from an iPhone - and its all funny sideways, then this will flip it to the correct orientation.  Never converts the same movie twice - so run as many times as you want.
    For Photo mode - will look at all the EXIF data, and sort all the .JPG files.
    Takes in 3 mandatory arguments (one optional).
    * ```-m``` for the mode - either *movie* or *photo*
    * ```-i``` for the input direcotry.  Windows style ```c:\path\to\dir``` or linux style ```/home/user/dir```
    * ```-o``` for the output direcotry, just like the inputer diretory
    * ```--norename``` to avoid renaming movie files

    **Note:**  This requires [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) - just need to download the standalone tool, and point the script at it.  Maybe a TODO later on?

2. #### [adobe.cmd](./02adobe.cmd)
Run with Admin priviledges - to disable the annoying Adobe context menu.  Its when you right click on stuff and it has all these options to do things to a file with Adobe.  Thanks adobe ... we like you, but not too that much to commit to looking at your menus all day.

3. #### [Windows Port Forwarding](./03winPortFwd.ps1)
Sometimes there is a need to run application and connect to it from outside the network.  Some applications don't like to be connected to outside of the local network.  We can port-forward to localhost.  Usage:
    1. Start Windows powershell as Administrator
    2. Navigate to the git cloned direcotry
    3. ```.\winPortFwd.ps1 -from 10045 -to 32400```
    This example uses [plex media server](https://plex.tv/) to route traffic to localhost.  If you can set up port forwarding on your local router - then you can enjoy watching movies from anywehre - and streaming them from your home server :)

4. #### [backups.cmd](./04makebackups.rb)
Backups are done with [FreeFileSync](http://www.freefilesync.org/).  Sorry, windows only :(  This program has a nice batch funciton which is very customizable.
