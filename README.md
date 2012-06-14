SQLZipdata
==========

SQL Script to convert Zip*Data from MelissaData Flat files to SQL

Directions:

You must have a subscription to Melissa Data Zip*data service. They will send you a zip file.
Put all the *.DAT files in a folder name C:\Zipdata
Run the script on your SQL server.


NOTE: If you get some error message barking about OLE Automation procedures run this first

sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE WITH OVERRIDE 
GO