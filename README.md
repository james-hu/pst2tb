pst2tb.sh - a shell script to help batch migrating *.pst files to Thunderbird
=========

If you have lots of .pst files from Microsoft Outlook, 
and plan to convert them into something that [Thunderbird](http://www.mozilla.org/en-US/thunderbird/) can use directly,
you may find this script useful.

It will find *.pst files in the directory you specified, retrieve all the contacts and emails from them, 
then save to another directory in the format that Thunderbird can use, all in one batch.

The script depends on [bash](http://www.gnu.org/software/bash/) and [readpst](http://www.five-ten-sg.com/libpst/), 
so first make sure you have them. 
If you are a Linux user, this should not be an issue. If you are using Windows, 
you may try to install [cygwin](http://cygwin.com/) first.

To use it once you have both bash and readpst ready, 
just download it, make it executable, run it, then follow the prompts.

Below is an example:

```ShellSession
[james@localhost tmp]$ chmod +x ./pst2tb.sh
[james@localhost tmp]$ ./pst2tb.sh
=======================================================================
What is the location of those .pst files which will be converted?
  You may specify a directory in which *.pst files will be searched.
  Or, you may specify a single file.
=======================================================================
Please enter the location:
(Don't quote directory with blank characters with ""!)
/home/james/tmp/input folder
=======================================================================
Where do you want the output files to be written?
  Please specify a directory.
  Or, just enter "." if you want to specify current directory.
=======================================================================
Please enter the location:
(Don't quote directory with blank characters with ""!)
/home/james/Thunderbird Data
The directory specified does not exist.
Creating directory: /home/james/Thunderbird Data
Directory created.
=======================================================================
Please confirm:
  Files to be converted:
     "/home/james/tmp/input folder/01.pst"
     "/home/james/tmp/input folder/02.pst"
     "/home/james/tmp/input folder/03.pst"
  Output directory:
     "/home/james/Thunderbird Data"
=======================================================================
Proceed? (y/n)
y
------------------------------------------------------------------
Converting 1 of 3 : "/home/james/tmp/input folder/01.pst"
------------------------------------------------------------------
****** Converting contacts ******
Opening PST file and indexes...
... actual output skipped ...
****** Converting e-mails ******
Opening PST file and indexes...
... actual output skipped ...
------------------------------------------------------------------
Converting 2 of 3 : "/home/james/tmp/input folder/02.pst"
------------------------------------------------------------------
****** Converting contacts ******
Opening PST file and indexes...
... actual output skipped ...
****** Converting e-mails ******
Opening PST file and indexes...
... actual output skipped ...
------------------------------------------------------------------
Converting 3 of 3 : "/home/james/tmp/input folder/03.pst"
------------------------------------------------------------------
****** Converting contacts ******
Opening PST file and indexes...
... actual output skipped ...
****** Converting e-mails ******
Opening PST file and indexes...
... actual output skipped ...
----------------------------------------
Finished.
[james@localhost tmp]$ ls "/home/james/Thunderbird Data"
Contacts Mail
```
Files and subdirectories under “Mail” can be moved or copied into the local folder directory of Thunderbird directly. 
Next time you start up Thunderbird, you will see them. 
The .vcf files under “Contacts” can be imported into Thunderbird 
by the [MoreFunctionsForAddressBook plugin](http://freeshell.de//~kaosmos/morecols-en.html).

BTW, my original post about this tool is available here: 
http://james-hu.users.sourceforge.net/blog/index.php/2011/12/pst2tb/
