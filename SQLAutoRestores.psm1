Push-Location
Import-Module SqlPS -DisableNameChecking
Pop-Location

. $PSScriptRoot\Functions\function-Get-BottomFolders.ps1
. $PSScriptRoot\Functions\function-Get-DBBackupObject.ps1
. $PSScriptRoot\Functions\function-Get-FileRestoreMove.ps1
. $PSScriptRoot\Functions\function-Get-PointInTime.ps1
. $PSScriptRoot\Functions\function-Get-RandomElement.ps1
. $PSScriptRoot\Functions\function-Get-RestoreSet.ps1
. $PSScriptRoot\Functions\function-New-BackupObject.ps1
. $PSScriptRoot\Functions\function-New-SQLConnection.ps1
. $PSScriptRoot\Functions\function-Remove-Database.ps1
. $PSScriptRoot\Functions\function-Restore-Database.ps1
. $PSScriptRoot\Functions\function-Restore-SQLBackupHeader.ps1
. $PSScriptRoot\Functions\function-Test-BackupObject.ps1
. $PSScriptRoot\Functions\function-Test-Database.ps1
. $PSScriptRoot\Functions\function-Test-DatabaseVersion.ps1
. $PSScriptRoot\Functions\function-Test-RestoreSpace.ps1
. $PSScriptRoot\Functions\function-Test-DBBackupsExist.ps1
. $PSScriptRoot\Functions\function-Test-DatabaseExists.ps1

Export-ModuleMember 

Export-ModuleMember Get-BottomFolders    
Export-ModuleMember Get-DBBackupObject    
Export-ModuleMember Get-FileRestoreMove   
Export-ModuleMember Get-RandomElement   
Export-ModuleMember Get-RestoreSet        
Export-ModuleMember Remove-Database     
Export-ModuleMember Restore-Database    
Export-ModuleMember Test-Database
Export-ModuleMember Test-DatabaseExists     
Export-ModuleMember Test-DatabaseVersion
Export-ModuleMember Test-RestoreSpace
Export-ModuleMember Restore-SQLBackupHeader
Export-ModuleMember Test-BackupObject
Export-ModuleMember New-BackupObject
Export-ModuleMember Get-PointInTime
Export-ModuleMember New-SQLConnection
Export-ModuleMember Test-DBBackupsExist

