﻿function Restore-SQLBackupHeader
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
      $restore = New-Object -TypeName Microsoft.SQLServer.Management.Smo.Restore

  Write-Verbose "Restore-SQLBackupHeader - Exiting"
  return $backuptmps
}