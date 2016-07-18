function Restore-SQLBackupHeaders 
{
  <#
  .SYNOPSIS
    Given a folder, scans for all SQL Server backup files (bak, trn, etc) and returns an object giving abridged details of each backup


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
    [Alias('ScanPath')]
    [string]$InputPath,
	[string]$logname = 'errors.txt',
  
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [Alias('SQLServer')]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$InputSQL
  )
}