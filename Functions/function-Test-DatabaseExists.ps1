function Test-DatabaseExists
{
 <#
  .SYNOPSIS
    Checks if a database exists on a specified sql instance
  .DESCRIPTION
    Check to see if a database exists before restoring a database to make sure we don't clobber anything important.
    Also checks for system databases (master, model, msdb, temp)
  .EXAMPLE
    Test-DatabaseExists -RestoreSQLServer $sqlvr -DatabaseName $dbname
  .PARAMETER RestoreSQLServer
    A SQL server SMO connection object
  .PARAMETER DatabaseName
    Database Name to check
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [String]$DatabaseName,
    [Parameter(Mandatory=$True)]
    [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$RestoreSQLServer
  )
  if ($RestoreSQLServer.Databases.Contains($DatabaseName)){
    return $true
  } else {
    return $false
  }
}