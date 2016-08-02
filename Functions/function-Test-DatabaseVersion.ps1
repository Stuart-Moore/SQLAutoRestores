function Test-DatabaseVersion
{
 <#
  .SYNOPSIS
    Check db is a version that can be restored
  .DESCRIPTION
    Given a set of files to restore, checks they can be restored on the specified SQL Server version
    Basic check of not being able to restore backups from more than 2 Major Versions before.
  .EXAMPLE
    Test-DatabaseVersion -Backups $Backups -SQLServer $sqlsvr
  .PARAMETER Backups
    A list of SQL backups, as provided by Get-DBBackupObject
  .PARAMETER RestoreSQLServer
    SMO SQL Server connection objectr
#>
  [CmdletBinding()]
  param
  (
   [Parameter(Mandatory=$True)]
    [object]$BackupObject,
    [Parameter(Mandatory=$True)]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$RestoreSQLServer
  )
   Write-Verbose "Test-DatabaseVersion - Entering " 
   $version = Get-SQLServerMajorVersion -RestoreSQLServer $RestoreSQLServer
  if(($version -gt ($BackupObject[0].SQLVersion+2)) -or ($version -lt ($BackupObject[0].SQLVersion)) ){
        Write-debug "Cannot restore a backup due to SQL Server Version incompatabilities. Backup is version $($BackupObject[1].SQLVersion) and SQL Server is $($RestoreSQLServer.versionMajor)"
        $false 
  }else{
        $true
    }
  Write-Verbose "Test-DatabaseVersion - Leaving" 
}

function Get-SQLServerMajorVersion
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$RestoreSQLServer
  )
  return $RestoreSQLServer.VersionMajor
}