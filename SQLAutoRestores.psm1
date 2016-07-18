Push-Location
Import-Module SqlPS -DisableNameChecking
Pop-Location

. $PSScriptRoot\function-Get-BottomFolders.ps1     
. $PSScriptRoot\function-Get-DBBackupObject.ps1    
. $PSScriptRoot\function-Get-FileRestoreMove.ps1   
. $PSScriptRoot\function-Get-RandomElement.ps1     
. $PSScriptRoot\function-Get-RestoreSet.ps1        
. $PSScriptRoot\function-Remove-Database.ps1       
. $PSScriptRoot\function-Invoke-RestoreDatabase.ps1      
. $PSScriptRoot\function-Test-Database.ps1         
. $PSScriptRoot\function-Test-DatabaseVersion.ps1  
. $PSScriptRoot\function-Test-RestoreSpace.ps1     