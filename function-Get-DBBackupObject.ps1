function Get-DBBackupObject
{
  <#
  .SYNOPSIS
    Given a folder, scans for all SQL Server backup files (bak, trn, etc) and returns an object giving abridged details of each backup
  .DESCRIPTION
   A wrapper function around RESTORE FILELISTONLY and RESTORE HEADERONLY to pull back information contained with SQL Server backup files.

  .EXAMPLE
    Get-RandomElement -InputArray $Arraylist
  .PARAMETER InputArray
    ArrayList to work with

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [String]$InputPath,
  
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [Alias('SQLServer')]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$ServerInstance
  )
    Write-Verbose "Get-DBBackupObjects - Entering"
    $objbackups = @()    Write-Verbose "Get-DBBackupObjects - Getting files"    foreach ($file in (Get-ChildItem $InputPath\* -include *.bak, *.trn)) {        Write-Verbose "Get-DBBackupObjects - Checking file $file"        $objbackups += Restore-SQLBackupHeader -BackupFile $file -ServerInstance $ServerInstance    }
    Write-Verbose "Get-DBBackupObjects - Leaving function ($objbackups).count found"
    return $objbackups
}