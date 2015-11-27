###  quick home automation
###### for the little things in everyday life

Typically there are a lot of things that are needed to be done but I just done have the time to do it.  Backups, conversion, archive ...etc.  Sure it can be done with a cron job, but then with a few modification - these scritps can be ported.  Mostly written in Ruby :)

* #### [convert.rb](./convert.rb)
For those who use old iPhones, off-contract - its sometimes hard to watch movies on it.  So if you have a digital copy of a movie or a show, feel free to convert it using [handbrke](https://handbrake.fr/downloads.php).  This will convert all .AVI, .MOV, .MP4, .MKV videos and burn in all subtitles.  Also make nice directories.  Will also flip all your videos - so if you exported sometime from an iPhone - and its all funny sideways, then this will flip it to the correct orientation.  Never converts the same movie twice - so run as many times as you want.

For Photo mode - will look at all the EXIF data, and sort all the .JPG files.

Takes in 3 mandatory arguments (one optional).
+ ```-m``` for the mode - either *movie* or *photo*
+ ```-i``` for the input direcotry.  Windows style ```c:\path\to\dir``` or linux style ```/home/user/dir```
+ ```-o``` for the output direcotry, just like the inputer diretory
+ ```--norename``` to avoid renaming movie files

**Note:**  This requires [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) - just need to download the standalone tool, and point the script at it.  Maybe a TODO later on?

* #### [adobe.cmd](../adobe.cmd)
Run with Admin priviledges - to disable the annoying Adobe context menu.  Its when you right click on stuff and it has all these options to do things to a file with Adobe.  Thanks adobe ... we like you, but not too that much to commit to looking at your menus all day.

* #### [Windows Port Forwarding](./winPortFwd.ps1)
Coming soon