# SQLAutoRestores

## Update 20/07/2017
This module is now historical. All of the functionality is now avaialble in the [dbatools](https://dbatools.io) module. The repo for that project is here [dbatools on GtiHub](github.com/sqlcollaborative/dbatools)

## Back to the ReadMe

PowerShell module to allow easy automated restoration of SQL Server backups to promote testing them.

Aim is to be able to be given a set of folders containing SQL Server backups (Full, Differential or Transaction), pick one of the folders at random, scan the backup files to ensure we have a good set. Then restore them on a server of the users choosing, redirecting them to a folder of choice, after checking that there is enough space on the target server and that the SQL Server versions are compatible.

Once it's been restored succesfully it will allow the user to run DBCC checks against the database, or a test script of their choosing.

All results, files and other information should then be available for email or logging.

Work in progress based on some ad-hoc scripts that have worked fine, but aren't necessarily ready for public consumption.

Any comments and thoughts welcomed.

Current running order would look like this:
```powershell
Import-Module .\SQLAutoRestores.psm1

#GEt connection to SQL Server we're going to restore onto
$SQLconnection = New-SQLConnection 'server1\instance2'


#get all the possible folders holding SQL Server backups
$folders = Get-BottomFolders c:\somefolder\
$folders += Get-BottomFolders \\server2\backups$\

#Pick a folder at random, then check it holds SQL Server backups, if not pick another, keep going till we get one
$RestoreFolder = Get-RandomElement $folders
while (!(Test-DBBackupsExist $RestoreFolder)){
 $RestoreFolder = Get-RandomElement $folders                    
}

#Pass in the files we found to return an object holding all the info from the file headers. Also checks for multiple backups inside a file
$BackupObjects = Get-DBBackupObject -InputPath $RestoreFolder -ServerInstance $SQLconnection



#Pick a time to restore to based on the coverage of the backups found above, or we could just set the variable to the one we want to use
$TimeToRestore = Get-PointInTime -BackupsObject $BackupObjects




#Or just restore to the latest point held in the files
$Objective = Get-RestoreSet -BackupsObject $BackupObjects -Latest
#or
$Objective = Get-RestoreSet -BackupsObject $BackupObjects -TargetTime $TimeToRestore

#Redirect the files to the required location on restore server
$Objective = Get-FileRestoreMove -BackupsObject $Objective -DestinationPath e:\some\path

#Check if DB name exists
Test-DatabaseExists -RestoreSQLServer $SQLconnection -DatabaseName $Objective[0].DatabaseName

#check for space
Test-RestoreSpace -BackupsObject $Objective -RestoreSQLServer $SQLconnection -RestorePath e:\some\Path

#Check we can restore the db on the specified server version
Test-DBRestoreVersion -BackupsOject $Objective -RestoreSQLServer $SQLconnection


#Restore the Database
Restore-Database -BackupsObject $Objective -RestoreSQLServer $SQLconnection -RestoreTime $TimeToRestore

#Test it's OK (currently just a DBCC check)
Test-Database -DatabaseName $Objective.Databasename -RestoreSQLServer $SQLconnection

#Clear down the restored DB so we can do it all over again with another one.
Remove-Database -DatabaseName $Objective.Databasename -RestoreSQLServer $SQLconnection
```
