function Restore-SQLBackupHeader
{
  <#
  .SYNOPSIS
    Restore a SQL Backup for only it's headers
  .DESCRIPTION
    PUll the headers from a SQL Server backup file to get information on it's contents. Works with Full, Diff and Transaction log backups.
  .EXAMPLE
    Restore-SQLBackupHeaders -RestoreServer 
  .PARAMETER BackupFile
    path to file to read headers from
  .PARAMETER ServerInstance
    SQL Server Instance to user to perform Header read
  .EXAMPLE
    Restore-SQLBackupHeader -ServerInstance computer1\Instance2 -BackupFile c:\backups\sqlback.trn


  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [System.IO.FileSystemInfo]$BackupFile,

  
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [Alias('SQLServer')]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$ServerInstance
  )

  Write-Verbose "Restore-SQLBackupHeader - Entering"
      $backuptmps = @()
      $restore = New-Object -TypeName Microsoft.SQLServer.Management.Smo.Restore      $devicetype = [Microsoft.SqlServer.Management.Smo.DeviceType]::File        $backupdevice = new-object Microsoft.SqlServer.Management.Smo.BackupDeviceItem -ArgumentList $BackupFile.fullname,$devicetype        $null = $restore.devices.add($backupdevice)        try {            $dt = $restore.readbackupheader($ServerInstance)         }        catch {            Throw "SQL doesn't like file $BackupFile.fullname"            Write-Warning "Error : $_"        }        foreach ($row in $dt) {            $backuptmp = New-BackupObject            $backuptmp.filename = $BackupFile.fullname            $backuptmp.LastLSN = $row.LastLSN            $backuptmp.BackupType = $row.BackupTypeDescription            $backuptmp.StartDate = $row.BackupStartDate            $backuptmp.FinishDate = $row.BackupFinishDate            $backuptmp.DatabaseName = $row.DatabaseName            $backuptmp.SQLVersion = $row.SoftwareVersionMajor            $backuptmp.Position = $row.position            #Naughtily doing 2 things in this function, header and filelist. Could split below out, but that would add an extra SQL connection Object and call for every file. Is the performance hit worth it for a little bit of bad practice?            $dbfiles = $Restore.readfilelist($ServerInstance)            $backuptmp.TotalSize = ($dbfiles.size | Measure-object -sum).sum            $backuptmp.Files = $dbfiles            $backuptmps += $backuptmp        }        $null = $restore.devices.remove($backupdevice)        remove-variable backupdevice

  Write-Verbose "Restore-SQLBackupHeader - Exiting"
  return $backuptmps
}