function Restore-Database
{
 <#
  .SYNOPSIS
    Restores a set of SQL backup files
  .DESCRIPTION
    Given a set of SQL Server backup files restores the files up to the specified point in time, or completely if not specified. Can also generate the restore scripts for the actions. 
  .EXAMPLE
    Restore-Database -Backups $Backups -RestoreSQLServer $sqlvr
  .PARAMETER BackupsObject
    A list of SQL backups, as provided by Get-RestoreSet
  .PARAMETER RestoreSQLServer
    A SQL server SMO connection object
  .PARAMETER Script
    A switch to indicate if T-SQL restore Scripts should be generated
  .PARAMETER ScriptOnly
    A switch to indicate if only T-SQL restore scripts should be generated (no restore is performed)
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [Alias('BackupObject')]
    [object]$BackupsObject,
    [Parameter(Mandatory=$True)]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$RestoreSQLServer,
    [Switch]$Script,
    [Switch]$ScriptOnly
  )
  Write-Verbose "Restore-Database - Entering " 
  $devicetype = [Microsoft.SqlServer.Management.Smo.DeviceType]::File
  foreach ($backup in ($BackupsObject | sort-object LastLSN, startdate)){
    Write-Verbose "Remove-Database - Restoring file " 
    $restore = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Restore
    $restoredevice = New-Object -TypeName Microsoft.SQLServer.Management.Smo.BackupDeviceItem($backup.filename,$devicetype)
    $null =  $restore.devices.add($restoredevice)
    $restore.Database = $backup.DatabaseName
    foreach ($f in $backup.RelocateFile){
        $null =  $restore.RelocateFiles.add($f)
    }
    if ($backup.LastLSN -eq $BackupsObject[-1].LastLSN){
        Write-Verbose "Remove-Database - At endpoint, start recovery " 
        $restore.NoRecovery = $False
    }else{
        $restore.NoRecovery = $True
        Write-Verbose "Restore-Database - Not at endpoint" 
    }
    if ($script -or $scriptOnly){
        $restore.sqlrestore($RestoreSQLServer)
    }
    
    if ($ScriptOnly -ne $TRUE){
        $restore.script($RestoreSQLServer)
    }
    $null =  $restore.Devices.Remove($restoredevice)    
  }
Write-Verbose "Restore-Database - Leaving " 
}