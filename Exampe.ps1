<#
This is the rough plan for how this will work.

Subject to change as I split apart the script this started off as, and as I try to build in testing

#>
Import-Module SQLAutoRestores
Import-Module SQLPS -DisableNameChecking

$SQLconnection = New-SQLConnection 'server1\instance2'

$folders = Get-BottomFolders c:\somefolder\
$folders += Get-BottomFolders \\server2\backups$\

$RestoreFolder = Get-RandomElement $folders

$BackupObjects = Get-DBBackupObject -InputPath $RestoreFolder -ServerInstance $SQLconnection

$TimeToRestore = Get-PointInTime -BackupObjects $BackupObjects

$Objective = Get-RestoreSet -BackupsObject $BackupObjects -Latest
or
$Objective = Get-RestoreSet -BackupsObject $BackupObjects -RestoreTime $TimeToRestore

Restore-Database -BackupsObject $Objective -RestoreSQLServer $SQLconnection -RestoreTime $TimeToRestore

Test-Database -DatabaseName $Objective.Databasename -RestoreSQLServer $SQLconnection

Remove-Database -DatabaseName $Objective.Databasename -RestoreSQLServer $SQLconnection